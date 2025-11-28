import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/repository/group/group_repository.dart';

class GetPendingGroupsParams {
  final int page;
  final int take;
  final String? searchQuery;

  GetPendingGroupsParams({
    this.page = 1,
    this.take = 12,
    this.searchQuery,
  });
}

class GetPendingGroupsUseCase
    implements UseCase<Either<String, List<GroupModel>>, GetPendingGroupsParams> {
  final GroupRepository _groupRepository;

  GetPendingGroupsUseCase(this._groupRepository);

  @override
  Future<Either<String, List<GroupModel>>> call({GetPendingGroupsParams? params}) async {
    final p = params ?? GetPendingGroupsParams();
    return await _groupRepository.getPendingGroups(
      page: p.page,
      take: p.take,
      searchQuery: p.searchQuery,
    );
  }
}
