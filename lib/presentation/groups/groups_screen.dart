import 'package:flutter/material.dart';
import 'package:vba/presentation/groups/attended_groups/attended_groups_screen.dart';
import 'package:vba/presentation/groups/managed_groups/managed_groups_screen.dart';

// --- DỮ LIỆU GIẢ LẬP (DUMMY DATA) ---

class Group {
  final String id;
  final String name;
  final String imageUrl;
  final int memberCount;
  final bool isJoined;

  Group({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.memberCount,
    this.isJoined = false,
  });
}

// Dữ liệu giả lập
final List<Group> dummyGroups = [
  Group(
    id: '1',
    name: 'Cộng đồng Khởi nghiệp',
    imageUrl: 'https://picsum.photos/200/200?image=11',
    memberCount: 1200,
    isJoined: true,
  ),
  Group(
    id: '2',
    name: 'Hội Doanh nhân Trẻ',
    imageUrl: 'https://picsum.photos/200/200?image=12',
    memberCount: 850,
    isJoined: true,
  ),
  Group(
    id: '3',
    name: 'Marketing & Sales',
    imageUrl: 'https://picsum.photos/200/200?image=13',
    memberCount: 500,
  ),
  Group(
    id: '4',
    name: 'Câu lạc bộ Bất động sản',
    imageUrl: 'https://picsum.photos/200/200?image=14',
    memberCount: 2100,
  ),
];

// --- TRANG CHÍNH (GROUPS PAGE) ---
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DefaultTabController sẽ tự động quản lý TabBar và TabBarView
    return DefaultTabController(
      length: 2, // 2 tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhóm'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nhóm bạn quản lý'),
              Tab(text: 'Nhóm bạn đã tham gia'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab 1: Nhóm bạn quản lý
            ManagedGroupsTab(),
            // Tab 2: Nhóm đã tham gia
            AttendedGroupsTab(),
          ],
        ),
      ),
    );
  }
}
