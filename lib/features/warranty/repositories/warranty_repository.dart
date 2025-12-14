import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failures.dart';
import '../models/warranty_model.dart';

class WarrantyRepository {
  final Dio _dio;

  WarrantyRepository(this._dio);

  Future<Either<Failure, List<WarrantyModel>>> getWarranties() async {
    try {
      final response = await _dio.get('/warranties');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final warranties = data.map((json) => WarrantyModel.fromJson(json)).toList();
        return Right(warranties);
      } else {
        return Left(ServerFailure('Error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> createWarranty(WarrantyModel warranty) async {
    try {
      final response = await _dio.post(
        '/warranties',
        data: warranty.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateWarranty(WarrantyModel warranty) async {
    try {
      final response = await _dio.put(
        '/warranties/${warranty.id}',
        data: warranty.toJson(),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteWarranty(String id) async {
    try {
      final response = await _dio.delete('/warranties/$id');

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}