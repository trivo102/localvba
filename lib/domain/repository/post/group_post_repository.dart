import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/post/post.dart';

abstract class GroupPostRepository {
  Future<Either<String, List<PostModel>>> getGroupPosts({
    required String groupId,
    int page,
    int take,
    String order,
    bool includeComments,
  });
}