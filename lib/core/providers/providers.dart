import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/warranty/repositories/warranty_repository.dart';

part 'providers.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://693ca9c8b762a4f15c410ab3.mockapi.io',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
}

@riverpod
WarrantyRepository warrantyRepository(WarrantyRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return WarrantyRepository(dio);
}