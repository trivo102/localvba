part of 'managed_groups_bloc.dart';

enum ManagedGroupsStatus { initial, loading, success, failure, loadingMore }

class ManagedGroupsState extends Equatable {
  final ManagedGroupsStatus status;
  final List<GroupModel> groups;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;
  final String searchQuery;

  const ManagedGroupsState({
    this.status = ManagedGroupsStatus.initial,
    this.groups = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMoreData = true,
    this.searchQuery = '',
  });

  ManagedGroupsState copyWith({
    ManagedGroupsStatus? status,
    List<GroupModel>? groups,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
    String? searchQuery,
  }) {
    return ManagedGroupsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        groups,
        errorMessage,
        currentPage,
        hasMoreData,
        searchQuery,
      ];
}
