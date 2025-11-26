import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/domain/repository/group/group_repository.dart';
import 'package:vba/service_locator.dart';

class GetAttendedGroupsParams {
  final int page;
  final int take;
  final String? searchQuery;

  GetAttendedGroupsParams({
    required this.page,
    required this.take,
    this.searchQuery,
  });
}

class GetAttendedGroupsUseCase
    implements UseCase<Either, GetAttendedGroupsParams> {
  @override
  Future<Either> call({GetAttendedGroupsParams? params}) async {
    return await sl<GroupRepository>().getAttendedGroups(
      page: params?.page ?? 1,
      take: params?.take ?? 8,
      searchQuery: params?.searchQuery,
    );
  }
}
