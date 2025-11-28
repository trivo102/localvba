import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/group/group_user_model.dart';

abstract class GroupUserRepository {
  Future<Either<String, List<GroupUserModel>>> getGroupUsers({
    required String groupId,
    int page,
    int take,
    bool takeAll,
  });
}
