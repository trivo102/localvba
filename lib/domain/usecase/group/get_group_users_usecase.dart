import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/data/models/group/group_user_model.dart';
import 'package:vba/domain/repository/group/group_user_repository.dart';
import 'package:vba/service_locator.dart';

class GetGroupUsersParams {
  final String groupId;
  final int page;
  final int take;
  final bool takeAll;

  GetGroupUsersParams({
    required this.groupId,
    this.page = 1,
    this.take = 10,
    this.takeAll = false,
  });
}

class GetGroupUsersUseCase
    implements UseCase<Either<String, List<GroupUserModel>>, GetGroupUsersParams> {
  @override
  Future<Either<String, List<GroupUserModel>>> call({GetGroupUsersParams? params}) {
    final p = params!;
    return sl<GroupUserRepository>().getGroupUsers(
      groupId: p.groupId,
      page: p.page,
      take: p.take,
      takeAll: p.takeAll,
    );
  }
}
