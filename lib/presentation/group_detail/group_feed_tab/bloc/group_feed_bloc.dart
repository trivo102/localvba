import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/domain/usecase/post/get_group_posts_usecase.dart';
import 'package:vba/service_locator.dart';

part 'group_feed_event.dart';
part 'group_feed_state.dart';

class GroupFeedBloc extends Bloc<GroupFeedEvent, GroupFeedState> {
  static const int _pageSize = 10;

  GroupFeedBloc() : super(const GroupFeedState()) {
    on<GroupFeedLoadRequested>(_onLoad);
    on<GroupFeedLoadMoreRequested>(_onLoadMore);
    on<GroupFeedRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    GroupFeedLoadRequested event,
    Emitter<GroupFeedState> emit,
  ) async {
    emit(state.copyWith(status: GroupFeedStatus.loading, currentPage: 1));
    final result = await sl<GetGroupPostsUseCase>().call(
      params: GetGroupPostsParams(groupId: event.groupId, page: 1, take: _pageSize),
    );
    result.fold(
      (err) => emit(state.copyWith(status: GroupFeedStatus.failure, errorMessage: err)),
      (posts) => emit(state.copyWith(
        status: GroupFeedStatus.success,
        posts: posts,
        hasMore: posts.length >= _pageSize,
        currentPage: 1,
      )),
    );
  }

  Future<void> _onLoadMore(
    GroupFeedLoadMoreRequested event,
    Emitter<GroupFeedState> emit,
  ) async {
    if (!state.hasMore || state.status == GroupFeedStatus.loadingMore) return;
    emit(state.copyWith(status: GroupFeedStatus.loadingMore));
    final next = state.currentPage + 1;
    final result = await sl<GetGroupPostsUseCase>().call(
      params: GetGroupPostsParams(groupId: event.groupId, page: next, take: _pageSize),
    );
    result.fold(
      (err) {
        LogHelper.error(tag: 'GroupFeedBloc', message: 'Load more error: $err');
        emit(state.copyWith(status: GroupFeedStatus.success));
      },
      (more) {
        emit(state.copyWith(
          status: GroupFeedStatus.success,
          posts: [...state.posts, ...more],
          currentPage: next,
          hasMore: more.length >= _pageSize,
        ));
      },
    );
  }

  Future<void> _onRefresh(
    GroupFeedRefreshRequested event,
    Emitter<GroupFeedState> emit,
  ) async {
    add(GroupFeedLoadRequested(event.groupId));
  }
}