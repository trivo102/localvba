part of 'group_users_bloc.dart';

abstract class GroupUsersEvent extends Equatable {
  const GroupUsersEvent();
  @override
  List<Object?> get props => [];
}

class GroupUsersLoadRequested extends GroupUsersEvent {
  final String groupId;
  const GroupUsersLoadRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class GroupUsersLoadMoreRequested extends GroupUsersEvent {
  final String groupId;
  const GroupUsersLoadMoreRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class GroupUsersRefreshRequested extends GroupUsersEvent {
  final String groupId;
  const GroupUsersRefreshRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class GroupUsersSearchChanged extends GroupUsersEvent {
  final String query;
  const GroupUsersSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
