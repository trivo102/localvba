import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/usecase/group/get_pending_groups.dart';
import 'package:vba/service_locator.dart';

part 'pending_groups_event.dart';
part 'pending_groups_state.dart';

class PendingGroupsBloc extends Bloc<PendingGroupsEvent, PendingGroupsState> {
  static const int _groupsPerPage = 12;

  PendingGroupsBloc() : super(const PendingGroupsState()) {
    on<PendingGroupsLoadRequested>(_onLoadRequested);
    on<PendingGroupsLoadMoreRequested>(_onLoadMoreRequested);
    on<PendingGroupsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadRequested(
    PendingGroupsLoadRequested event,
    Emitter<PendingGroupsState> emit,
  ) async {
    LogHelper.debug(tag: 'PendingGroupsBloc', message: 'Loading pending groups...');
    emit(state.copyWith(status: PendingGroupsStatus.loading, currentPage: 1));

    final result = await sl<GetPendingGroupsUseCase>().call(
      params: GetPendingGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(tag: 'PendingGroupsBloc', message: 'Error: $error');
        emit(state.copyWith(status: PendingGroupsStatus.failure, errorMessage: error));
      },
      (groups) {
        LogHelper.info(tag: 'PendingGroupsBloc', message: 'Loaded ${groups.length} pending groups');
        emit(state.copyWith(
          status: PendingGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onLoadMoreRequested(
    PendingGroupsLoadMoreRequested event,
    Emitter<PendingGroupsState> emit,
  ) async {
    if (!state.hasMoreData || state.status == PendingGroupsStatus.loadingMore) return;

    emit(state.copyWith(status: PendingGroupsStatus.loadingMore));
    final nextPage = state.currentPage + 1;

    final result = await sl<GetPendingGroupsUseCase>().call(
      params: GetPendingGroupsParams(
        page: nextPage,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(tag: 'PendingGroupsBloc', message: 'Error loading more: $error');
        emit(state.copyWith(status: PendingGroupsStatus.success));
      },
      (newGroups) {
        final all = List<GroupModel>.from([...state.groups, ...newGroups]);
        emit(state.copyWith(
          status: PendingGroupsStatus.success,
          groups: all,
          currentPage: nextPage,
          hasMoreData: newGroups.length >= _groupsPerPage,
        ));
      },
    );
  }

  Future<void> _onSearchChanged(
    PendingGroupsSearchChanged event,
    Emitter<PendingGroupsState> emit,
  ) async {
    emit(state.copyWith(
      searchQuery: event.query,
      status: PendingGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetPendingGroupsUseCase>().call(
      params: GetPendingGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: event.query,
      ),
    );

    result.fold(
      (error) {
        emit(state.copyWith(status: PendingGroupsStatus.failure, errorMessage: error));
      },
      (groups) {
        emit(state.copyWith(
          status: PendingGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }
}
