part of 'attended_groups_bloc.dart';

enum AttendedGroupsStatus { initial, loading, success, failure, loadingMore }

class AttendedGroupsState extends Equatable {
  final AttendedGroupsStatus status;
  final List<GroupModel> groups;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;
  final String searchQuery;

  const AttendedGroupsState({
    this.status = AttendedGroupsStatus.initial,
    this.groups = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMoreData = true,
    this.searchQuery = '',
  });

  AttendedGroupsState copyWith({
    AttendedGroupsStatus? status,
    List<GroupModel>? groups,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
    String? searchQuery,
  }) {
    return AttendedGroupsState(
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
