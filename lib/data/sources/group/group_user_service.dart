import 'package:fpdart/fpdart.dart';
import 'package:vba/core/api/rest_client.dart';
import 'package:vba/data/models/group/group_user_model.dart';
import 'package:vba/service_locator.dart';

abstract class GroupUserService {
  Future<Either<String, List<GroupUserModel>>> getGroupUsers({
    required String groupId,
    int page = 1,
    int take = 10,
    bool takeAll = false,
  });
}

class GroupUserServiceImpl extends GroupUserService {
  @override
  Future<Either<String, List<GroupUserModel>>> getGroupUsers({
    required String groupId,
    int page = 1,
    int take = 10,
    bool takeAll = false,
  }) async {
    try {
      final client = RestClient(localDio);
      final res = await client.getGroupUsers(groupId, page, take, takeAll);
      final users = res.data?.users;
      if (users != null) return Right(users);
      return const Left('No users found');
    } catch (e) {
      return Left('Error fetching group users: $e');
    }
  }
}
