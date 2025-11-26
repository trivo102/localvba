import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/domain/usecase/group/get_attended_groups.dart';
import 'package:vba/service_locator.dart';

part 'attended_groups_event.dart';
part 'attended_groups_state.dart';

class AttendedGroupsBloc
    extends Bloc<AttendedGroupsEvent, AttendedGroupsState> {
  static const int _groupsPerPage = 8;

  AttendedGroupsBloc() : super(const AttendedGroupsState()) {
    on<AttendedGroupsLoadRequested>(_onAttendedGroupsLoadRequested);
    on<AttendedGroupsLoadMoreRequested>(_onAttendedGroupsLoadMoreRequested);
    on<AttendedGroupsSearchChanged>(_onAttendedGroupsSearchChanged);
  }

  Future<void> _onAttendedGroupsLoadRequested(
    AttendedGroupsLoadRequested event,
    Emitter<AttendedGroupsState> emit,
  ) async {
    LogHelper.debug(
        tag: 'AttendedGroupsBloc', message: 'Loading attended groups...');

    emit(state.copyWith(
      status: AttendedGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetAttendedGroupsUseCase>().call(
      params: GetAttendedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'AttendedGroupsBloc',
          message: 'Error loading groups: $error',
        );
        emit(state.copyWith(
          status: AttendedGroupsStatus.failure,
          errorMessage: error,
        ));
      },
      (groups) {
        LogHelper.info(
          tag: 'AttendedGroupsBloc',
          message: 'Groups loaded successfully: ${groups.length} groups',
        );
        emit(state.copyWith(
          status: AttendedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onAttendedGroupsLoadMoreRequested(
    AttendedGroupsLoadMoreRequested event,
    Emitter<AttendedGroupsState> emit,
  ) async {
    if (!state.hasMoreData ||
        state.status == AttendedGroupsStatus.loadingMore) {
      return;
    }

    LogHelper.debug(
      tag: 'AttendedGroupsBloc',
      message: 'Loading more groups, page: ${state.currentPage + 1}',
    );

    emit(state.copyWith(status: AttendedGroupsStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await sl<GetAttendedGroupsUseCase>().call(
      params: GetAttendedGroupsParams(
        page: nextPage,
        take: _groupsPerPage,
        searchQuery: state.searchQuery,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'AttendedGroupsBloc',
          message: 'Error loading more: $error',
        );
        emit(state.copyWith(
          status: AttendedGroupsStatus.success,
          errorMessage: error,
        ));
      },
      (newGroups) {
        LogHelper.info(
          tag: 'AttendedGroupsBloc',
          message: 'Loaded ${newGroups.length} more groups',
        );

        final allGroups =
            List<GroupModel>.from([...state.groups, ...newGroups]);
        emit(state.copyWith(
          status: AttendedGroupsStatus.success,
          groups: allGroups,
          currentPage: nextPage,
          hasMoreData: newGroups.length >= _groupsPerPage,
        ));
      },
    );
  }

  Future<void> _onAttendedGroupsSearchChanged(
    AttendedGroupsSearchChanged event,
    Emitter<AttendedGroupsState> emit,
  ) async {
    LogHelper.debug(
      tag: 'AttendedGroupsBloc',
      message: 'Search query changed: ${event.query}',
    );

    emit(state.copyWith(
      searchQuery: event.query,
      status: AttendedGroupsStatus.loading,
      currentPage: 1,
    ));

    final result = await sl<GetAttendedGroupsUseCase>().call(
      params: GetAttendedGroupsParams(
        page: 1,
        take: _groupsPerPage,
        searchQuery: event.query,
      ),
    );

    result.fold(
      (error) {
        LogHelper.error(
          tag: 'AttendedGroupsBloc',
          message: 'Error searching groups: $error',
        );
        emit(state.copyWith(
          status: AttendedGroupsStatus.failure,
          errorMessage: error,
        ));
      },
      (groups) {
        LogHelper.info(
          tag: 'AttendedGroupsBloc',
          message: 'Search results: ${groups.length} groups',
        );
        emit(state.copyWith(
          status: AttendedGroupsStatus.success,
          groups: groups,
          hasMoreData: groups.length >= _groupsPerPage,
          currentPage: 1,
        ));
      },
    );
  }
}
