import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../models/warranty_model.dart';
import '../repositories/warranty_repository.dart';

part 'warranty_list_vm.g.dart';

@riverpod
class WarrantyList extends _$WarrantyList {
  @override
  FutureOr<List<WarrantyModel>> build() async {
    return _fetchWarranties();
  }

  Future<List<WarrantyModel>> _fetchWarranties() async {
    final repository = WarrantyRepository(Dio());
    final result = await repository.getWarranties();

    return result.fold(
          (failure) => throw Exception(failure.message),
          (warranties) => warranties,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWarranties());
  }
}