import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/providers.dart';
import '../models/warranty_model.dart';

part 'warranty_form_vm.g.dart';

enum WarrantyFormStatus { initial, processing, loading, success, error }

@riverpod
class WarrantyForm extends _$WarrantyForm {
  @override
  WarrantyFormState build() {
    return WarrantyFormState();
  }

  void setWarrantyToEdit(WarrantyModel warranty) {
    state = state.copyWith(
      id: warranty.id,
      productName: warranty.productName,
      amount: warranty.amount,
      purchaseDate: warranty.purchaseDate,
      receiptPath: warranty.receiptPath,
      category: warranty.category,
    );
  }

  Future<void> processImage(XFile image) async {
    state = state.copyWith(status: WarrantyFormStatus.processing, receiptPath: image.path);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final text = recognizedText.text;

      String detectedName = "Producto detectado";
      DateTime detectedDate = DateTime.now();

      final lines = text.split('\n');

      double bestAmount = 0.0;
      double maxScore = -5000.0;

      final negativeKeywords = [
        'nit', 'nº', 'no.', 'num', 'n°', 'no ', 'º',
        'factura', 'autorizacion', 'control', 'codigo',
        'cuf', 'cufd', 'limite', 'emision', 'tel', 'cel',
        'sucursal', 'casa', 'matriz', 'sfc', 'original', 'copia',
        'depto', 'ofic', 'piso', 'loc', 'zona', 'barrio', 'uv', 'mz',
        'ci', 'ruc', 'año', 'mes', 'dia', 'fecha', 'hora',
        'actividades', 'servicio', 'ley', 'proveedor', 'cliente'
      ];

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        final lowerLine = line.toLowerCase();

        final matches = RegExp(r'[\d]+(?:[.,]\d+)*').allMatches(line);

        for (var match in matches) {
          String rawNum = match.group(0)!;

          if (rawNum.startsWith('0') && !rawNum.startsWith('0.') && !rawNum.startsWith('0,')) {
            continue;
          }

          double? val = _smartParsePrice(rawNum);

          if (val != null && val > 0 && val < 200000) {

            if (val >= 1900 && val <= 2050 && !rawNum.contains('.')) continue;

            String cleanNum = rawNum.replaceAll(RegExp(r'[.,]'), '');
            if (cleanNum.length >= 8) continue;

            double currentScore = 0.0;

            if (lowerLine.contains('total') && lowerLine.contains('bs')) currentScore += 1000;
            else if (lowerLine.contains('total')) currentScore += 500;
            else if (lowerLine.contains('importe')) currentScore += 400;
            else if (lowerLine.contains('pagar')) currentScore += 300;
            else if (lowerLine.contains('son')) currentScore += 200;

            if (lowerLine.contains('bs') || lowerLine.contains('bolivianos')) currentScore += 150;

            if (negativeKeywords.any((word) => lowerLine.contains(word))) {
              currentScore -= 1000;
            }

            if (rawNum.contains('.') || rawNum.contains(',')) {
              currentScore += 50;
            }

            if (i > lines.length * 0.6) {
              currentScore += 100;
            }

            if (currentScore > maxScore) {
              maxScore = currentScore;
              bestAmount = val;
            }
          }
        }
      }

      final dateRegex = RegExp(r'(\d{1,2})[\s/-]+(\d{1,2})[\s/-]+(\d{2,4})');
      final dateMatch = dateRegex.firstMatch(text);

      if (dateMatch != null) {
        try {
          int day = int.parse(dateMatch.group(1)!);
          int month = int.parse(dateMatch.group(2)!);
          int year = int.parse(dateMatch.group(3)!);

          if (year < 100) year += 2000;
          detectedDate = DateTime(year, month, day);
        } catch (_) {}
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy('${directory.path}/$fileName');

      state = state.copyWith(
        status: WarrantyFormStatus.initial,
        receiptPath: savedImage.path,
        productName: detectedName,
        amount: bestAmount,
        purchaseDate: detectedDate,
      );

      textRecognizer.close();

    } catch (e) {
      state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: 'Error al procesar imagen');
    }
  }

  double? _smartParsePrice(String raw) {
    try {
      String clean = raw.replaceAll(RegExp(r'[^\d.,]'), '');
      if (clean.isEmpty) return null;

      if (clean.contains(',') && clean.contains('.')) {
        clean = clean.replaceAll('.', '').replaceAll(',', '.');
      } else if (clean.contains(',')) {
        clean = clean.replaceAll(',', '.');
      }

      return double.tryParse(clean);
    } catch (e) {
      return null;
    }
  }

  void updateName(String name) => state = state.copyWith(productName: name);
  void updateAmount(double amount) => state = state.copyWith(amount: amount);
  void updateDate(DateTime date) => state = state.copyWith(purchaseDate: date);
  void updateCategory(String category) => state = state.copyWith(category: category);

  Future<void> submitWarranty() async {
    state = state.copyWith(status: WarrantyFormStatus.loading);

    final expiry = state.purchaseDate.add(const Duration(days: 365));
    final repository = ref.read(warrantyRepositoryProvider);

    try {
      if (state.id != null && state.id!.isNotEmpty) {
        final updatedWarranty = WarrantyModel(
          id: state.id!,
          productName: state.productName,
          amount: state.amount,
          purchaseDate: state.purchaseDate,
          expiryDate: expiry,
          receiptPath: state.receiptPath ?? '',
          storeName: '',
          category: state.category,
        );

        final result = await repository.updateWarranty(updatedWarranty);
        result.fold(
              (failure) => state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: failure.message),
              (_) => state = state.copyWith(status: WarrantyFormStatus.success),
        );

      } else {
        final newWarranty = WarrantyModel(
          productName: state.productName,
          amount: state.amount,
          purchaseDate: state.purchaseDate,
          expiryDate: expiry,
          receiptPath: state.receiptPath ?? '',
          storeName: '',
          category: state.category,
        );

        final result = await repository.createWarranty(newWarranty);

        result.fold(
              (failure) => state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: failure.message),
              (_) async {
            try {
              int notifId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
              await NotificationService().scheduleNotification(
                id: notifId,
                title: 'Garantía por vencer',
                body: '${newWarranty.productName} vence pronto.',
                scheduledDate: expiry,
              );
            } catch (_) {}
            state = state.copyWith(status: WarrantyFormStatus.success);
          },
        );
      }
    } catch (e) {
      state = state.copyWith(status: WarrantyFormStatus.error, errorMessage: e.toString());
    }
  }
}

class WarrantyFormState {
  final WarrantyFormStatus status;
  final String? id;
  final String productName;
  final double amount;
  final DateTime purchaseDate;
  final String? receiptPath;
  final String? errorMessage;
  final String category;

  WarrantyFormState({
    this.status = WarrantyFormStatus.initial,
    this.id,
    this.productName = '',
    this.amount = 0.0,
    DateTime? purchaseDate,
    this.receiptPath,
    this.errorMessage,
    this.category = 'General',
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  WarrantyFormState copyWith({
    WarrantyFormStatus? status,
    String? id,
    String? productName,
    double? amount,
    DateTime? purchaseDate,
    String? receiptPath,
    String? errorMessage,
    String? category,
  }) {
    return WarrantyFormState(
      status: status ?? this.status,
      id: id ?? this.id,
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      receiptPath: receiptPath ?? this.receiptPath,
      errorMessage: errorMessage,
      category: category ?? this.category,
    );
  }
}
