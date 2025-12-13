import 'package:freezed_annotation/freezed_annotation.dart';

part 'warranty_model.freezed.dart';
part 'warranty_model.g.dart';

@freezed
class WarrantyModel with _$WarrantyModel {
  const factory WarrantyModel({
    @Default('') String id,
    @Default('') String productName,
    required DateTime purchaseDate,
    required DateTime expiryDate,
    @Default(0.0) double amount,
    @Default('') String receiptPath,
    @Default('') String storeName,
  }) = _WarrantyModel;

  factory WarrantyModel.fromJson(Map<String, dynamic> json) =>
      _$WarrantyModelFromJson(json);
}