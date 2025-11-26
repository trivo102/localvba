import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/usecase/group/get_managed_groups.dart';
import 'package:vba/service_locator.dart';

part 'managed_groups_event.dart';
part 'managed_groups_state.dart';

class ManagedGroupsBloc
    extends Bloc<ManagedGroupsEvent, ManagedGroupsState> {
  static const int _groupsPerPage = 8;

  ManagedGroupsBloc() : super(const ManagedGroupsState()) {
    on<ManagedGroupsLoadRequested>(_onManagedGroupsLoadRequested);
    on<ManagedGroupsLoadMoreRequested>(_onManagedGroupsLoadMoreRequested);
    on<ManagedGroupsSearchChanged>(_onManagedGroupsSearchChanged);
  }

  Future<void> _onManagedGroupsLoadRequested(
    ManagedGroupsLoadRequested event,
    Emitter<ManagedGroupsState> emit,
  ) async {
    LogHelper.debug(
        tag: 'ManagedGroupsBloc', message: 'Loading managed groups...');

    emit(state.copyWith(
      status: ManagedGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetManagedGroupsUseCase>().call(
      params: GetManagedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'ManagedGroupsBloc',
          message: 'Error loading groups: $error',
        );
        emit(state.copyWith(
          status: ManagedGroupsStatus.failure,
          errorMessage: error,
        ));
      },
      (groups) {
        LogHelper.info(
          tag: 'ManagedGroupsBloc',
          message: 'Groups loaded successfully: ${groups.length} groups',
        );
        emit(state.copyWith(
          status: ManagedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onManagedGroupsLoadMoreRequested(
    ManagedGroupsLoadMoreRequested event,
    Emitter<ManagedGroupsState> emit,
  ) async {
    if (!state.hasMoreData ||
        state.status == ManagedGroupsStatus.loadingMore) {
      return;
    }

    LogHelper.debug(
      tag: 'ManagedGroupsBloc',
      message: 'Loading more groups, page: ${state.currentPage + 1}',
    );

    emit(state.copyWith(status: ManagedGroupsStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await sl<GetManagedGroupsUseCase>().call(
      params: GetManagedGroupsParams(
        page: nextPage,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'ManagedGroupsBloc',
          message: 'Error loading more: $error',
        );
        emit(state.copyWith(
          status: ManagedGroupsStatus.success,
          errorMessage: error,
        ));
      },
      (newGroups) {
        LogHelper.info(
          tag: 'ManagedGroupsBloc',
          message: 'Loaded ${newGroups.length} more groups',
        );

        final allGroups =
            List<GroupModel>.from([...state.groups, ...newGroups]);
        emit(state.copyWith(
          status: ManagedGroupsStatus.success,
          groups: allGroups,
          currentPage: nextPage,
          hasMoreData: newGroups.length >= _groupsPerPage,
        ));
      },
    );
  }

  Future<void> _onManagedGroupsSearchChanged(
    ManagedGroupsSearchChanged event,
    Emitter<ManagedGroupsState> emit,
  ) async {
    LogHelper.debug(
      tag: 'ManagedGroupsBloc',
      message: 'Search query changed: ${event.query}',
    );

    emit(state.copyWith(
      searchQuery: event.query,
      status: ManagedGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetManagedGroupsUseCase>().call(
      params: GetManagedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: event.query,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'ManagedGroupsBloc',
          message: 'Error searching groups: $error',
        );
        emit(state.copyWith(
          status: ManagedGroupsStatus.failure,
          errorMessage: error,
        ));
      },
      (groups) {
        LogHelper.info(
          tag: 'ManagedGroupsBloc',
          message: 'Search results: ${groups.length} groups',
        );
        emit(state.copyWith(
          status: ManagedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }
}
