part of 'managed_groups_bloc.dart';

abstract class ManagedGroupsEvent extends Equatable {
  const ManagedGroupsEvent();

  @override
  List<Object?> get props => [];
}

class ManagedGroupsLoadRequested extends ManagedGroupsEvent {
  final bool isRefresh;

  const ManagedGroupsLoadRequested({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ManagedGroupsLoadMoreRequested extends ManagedGroupsEvent {}

class ManagedGroupsSearchChanged extends ManagedGroupsEvent {
  final String query;

  const ManagedGroupsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
