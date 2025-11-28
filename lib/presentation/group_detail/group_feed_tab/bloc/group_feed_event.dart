part of 'group_feed_bloc.dart';

abstract class GroupFeedEvent extends Equatable {
  const GroupFeedEvent();
  @override
  List<Object?> get props => [];
}

class GroupFeedLoadRequested extends GroupFeedEvent {
  final String groupId;
  const GroupFeedLoadRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class GroupFeedLoadMoreRequested extends GroupFeedEvent {
  final String groupId;
  const GroupFeedLoadMoreRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class GroupFeedRefreshRequested extends GroupFeedEvent {
  final String groupId;
  const GroupFeedRefreshRequested(this.groupId);
  @override
  List<Object?> get props => [groupId];
}
