import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/data/sources/group/group_service.dart';
import 'package:vba/domain/repository/group/group_repository.dart';
import 'package:vba/service_locator.dart';

class GroupRepositoryImpl extends GroupRepository {
  @override
  Future<Either<String, List<GroupModel>>> getManagedGroups({
    required int page,
    required int take,
    String? searchQuery,
  }) async {
    return sl<GroupService>().getManagedGroups(
      page: page,
      take: take,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<Either<String, List<GroupModel>>> getAttendedGroups({
    required int page,
    required int take,
    String? searchQuery,
  }) async {
    return sl<GroupService>().getAttendedGroups(
      page: page,
      take: take,
      searchQuery: searchQuery,
    );
  }
}
