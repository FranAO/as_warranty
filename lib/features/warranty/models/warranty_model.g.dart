// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarrantyModelImpl _$$WarrantyModelImplFromJson(Map<String, dynamic> json) =>
    _$WarrantyModelImpl(
      id: json['id'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      receiptPath: json['receiptPath'] as String? ?? '',
      storeName: json['storeName'] as String? ?? '',
    );

Map<String, dynamic> _$$WarrantyModelImplToJson(_$WarrantyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'expiryDate': instance.expiryDate.toIso8601String(),
      'amount': instance.amount,
      'receiptPath': instance.receiptPath,
      'storeName': instance.storeName,
    };
