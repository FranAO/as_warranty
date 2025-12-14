import 'package:freezed_annotation/freezed_annotation.dart';

part 'warranty_model.freezed.dart';
part 'warranty_model.g.dart';

double _stringToDouble(dynamic val) {
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

@freezed
class WarrantyModel with _$WarrantyModel {
  const factory WarrantyModel({
    @Default('') String id,
    @Default('') String productName,
    required DateTime purchaseDate,
    required DateTime expiryDate,
    @Default(0.0) @JsonKey(fromJson: _stringToDouble) double amount,
    @Default('') String receiptPath,
    @Default('') String storeName,
    @Default('General') String category,
  }) = _WarrantyModel;

  factory WarrantyModel.fromJson(Map<String, dynamic> json) =>
      _$WarrantyModelFromJson(json);
}