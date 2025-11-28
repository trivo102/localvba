part of 'recommended_groups_bloc.dart';

abstract class RecommendedGroupsEvent extends Equatable {
  const RecommendedGroupsEvent();
  @override
  List<Object?> get props => [];
}

class RecommendedGroupsLoadRequested extends RecommendedGroupsEvent {
  final bool isRefresh;
  const RecommendedGroupsLoadRequested({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

class RecommendedGroupsLoadMoreRequested extends RecommendedGroupsEvent {}

class RecommendedGroupsSearchChanged extends RecommendedGroupsEvent {
  final String query;
  const RecommendedGroupsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}