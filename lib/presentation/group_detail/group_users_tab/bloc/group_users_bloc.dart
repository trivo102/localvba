import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/group/group_user_model.dart';
import 'package:vba/domain/usecase/group/get_group_users_usecase.dart';
import 'package:vba/service_locator.dart';

part 'group_users_event.dart';
part 'group_users_state.dart';

class GroupUsersBloc extends Bloc<GroupUsersEvent, GroupUsersState> {
  static const int _pageSize = 10;

  GroupUsersBloc() : super(const GroupUsersState()) {
    on<GroupUsersLoadRequested>(_onLoad);
    on<GroupUsersLoadMoreRequested>(_onLoadMore);
    on<GroupUsersRefreshRequested>(_onRefresh);
    on<GroupUsersSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoad(
    GroupUsersLoadRequested event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(state.copyWith(status: GroupUsersStatus.loading, currentPage: 1));
    final result = await sl<GetGroupUsersUseCase>().call(
      params: GetGroupUsersParams(
        groupId: event.groupId,
        page: 1,
        take: _pageSize,
      ),
    );
    result.fold(
      (err) {
        LogHelper.error(tag: 'GroupUsersBloc', message: 'Load error: $err');
        emit(state.copyWith(status: GroupUsersStatus.failure, errorMessage: err));
      },
      (users) {
        emit(state.copyWith(
          status: GroupUsersStatus.success,
          users: users,
          hasMore: users.length >= _pageSize,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onLoadMore(
    GroupUsersLoadMoreRequested event,
    Emitter<GroupUsersState> emit,
  ) async {
    if (!state.hasMore || state.status == GroupUsersStatus.loadingMore) return;
    emit(state.copyWith(status: GroupUsersStatus.loadingMore));
    final next = state.currentPage + 1;
    final result = await sl<GetGroupUsersUseCase>().call(
      params: GetGroupUsersParams(
        groupId: event.groupId,
        page: next,
        take: _pageSize,
      ),
    );
    result.fold(
      (err) {
        LogHelper.error(tag: 'GroupUsersBloc', message: 'Load more error: $err');
        emit(state.copyWith(status: GroupUsersStatus.success));
      },
      (more) {
        emit(state.copyWith(
          status: GroupUsersStatus.success,
          users: [...state.users, ...more],
          currentPage: next,
          hasMore: more.length >= _pageSize,
        ));
      },
    );
  }

  Future<void> _onRefresh(
    GroupUsersRefreshRequested event,
    Emitter<GroupUsersState> emit,
  ) async {
    add(GroupUsersLoadRequested(event.groupId));
  }

  Future<void> _onSearchChanged(
    GroupUsersSearchChanged event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    // Filter locally for now (can integrate API search later)
    // For now just store the query, UI can filter the list
  }
}
