import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/domain/repository/group/group_repository.dart';
import 'package:vba/service_locator.dart';

class GetManagedGroupsParams {
  final int page;
  final int take;
  final String? searchQuery;

  GetManagedGroupsParams({
    required this.page,
    required this.take,
    this.searchQuery,
  });
}

class GetManagedGroupsUseCase
    implements UseCase<Either, GetManagedGroupsParams> {
  @override
  Future<Either> call({GetManagedGroupsParams? params}) async {
    return await sl<GroupRepository>().getManagedGroups(
      page: params?.page ?? 1,
      take: params?.take ?? 8,
      searchQuery: params?.searchQuery,
    );
  }
}
