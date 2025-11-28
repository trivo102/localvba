import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/data/models/group/group_user_model.dart';
import 'package:vba/presentation/group_detail/group_detail_screen.dart';
import 'package:vba/presentation/group_detail/group_users_tab/bloc/group_users_bloc.dart';

class GroupUsersTab extends StatefulWidget {
  const GroupUsersTab({Key? key}) : super(key: key);

  @override
  State<GroupUsersTab> createState() => _GroupUsersTabState();
}

class _GroupUsersTabState extends State<GroupUsersTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String get _groupId {
    final widgetOwner = context.findAncestorWidgetOfExactType<GroupDetailPage>();
    if (widgetOwner != null) {
      return widgetOwner.group.id ?? '';
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['groupId'] is String) {
      return args['groupId'] as String;
    }
    return '';
  }

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
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (offset >= max * 0.9) {
      context.read<GroupUsersBloc>().add(GroupUsersLoadMoreRequested(_groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupUsersBloc()..add(GroupUsersLoadRequested(_groupId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<GroupUsersBloc, GroupUsersState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeaderActions(context, state),
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderActions(BuildContext context, GroupUsersState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nhập tên hoặc email',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<GroupUsersBloc>().add(const GroupUsersSearchChanged(''));
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (value == _searchController.text) {
                  context.read<GroupUsersBloc>().add(GroupUsersSearchChanged(value));
                }
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "All",
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "All", child: Text("Tất cả")),
                        DropdownMenuItem(value: "Manager", child: Text("Quản trị viên")),
                      ],
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add, size: 18, color: Colors.white),
                label: const Text("Thêm", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, GroupUsersState state) {
    switch (state.status) {
      case GroupUsersStatus.initial:
      case GroupUsersStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case GroupUsersStatus.failure:
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
                  context.read<GroupUsersBloc>().add(GroupUsersLoadRequested(_groupId));
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );

      case GroupUsersStatus.success:
      case GroupUsersStatus.loadingMore:
        // Filter users by search query locally
        final filteredUsers = state.users.where((user) {
          if (state.searchQuery.isEmpty) return true;
          final query = state.searchQuery.toLowerCase();
          final name = user.user?.fullName?.toLowerCase() ?? '';
          final email = user.user?.email?.toLowerCase() ?? '';
          return name.contains(query) || email.contains(query);
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy thành viên',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<GroupUsersBloc>().add(GroupUsersRefreshRequested(_groupId));
          },
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: filteredUsers.length + (state.status == GroupUsersStatus.loadingMore ? 1 : 0),
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == filteredUsers.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final member = filteredUsers[index];
              return _MemberCard(member: member);
            },
          ),
        );
    }
  }
}

// --- WIDGET CARD THÀNH VIÊN (CHI TIẾT) ---

class _MemberCard extends StatelessWidget {
  final GroupUserModel member;
  const _MemberCard({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = member.user;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HÀNG 1: Avatar + Tên + Menu 3 chấm
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: user?.avatar != null
                    ? CachedNetworkImageProvider(user!.avatar!)
                    : null,
                child: user?.avatar == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              // Thông tin chính
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên + Tag Role
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          user?.fullName ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TODO: Add "Tôi" tag when user is current user
                        // if (isMe) _buildStatusTag("Tôi", Colors.purple.shade50, Colors.purple),
                        _buildRoleTag(member.role ?? 'MEMBER'),
                      ],
                    ),
                  ],
                ),
              ),
              // Nút 3 chấm
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // HÀNG 2: Các Tags (Ngành nghề, Chức vụ)
          if ((user?.companyIndustry != null && user!.companyIndustry!.isNotEmpty) ||
              (member.roleNames != null && member.roleNames!.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Ngành nghề (Xanh lá)
                  if (user?.companyIndustry != null)
                    _buildInfoTag(user!.companyIndustry!, isIndustry: true),
                  // Chức vụ (Xanh dương)
                  if (member.roleNames != null)
                    ...member.roleNames!.map((txt) => _buildInfoTag(txt, isIndustry: false)),
                ],
              ),
            ),

          // HÀNG 3: Email
          Row(
            children: [
              Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  user?.email ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // HÀNG 4: Link "Hồ sơ chi tiết"
          InkWell(
            onTap: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_search_outlined, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  "Hồ sơ chi tiết",
                  style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Helpers vẽ Tag --

  // Tag cho Role (MANAGER, MEMBER, OWNER)
  Widget _buildRoleTag(String role) {
    Color bg;
    Color text;
    IconData? icon;

    switch (role) {
      case "OWNER":
        bg = const Color(0xFFFFF7E6); // Vàng nhạt
        text = const Color(0xFFD46B08); // Cam đậm
        icon = Icons.verified_user;
        break;
      case "MANAGER":
        bg = const Color(0xFFE6F7FF); // Xanh dương nhạt
        text = const Color(0xFF096DD9); // Xanh dương đậm
        icon = Icons.security;
        break;
      default: // MEMBER
        bg = const Color(0xFFF5F5F5);
        text = const Color(0xFF595959);
        icon = Icons.person;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: bg.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: text),
          const SizedBox(width: 4),
          Text(
            role,
            style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Tag thông tin (Ngành nghề / Chức vụ)
  Widget _buildInfoTag(String text, {required bool isIndustry}) {
    // Ngành nghề: Màu xanh lá nhạt giống ảnh
    // Chức vụ: Màu xanh dương nhạt giống ảnh
    final Color bg = isIndustry ? const Color(0xFFF6FFED) : const Color(0xFFF0F5FF);
    final Color border = isIndustry ? const Color(0xFFB7EB8F) : const Color(0xFFADC6FF);
    final Color textColor = isIndustry ? const Color(0xFF389E0D) : const Color(0xFF2F54EB);
    final IconData icon = isIndustry ? Icons.business : Icons.badge;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Flexible( // Cho phép text co giãn nếu quá dài
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 11),
              overflow: TextOverflow.ellipsis, // Cắt nếu quá dài
            ),
          ),
        ],
      ),
    );
  }
}