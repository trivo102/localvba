import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/post/post.dart';

abstract class FeedRepository {
  Future<Either<String, List<PostModel>>> getFeed({
    int page,
    int take,
    String order,
  });
}