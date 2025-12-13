import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/failures.dart';
import '../models/warranty_model.dart';

class WarrantyRepository {
  final Dio _dio;

  WarrantyRepository(this._dio);

  Future<Either<Failure, List<WarrantyModel>>> getWarranties() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}${ApiConstants.warrantiesEndpoint}');

      final List<dynamic> data = response.data;
      final warranties = data.map((json) => WarrantyModel.fromJson(json)).toList();

      return Right(warranties);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> createWarranty(WarrantyModel warranty) async {
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.warrantiesEndpoint}',
        data: warranty.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}