import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/group/group_model.dart';

abstract class GroupRepository {
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

  Future<Either<String, List<GroupModel>>> getRecommendedGroups({
    required int page,
    required int take,
    String? searchQuery,
  });

  Future<Either<String, List<GroupModel>>> getPendingGroups({
    required int page,
    required int take,
    String? searchQuery,
  });
}
