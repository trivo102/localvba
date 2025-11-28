import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/repository/group/group_repository.dart';
import 'package:vba/service_locator.dart';

class GetRecommendedGroupsParams {
  final int page;
  final int take;
  final String? searchQuery;

  GetRecommendedGroupsParams({
    required this.page,
    required this.take,
    this.searchQuery,
  });
}

class GetRecommendedGroupsUseCase
    implements UseCase<Either<String, List<GroupModel>>, GetRecommendedGroupsParams> {
  @override
  Future<Either<String, List<GroupModel>>> call({GetRecommendedGroupsParams? params}) async {
    return await sl<GroupRepository>().getRecommendedGroups(
      page: params?.page ?? 1,
      take: params?.take ?? 12,
      searchQuery: params?.searchQuery,
    );
  }
}