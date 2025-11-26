part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedLoadRequested extends FeedEvent {
  final bool isRefresh;

  const FeedLoadRequested({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class FeedLoadMore extends FeedEvent {}