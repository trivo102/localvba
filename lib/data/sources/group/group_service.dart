import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vba/core/api/rest_client.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/service_locator.dart';

abstract class GroupService  {
  Future<Either<String, List<GroupModel>>> getManagedGroups({
    required int page,
    required int take,
    String? searchQuery,
  });

  Future<Either<String, List<GroupModel>>> getAttendedGroups({
    required int page,
    required int take,
    String? searchQuery,
  });
}


class GroupServiceImpl extends GroupService {
  @override
  Future<Either<String, List<GroupModel>>> getManagedGroups({
    required int page,
    required int take,
    String? searchQuery,
  }) async {
    try {
      final client = RestClient(localDio);
      final response = await client.getManagedGroups(
        page,
        take,
        'DESC',
        'createdAt',
        searchQuery ?? '',
        false,
      );

      if (response.data?.data != null) {
        return Right(response.data!.data!);
      }
      return const Left('No data available');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.error == 'UNAUTHORIZED') {
        return const Left('UNAUTHORIZED');
      }
      return Left(e.message ?? 'Failed to fetch managed groups');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<GroupModel>>> getAttendedGroups({
    required int page,
    required int take,
    String? searchQuery,
  }) async {
    try {
      final client = RestClient(localDio);
      final response = await client.getAttendedGroups(
        page,
        take,
        'DESC',
        'createdAt',
        searchQuery ?? '',
        false,
      );

      if (response.data?.data != null) {
        return Right(response.data!.data!);
      }
      return const Left('No data available');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.error == 'UNAUTHORIZED') {
        return const Left('UNAUTHORIZED');
      }
      return Left(e.message ?? 'Failed to fetch attended groups');
    } catch (e) {
      return Left(e.toString());
    }
  }
}