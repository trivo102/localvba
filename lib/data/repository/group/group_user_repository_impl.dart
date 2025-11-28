import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/group/group_user_model.dart';
import 'package:vba/data/sources/group/group_user_service.dart';
import 'package:vba/domain/repository/group/group_user_repository.dart';
import 'package:vba/service_locator.dart';

class GroupUserRepositoryImpl extends GroupUserRepository {
  @override
  Future<Either<String, List<GroupUserModel>>> getGroupUsers({
    required String groupId,
    int page = 1,
    int take = 10,
    bool takeAll = false,
  }) {
    return sl<GroupUserService>().getGroupUsers(
      groupId: groupId,
      page: page,
      take: take,
      takeAll: takeAll,
    );
  }
}
