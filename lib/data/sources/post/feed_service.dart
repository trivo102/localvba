import 'package:fpdart/fpdart.dart';
import 'package:vba/core/api/rest_client.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/service_locator.dart';

abstract class FeedService {
  Future<Either<String, List<PostModel>>> getFeed({
    int page = 1,
    int take = 10,
    String order = 'DESC',
  });
}

class FeedServiceImpl extends FeedService {
  @override
  Future<Either<String, List<PostModel>>> getFeed({
    int page = 1,
    int take = 10,
    String order = 'DESC',
  }) async {
    try {
      final client = RestClient(localDio);
      final response = await client.getFeed(page, take, order);
      final items = response.data?.items;
      
      if (items != null) {
        return Right(items);
      }
      return const Left('No feed data found');
    } catch (e) {
      return Left('Error fetching feed: $e');
    }
  }
}