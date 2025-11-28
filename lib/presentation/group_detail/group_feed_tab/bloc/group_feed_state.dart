part of 'group_feed_bloc.dart';

enum GroupFeedStatus { initial, loading, success, failure, loadingMore }

class GroupFeedState extends Equatable {
  final GroupFeedStatus status;
  final List<PostModel> posts;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const GroupFeedState({
    this.status = GroupFeedStatus.initial,
    this.posts = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  GroupFeedState copyWith({
    GroupFeedStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return GroupFeedState(
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