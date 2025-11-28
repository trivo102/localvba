part of 'pending_groups_bloc.dart';

abstract class PendingGroupsEvent extends Equatable {
  const PendingGroupsEvent();

  @override
  List<Object?> get props => [];
}

class PendingGroupsLoadRequested extends PendingGroupsEvent {
  final bool isRefresh;
  const PendingGroupsLoadRequested({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class PendingGroupsLoadMoreRequested extends PendingGroupsEvent {}

class PendingGroupsSearchChanged extends PendingGroupsEvent {
  final String query;
  const PendingGroupsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
