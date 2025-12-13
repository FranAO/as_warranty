import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../models/warranty_model.dart';
import '../repositories/warranty_repository.dart';

part 'warranty_form_vm.g.dart';

enum WarrantyFormStatus { initial, processing, loading, success, error }

@riverpod
class WarrantyForm extends _$WarrantyForm {
  @override
  WarrantyFormState build() {
    return WarrantyFormState();
  }

  Future<void> processImage(XFile image) async {
    state = state.copyWith(status: WarrantyFormStatus.processing, receiptPath: image.path);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      final text = recognizedText.text;

      double detectedAmount = 0.0;
      String detectedName = "Producto detectado";
      DateTime detectedDate = DateTime.now();

      final lines = text.split('\n');
      bool totalFound = false;

      for (var line in lines) {
        final lowerLine = line.toLowerCase();

        if (lowerLine.contains('total') || lowerLine.contains('importe') || lowerLine.contains('suma')) {
          final amountRegex = RegExp(r'[\d]+[.,][\d]{2}');
          final matches = amountRegex.allMatches(line);

          if (matches.isNotEmpty) {
            final match = matches.last;
            String cleanNum = match.group(0)!.replaceAll(',', '.');
            double val = double.tryParse(cleanNum) ?? 0.0;
            if (val > detectedAmount) {
              detectedAmount = val;
              totalFound = true;
            }
          }
        }
      }

      if (!totalFound) {
        final allNumbersRegex = RegExp(r'[\d]+[.,][\d]{2}');
        final matches = allNumbersRegex.allMatches(text);
        double maxNum = 0.0;

        for (var match in matches) {
          String cleanNum = match.group(0)!.replaceAll(',', '.');
          double current = double.tryParse(cleanNum) ?? 0.0;
          if (current > maxNum) {
            maxNum = current;
          }
        }
        if (maxNum > 0) detectedAmount = maxNum;
      }

      final dateRegex = RegExp(r'(\d{2}[/-]\d{2}[/-]\d{4})|(\d{4}[/-]\d{2}[/-]\d{2})');
      final dateMatch = dateRegex.firstMatch(text);
      if (dateMatch != null) {
        try {
          String dateStr = dateMatch.group(0)!.replaceAll('-', '/');
          List<String> parts = dateStr.split('/');
          if (parts.isNotEmpty) {
            if (parts[0].length == 4) {
              detectedDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
            } else {
              detectedDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
            }
          }
        } catch (_) {}
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy('${directory.path}/$fileName');

      state = state.copyWith(
        status: WarrantyFormStatus.initial,
        receiptPath: savedImage.path,
        productName: detectedName,
        amount: detectedAmount,
        purchaseDate: detectedDate,
      );

      textRecognizer.close();

    } catch (e) {
      state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: 'Error al leer recibo: $e');
    }
  }

  void updateName(String name) => state = state.copyWith(productName: name);
  void updateAmount(double amount) => state = state.copyWith(amount: amount);
  void updateDate(DateTime date) => state = state.copyWith(purchaseDate: date);

  Future<void> submitWarranty() async {
    state = state.copyWith(status: WarrantyFormStatus.loading);

    final expiry = state.purchaseDate.add(const Duration(days: 365));

    final newWarranty = WarrantyModel(
      productName: state.productName,
      amount: state.amount,
      purchaseDate: state.purchaseDate,
      expiryDate: expiry,
      receiptPath: state.receiptPath ?? '',
      storeName: 'Tienda Desconocida',
    );

    final repository = WarrantyRepository(Dio());
    final result = await repository.createWarranty(newWarranty);

    result.fold(
          (failure) => state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: failure.message),
          (_) => state = state.copyWith(status: WarrantyFormStatus.success),
    );
  }
}

class WarrantyFormState {
  final WarrantyFormStatus status;
  final String productName;
  final double amount;
  final DateTime purchaseDate;
  final String? receiptPath;
  final String? errorMessage;

  WarrantyFormState({
    this.status = WarrantyFormStatus.initial,
    this.productName = '',
    this.amount = 0.0,
    DateTime? purchaseDate,
    this.receiptPath,
    this.errorMessage,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  WarrantyFormState copyWith({
    WarrantyFormStatus? status,
    String? productName,
    double? amount,
    DateTime? purchaseDate,
    String? receiptPath,
    String? errorMessage,
  }) {
    return WarrantyFormState(
      status: status ?? this.status,
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      receiptPath: receiptPath ?? this.receiptPath,
      errorMessage: errorMessage,
    );
  }
}