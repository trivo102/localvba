import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/presentation/groups/managed_groups/bloc/managed_groups_bloc.dart';

/// Tab hiển thị danh sách nhóm bạn quản lý
class ManagedGroupsTab extends StatelessWidget {
  const ManagedGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ManagedGroupsBloc()..add(const ManagedGroupsLoadRequested()),
      child: const ManagedGroupsView(),
    );
  }
}

class ManagedGroupsView extends StatefulWidget {
  const ManagedGroupsView({Key? key}) : super(key: key);

  @override
  State<ManagedGroupsView> createState() => _ManagedGroupsViewState();
}

class _ManagedGroupsViewState extends State<ManagedGroupsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ManagedGroupsBloc>().add(ManagedGroupsLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagedGroupsBloc, ManagedGroupsState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: _buildBody(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm nhóm...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<ManagedGroupsBloc>()
                        .add(const ManagedGroupsSearchChanged(''));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          // Debounce search - chỉ search sau 500ms không gõ
          Future.delayed(const Duration(milliseconds: 500), () {
            if (value == _searchController.text) {
              context
                  .read<ManagedGroupsBloc>()
                  .add(ManagedGroupsSearchChanged(value));
            }
          });
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ManagedGroupsState state) {
    switch (state.status) {
      case ManagedGroupsStatus.initial:
      case ManagedGroupsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ManagedGroupsStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Đã xảy ra lỗi',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<ManagedGroupsBloc>()
                      .add(const ManagedGroupsLoadRequested());
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );

      case ManagedGroupsStatus.success:
      case ManagedGroupsStatus.loadingMore:
        if (state.groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Chưa có nhóm nào',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ManagedGroupsBloc>()
                .add(const ManagedGroupsLoadRequested(isRefresh: true));
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.groups.length + 1,
            itemBuilder: (context, index) {
              // Loading more indicator
              if (index == state.groups.length) {
                return state.status == ManagedGroupsStatus.loadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }

              // Group cards
              final group = state.groups[index];
              return ManagedGroupCard(group: group);
            },
          ),
        );
    }
  }
}

/// Card cho Managed Groups (nhóm bạn quản lý)
class ManagedGroupCard extends StatelessWidget {
  final GroupModel group;
  const ManagedGroupCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to group detail
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Group Photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: group.photo != null
                        ? CachedNetworkImage(
                            imageUrl: group.photo!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.group, size: 30),
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.group, size: 30),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name ?? 'Không có tên',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${group.numberOfMembers ?? 0} thành viên',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              // Member Avatars
              if (group.memberAvatars != null &&
                  group.memberAvatars!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      // Show up to 5 avatars
                      ...group.memberAvatars!
                          .take(5)
                          .map((avatar) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: avatar != null
                                      ? CachedNetworkImageProvider(avatar)
                                      : null,
                                  child: avatar == null
                                      ? const Icon(Icons.person,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                              ))
                          .toList(),
                      if ((group.numberOfMembers ?? 0) > 5)
                        Text(
                          '+${(group.numberOfMembers ?? 0) - 5}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              // User Role (if available)
              if (group.groupUsers != null && group.groupUsers!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      group.groupUsers!.first.role == 'MANAGER'
                          ? 'Quản trị viên'
                          : 'Thành viên',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
