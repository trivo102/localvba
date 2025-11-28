part of 'recommended_groups_bloc.dart';

enum RecommendedGroupsStatus { initial, loading, success, failure, loadingMore }

class RecommendedGroupsState extends Equatable {
  final RecommendedGroupsStatus status;
  final List<GroupModel> groups;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;
  final String searchQuery;

  const RecommendedGroupsState({
    this.status = RecommendedGroupsStatus.initial,
    this.groups = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMoreData = true,
    this.searchQuery = '',
  });

  RecommendedGroupsState copyWith({
    RecommendedGroupsStatus? status,
    List<GroupModel>? groups,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
    String? searchQuery,
  }) {
    return RecommendedGroupsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [status, groups, errorMessage, currentPage, hasMoreData, searchQuery];
}