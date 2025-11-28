import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/domain/repository/post/group_post_repository.dart';
import 'package:vba/service_locator.dart';

class GetGroupPostsParams {
  final String groupId;
  final int page;
  final int take;
  final String order;
  final bool includeComments;

  GetGroupPostsParams({
    required this.groupId,
    this.page = 1,
    this.take = 10,
    this.order = 'DESC',
    this.includeComments = false,
  });
}

class GetGroupPostsUseCase
    implements UseCase<Either<String, List<PostModel>>, GetGroupPostsParams> {
  @override
  Future<Either<String, List<PostModel>>> call({GetGroupPostsParams? params}) {
    final p = params!;
    return sl<GroupPostRepository>().getGroupPosts(
      groupId: p.groupId,
      page: p.page,
      take: p.take,
      order: p.order,
      includeComments: p.includeComments,
    );
  }
}