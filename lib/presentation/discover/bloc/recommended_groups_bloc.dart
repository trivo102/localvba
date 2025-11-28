import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/usecase/group/get_recommended_groups.dart';
import 'package:vba/service_locator.dart';

part 'recommended_groups_event.dart';
part 'recommended_groups_state.dart';

class RecommendedGroupsBloc
    extends Bloc<RecommendedGroupsEvent, RecommendedGroupsState> {
  static const int _groupsPerPage = 12;

  RecommendedGroupsBloc() : super(const RecommendedGroupsState()) {
    on<RecommendedGroupsLoadRequested>(_onLoadRequested);
    on<RecommendedGroupsLoadMoreRequested>(_onLoadMoreRequested);
    on<RecommendedGroupsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadRequested(
    RecommendedGroupsLoadRequested event,
    Emitter<RecommendedGroupsState> emit,
  ) async {
    LogHelper.debug(tag: 'RecommendedGroupsBloc', message: 'Loading recommended groups...');
    emit(state.copyWith(status: RecommendedGroupsStatus.loading, currentPage: 1));

    final result = await sl<GetRecommendedGroupsUseCase>().call(
      params: GetRecommendedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(tag: 'RecommendedGroupsBloc', message: 'Error: $error');
        emit(state.copyWith(status: RecommendedGroupsStatus.failure, errorMessage: error));
      },
      (groups) {
        LogHelper.info(tag: 'RecommendedGroupsBloc', message: 'Loaded ${groups.length} groups');
        emit(state.copyWith(
          status: RecommendedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onLoadMoreRequested(
    RecommendedGroupsLoadMoreRequested event,
    Emitter<RecommendedGroupsState> emit,
  ) async {
    if (!state.hasMoreData || state.status == RecommendedGroupsStatus.loadingMore) return;

    emit(state.copyWith(status: RecommendedGroupsStatus.loadingMore));
    final nextPage = state.currentPage + 1;

    final result = await sl<GetRecommendedGroupsUseCase>().call(
      params: GetRecommendedGroupsParams(
        page: nextPage,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(tag: 'RecommendedGroupsBloc', message: 'Error loading more: $error');
        emit(state.copyWith(status: RecommendedGroupsStatus.success));
      },
      (newGroups) {
        final all = List<GroupModel>.from([...state.groups, ...newGroups]);
        emit(state.copyWith(
          status: RecommendedGroupsStatus.success,
          groups: all,
          currentPage: nextPage,
          hasMoreData: newGroups.length >= _groupsPerPage,
        ));
      },
    );
  }

  Future<void> _onSearchChanged(
    RecommendedGroupsSearchChanged event,
    Emitter<RecommendedGroupsState> emit,
  ) async {
    emit(state.copyWith(
      searchQuery: event.query,
      status: RecommendedGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetRecommendedGroupsUseCase>().call(
      params: GetRecommendedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: event.query,
      ),
    );

    result.fold(
      (error) {
        emit(state.copyWith(status: RecommendedGroupsStatus.failure, errorMessage: error));
      },
      (groups) {
        emit(state.copyWith(
          status: RecommendedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }
}