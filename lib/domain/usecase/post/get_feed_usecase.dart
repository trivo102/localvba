
import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/domain/repository/post/feed_repository.dart';
import 'package:vba/service_locator.dart';

class GetFeedParams {
  final int page;
  final int take;
  final String order;

  GetFeedParams({
    this.page = 1,
    this.take = 10,
    this.order = 'DESC',
  });
}

class GetFeedUseCase implements UseCase<Either<String, List<PostModel>>, GetFeedParams> {
  @override
  Future<Either<String, List<PostModel>>> call({GetFeedParams? params}) async {
    final feedParams = params ?? GetFeedParams();
    return await sl<FeedRepository>().getFeed(
      page: feedParams.page,
      take: feedParams.take,
      order: feedParams.order,
    );
  }
}