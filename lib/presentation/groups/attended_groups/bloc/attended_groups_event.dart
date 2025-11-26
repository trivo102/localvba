part of 'attended_groups_bloc.dart';

abstract class AttendedGroupsEvent extends Equatable {
  const AttendedGroupsEvent();

  @override
  List<Object?> get props => [];
}

class AttendedGroupsLoadRequested extends AttendedGroupsEvent {
  final bool isRefresh;

  const AttendedGroupsLoadRequested({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class AttendedGroupsLoadMoreRequested extends AttendedGroupsEvent {}

class AttendedGroupsSearchChanged extends AttendedGroupsEvent {
  final String query;

  const AttendedGroupsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
