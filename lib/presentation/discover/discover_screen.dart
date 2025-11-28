import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/presentation/discover/bloc/pending_groups_bloc.dart';
import 'package:vba/presentation/discover/bloc/recommended_groups_bloc.dart';

// --- DỮ LIỆU GIẢ LẬP (DUMMY DATA) ---
class Group {
  final String id;
  final String name;
  final String imageUrl;
  final int memberCount;
  final String date;

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.memberCount,
    required this.date,
  });
}

final List<Group> suggestedGroups = [
  Group(
    id: '1',
    name: 'CHI HỘI DOANH NHÂN TRẺ LONG AN',
    imageUrl: 'https://picsum.photos/300/200?image=11', // Dùng ảnh placeholder
    memberCount: 1,
    date: '10/18/2025',
  ),
  Group(
    id: '2',
    name: 'CHI HỘI DOANH NHÂN TRẺ TRẢNG BÀNG',
    imageUrl: 'https://picsum.photos/300/200?image=12',
    memberCount: 1,
    date: '10/18/2025',
  ),
  Group(
    id: '3',
    name: 'CHI HỘI DOANH NHÂN TRẺ TÂN NINH',
    imageUrl: 'https://picsum.photos/300/200?image=13',
    memberCount: 2,
    date: '10/12/2025',
  ),
];
// --- HẾT DỮ LIỆU GIẢ LẬP ---

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PendingGroupsBloc()..add(const PendingGroupsLoadRequested()),
        ),
        BlocProvider(
          create: (context) =>
              RecommendedGroupsBloc()..add(const RecommendedGroupsLoadRequested()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khám phá'),
        ),
        body: BlocBuilder<RecommendedGroupsBloc, RecommendedGroupsState>(
          builder: (context, state) {
            switch (state.status) {
              case RecommendedGroupsStatus.initial:
              case RecommendedGroupsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case RecommendedGroupsStatus.failure:
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
                              .read<RecommendedGroupsBloc>()
                              .add(const RecommendedGroupsLoadRequested(isRefresh: true));
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              case RecommendedGroupsStatus.success:
              case RecommendedGroupsStatus.loadingMore:
                return ListView(
                  children: [
                    _buildPendingGroupsSection(context),
                    _buildSuggestionsSection(context, state),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  // Section "Chờ xác nhận của bạn"
  Widget _buildPendingGroupsSection(BuildContext context) {
    return BlocBuilder<PendingGroupsBloc, PendingGroupsState>(
      builder: (context, state) {
        if (state.status == PendingGroupsStatus.loading ||
            state.status == PendingGroupsStatus.initial) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == PendingGroupsStatus.failure) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 40),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Đã xảy ra lỗi',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (state.groups.isEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Icon(Icons.group_add_outlined, color: Colors.blue[700], size: 40),
                const SizedBox(height: 16),
                const Text(
                  'Chưa có yêu cầu đang chờ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hãy khám phá các nhóm được đề xuất bên dưới và gửi yêu cầu tham gia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          );
        }

        // Show pending groups
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chờ xác nhận của bạn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Các nhóm đang chờ bạn xác nhận tham gia',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return _PendingGroupCard(group: group);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // Section "Đề xuất cho bạn"
  Widget _buildSuggestionsSection(BuildContext context, RecommendedGroupsState state) {
    final bloc = context.read<RecommendedGroupsBloc>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đề xuất cho bạn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Nhóm mà bạn có thể quan tâm', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm nhóm',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (value) {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (value.isEmpty || value == value) {
                  bloc.add(RecommendedGroupsSearchChanged(value));
                }
              });
            },
          ),
          const SizedBox(height: 16),
          if (state.groups.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text('Không có nhóm đề xuất', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: state.groups.length +
                  (state.status == RecommendedGroupsStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.groups.length) {
                  bloc.add(RecommendedGroupsLoadMoreRequested());
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                final group = state.groups[index];
                return _GroupSuggestionCard(group: group);
              },
            ),
        ],
      ),
    );
  }
}

// Card cho 1 nhóm chờ xác nhận
class _PendingGroupCard extends StatelessWidget {
  final GroupModel group;
  const _PendingGroupCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa
          SizedBox(
            height: 100,
            child: CachedNetworkImage(
              imageUrl: group.photo ?? '',
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.group, size: 40),
              ),
            ),
          ),
          // Thông tin
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name ?? 'Không có tên',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${group.numberOfMembers ?? 0}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Icon(Icons.pending_actions, size: 16, color: Colors.orange[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Chờ duyệt',
                      style: TextStyle(color: Colors.orange[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(), // Đẩy nút xuống dưới
          // Nút
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: view pending request
                },
                child: const Text('Xem chi tiết'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Card cho 1 nhóm đề xuất
class _GroupSuggestionCard extends StatelessWidget {
  final GroupModel group;
  const _GroupSuggestionCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa
          SizedBox(
            height: 100,
            child: CachedNetworkImage(
              imageUrl: group.photo ?? '',
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.group, size: 40),
              ),
            ),
          ),
          // Thông tin
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name ?? 'Không có tên',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${group.numberOfMembers ?? 0}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      (group.createdAt ?? '').split('T').first,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(), // Đẩy nút xuống dưới
          // Nút
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate/join
                },
                child: const Text('Tham gia nhóm'),
              ),
            ),
          )
        ],
      ),
    );
  }
}