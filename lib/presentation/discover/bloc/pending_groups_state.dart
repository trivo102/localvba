part of 'pending_groups_bloc.dart';

enum PendingGroupsStatus { initial, loading, success, failure, loadingMore }

class PendingGroupsState extends Equatable {
  final PendingGroupsStatus status;
  final List<GroupModel> groups;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;
  final String? searchQuery;

  const PendingGroupsState({
    this.status = PendingGroupsStatus.initial,
    this.groups = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMoreData = true,
    this.searchQuery,
  });

  PendingGroupsState copyWith({
    PendingGroupsStatus? status,
    List<GroupModel>? groups,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
    String? searchQuery,
  }) {
    return PendingGroupsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, groups, errorMessage, currentPage, hasMoreData, searchQuery];
}
