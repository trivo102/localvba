part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure, loadingMore }

class FeedState extends Equatable {
  final FeedStatus status;
  final List<PostModel> posts;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage, currentPage, hasMore];
}