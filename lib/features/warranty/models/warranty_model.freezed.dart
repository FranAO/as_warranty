// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warranty_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WarrantyModel _$WarrantyModelFromJson(Map<String, dynamic> json) {
  return _WarrantyModel.fromJson(json);
}

/// @nodoc
mixin _$WarrantyModel {
  String get id => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  DateTime get purchaseDate => throw _privateConstructorUsedError;
  DateTime get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringToDouble)
  double get amount => throw _privateConstructorUsedError;
  String get receiptPath => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this WarrantyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WarrantyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarrantyModelCopyWith<WarrantyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarrantyModelCopyWith<$Res> {
  factory $WarrantyModelCopyWith(
    WarrantyModel value,
    $Res Function(WarrantyModel) then,
  ) = _$WarrantyModelCopyWithImpl<$Res, WarrantyModel>;
  @useResult
  $Res call({
    String id,
    String productName,
    DateTime purchaseDate,
    DateTime expiryDate,
    @JsonKey(fromJson: _stringToDouble) double amount,
    String receiptPath,
    String storeName,
    String category,
  });
}

/// @nodoc
class _$WarrantyModelCopyWithImpl<$Res, $Val extends WarrantyModel>
    implements $WarrantyModelCopyWith<$Res> {
  _$WarrantyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarrantyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? purchaseDate = null,
    Object? expiryDate = null,
    Object? amount = null,
    Object? receiptPath = null,
    Object? storeName = null,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseDate: null == purchaseDate
                ? _value.purchaseDate
                : purchaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiryDate: null == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            receiptPath: null == receiptPath
                ? _value.receiptPath
                : receiptPath // ignore: cast_nullable_to_non_nullable
                      as String,
            storeName: null == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WarrantyModelImplCopyWith<$Res>
    implements $WarrantyModelCopyWith<$Res> {
  factory _$$WarrantyModelImplCopyWith(
    _$WarrantyModelImpl value,
    $Res Function(_$WarrantyModelImpl) then,
  ) = __$$WarrantyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productName,
    DateTime purchaseDate,
    DateTime expiryDate,
    @JsonKey(fromJson: _stringToDouble) double amount,
    String receiptPath,
    String storeName,
    String category,
  });
}

/// @nodoc
class __$$WarrantyModelImplCopyWithImpl<$Res>
    extends _$WarrantyModelCopyWithImpl<$Res, _$WarrantyModelImpl>
    implements _$$WarrantyModelImplCopyWith<$Res> {
  __$$WarrantyModelImplCopyWithImpl(
    _$WarrantyModelImpl _value,
    $Res Function(_$WarrantyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WarrantyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? purchaseDate = null,
    Object? expiryDate = null,
    Object? amount = null,
    Object? receiptPath = null,
    Object? storeName = null,
    Object? category = null,
  }) {
    return _then(
      _$WarrantyModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseDate: null == purchaseDate
            ? _value.purchaseDate
            : purchaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiryDate: null == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        receiptPath: null == receiptPath
            ? _value.receiptPath
            : receiptPath // ignore: cast_nullable_to_non_nullable
                  as String,
        storeName: null == storeName
            ? _value.storeName
            : storeName // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WarrantyModelImpl implements _WarrantyModel {
  const _$WarrantyModelImpl({
    this.id = '',
    this.productName = '',
    required this.purchaseDate,
    required this.expiryDate,
    @JsonKey(fromJson: _stringToDouble) this.amount = 0.0,
    this.receiptPath = '',
    this.storeName = '',
    this.category = 'General',
  });

  factory _$WarrantyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarrantyModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String productName;
  @override
  final DateTime purchaseDate;
  @override
  final DateTime expiryDate;
  @override
  @JsonKey(fromJson: _stringToDouble)
  final double amount;
  @override
  @JsonKey()
  final String receiptPath;
  @override
  @JsonKey()
  final String storeName;
  @override
  @JsonKey()
  final String category;

  @override
  String toString() {
    return 'WarrantyModel(id: $id, productName: $productName, purchaseDate: $purchaseDate, expiryDate: $expiryDate, amount: $amount, receiptPath: $receiptPath, storeName: $storeName, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarrantyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.receiptPath, receiptPath) ||
                other.receiptPath == receiptPath) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productName,
    purchaseDate,
    expiryDate,
    amount,
    receiptPath,
    storeName,
    category,
  );

  /// Create a copy of WarrantyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarrantyModelImplCopyWith<_$WarrantyModelImpl> get copyWith =>
      __$$WarrantyModelImplCopyWithImpl<_$WarrantyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarrantyModelImplToJson(this);
  }
}

abstract class _WarrantyModel implements WarrantyModel {
  const factory _WarrantyModel({
    final String id,
    final String productName,
    required final DateTime purchaseDate,
    required final DateTime expiryDate,
    @JsonKey(fromJson: _stringToDouble) final double amount,
    final String receiptPath,
    final String storeName,
    final String category,
  }) = _$WarrantyModelImpl;

  factory _WarrantyModel.fromJson(Map<String, dynamic> json) =
      _$WarrantyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productName;
  @override
  DateTime get purchaseDate;
  @override
  DateTime get expiryDate;
  @override
  @JsonKey(fromJson: _stringToDouble)
  double get amount;
  @override
  String get receiptPath;
  @override
  String get storeName;
  @override
  String get category;

  /// Create a copy of WarrantyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarrantyModelImplCopyWith<_$WarrantyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
