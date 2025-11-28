part of 'group_users_bloc.dart';

enum GroupUsersStatus { initial, loading, success, failure, loadingMore }

class GroupUsersState extends Equatable {
  final GroupUsersStatus status;
  final List<GroupUserModel> users;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final String searchQuery;

  const GroupUsersState({
    this.status = GroupUsersStatus.initial,
    this.users = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery = '',
  });

  GroupUsersState copyWith({
    GroupUsersStatus? status,
    List<GroupUserModel>? users,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
  }) {
    return GroupUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [status, users, errorMessage, currentPage, hasMore, searchQuery];
}
