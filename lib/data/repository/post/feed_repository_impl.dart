import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/data/sources/post/feed_service.dart';
import 'package:vba/domain/repository/post/feed_repository.dart';
import 'package:vba/service_locator.dart';

class FeedRepositoryImpl extends FeedRepository {
  @override
  Future<Either<String, List<PostModel>>> getFeed({
    int page = 1,
    int take = 10,
    String order = 'DESC',
  }) async {
    return await sl<FeedService>().getFeed(
      page: page,
      take: take,
      order: order,
    );
  }
}