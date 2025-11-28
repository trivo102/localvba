import 'package:fpdart/fpdart.dart';
import 'package:vba/core/api/rest_client.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/service_locator.dart';

abstract class GroupPostService {
  Future<Either<String, List<PostModel>>> getGroupPosts({
    required String groupId,
    int page = 1,
    int take = 10,
    String order = 'DESC',
    bool includeComments = false,
  });
}

class GroupPostServiceImpl extends GroupPostService {
  @override
  Future<Either<String, List<PostModel>>> getGroupPosts({
    required String groupId,
    int page = 1,
    int take = 10,
    String order = 'DESC',
    bool includeComments = false,
  }) async {
    try {
      final client = RestClient(localDio);
      final res = await client.getGroupPosts(
        groupId, page, take, order, includeComments,
      );
      final items = res.data?.items;
      if (items != null) return Right(items);
      return const Left('No posts');
    } catch (e) {
      return Left('Group feed error: $e');
    }
  }
}