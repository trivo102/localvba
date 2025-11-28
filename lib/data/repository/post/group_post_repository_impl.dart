import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/data/sources/post/group_post_service.dart';
import 'package:vba/domain/repository/post/group_post_repository.dart';
import 'package:vba/service_locator.dart';

class GroupPostRepositoryImpl extends GroupPostRepository {
  @override
  Future<Either<String, List<PostModel>>> getGroupPosts({
    required String groupId,
    int page = 1,
    int take = 10,
    String order = 'DESC',
    bool includeComments = false,
  }) {
    return sl<GroupPostService>().getGroupPosts(
      groupId: groupId,
      page: page,
      take: take,
      order: order,
      includeComments: includeComments,
    );
  }
}