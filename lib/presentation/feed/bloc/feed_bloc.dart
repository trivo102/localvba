import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/domain/usecase/post/get_feed_usecase.dart';
import 'package:vba/service_locator.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedState()) {
    on<FeedLoadRequested>(_onFeedLoadRequested);
    on<FeedLoadMore>(_onFeedLoadMore);
  }

  Future<void> _onFeedLoadRequested(
    FeedLoadRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: event.isRefresh ? FeedStatus.loading : FeedStatus.loading,
        currentPage: 1,
      ));

      final result = await sl<GetFeedUseCase>().call(
        params: GetFeedParams(page: 1, take: 10, order: 'DESC'),
      );

      result.fold(
        (error) {
          LogHelper.error(tag: 'FeedBloc', message: 'Error: $error');
          emit(state.copyWith(
            status: FeedStatus.failure,
            errorMessage: error,
          ));
        },
        (posts) {
          emit(state.copyWith(
            status: FeedStatus.success,
            posts: posts,
            hasMore: posts.length >= 10,
            currentPage: 1,
          ));
        },
      );
    } catch (e) {
      LogHelper.error(tag: 'FeedBloc', message: 'Exception: $e');
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: 'An error occurred',
      ));
    }
  }

  Future<void> _onFeedLoadMore(
    FeedLoadMore event,
    Emitter<FeedState> emit,
  ) async {
    if (!state.hasMore || state.status == FeedStatus.loadingMore) return;

    try {
      emit(state.copyWith(status: FeedStatus.loadingMore));

      final nextPage = state.currentPage + 1;
      final result = await sl<GetFeedUseCase>().call(
        params: GetFeedParams(page: nextPage, take: 10, order: 'DESC'),
      );

      result.fold(
        (error) {
          LogHelper.error(tag: 'FeedBloc', message: 'Error loading more: $error');
          emit(state.copyWith(status: FeedStatus.success));
        },
        (newPosts) {
          final updatedPosts = [...state.posts, ...newPosts];
          emit(state.copyWith(
            status: FeedStatus.success,
            posts: updatedPosts,
            currentPage: nextPage,
            hasMore: newPosts.length >= 10,
          ));
        },
      );
    } catch (e) {
      LogHelper.error(tag: 'FeedBloc', message: 'Exception loading more: $e');
      emit(state.copyWith(status: FeedStatus.success));
    }
  }
}
