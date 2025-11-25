

// --- DỮ LIỆU GIẢ LẬP (DUMMY DATA) ---
import 'package:flutter/material.dart';

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
            // Tab 1: Khám phá
            DiscoverGroupsTab(),
            // Tab 2: Nhóm của tôi
            DiscoverGroupsTab(),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: KHÁM PHÁ ---
class DiscoverGroupsTab extends StatelessWidget {
  const DiscoverGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dùng ListView để cho phép cuộn,
    // widget đầu tiên là thanh tìm kiếm + filter
    return ListView.builder(
      itemCount: dummyGroups.length + 1, // +1 cho thanh Search/Filter
      itemBuilder: (context, index) {
        if (index == 0) {
          // Widget Search và Filter
          return _buildSearchAndFilter();
        }
        // Các item nhóm
        final group = dummyGroups[index - 1];
        return GroupCard(group: group);
      },
    );
  }

  // Widget cho thanh tìm kiếm và filter
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm nhóm...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 12),
          // 2. Filter/Sort
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.sort),
                label: const Text('Sắp xếp'),
                onPressed: () {
                  // Xử lý Sắp xếp
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.filter_alt),
                label: const Text('Lọc'),
                onPressed: () {
                  // Xử lý Lọc
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- TAB 2: NHÓM CỦA TÔI ---
class MyGroupsTab extends StatelessWidget {
  const MyGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lọc ra các nhóm đã tham gia (giả lập)
    final managedGroups = dummyGroups.where((g) => g.id == '1').toList();
    final joinedGroups = dummyGroups.where((g) => g.isJoined).toList();

    // Dùng ListView để hiển thị 2 section
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section 1: Nhóm bạn quản lý
        const Text(
          'Nhóm bạn quản lý',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // (Nếu không có nhóm, hiển thị 1 thông báo)
        if (managedGroups.isEmpty)
          const Text('Bạn không quản lý nhóm nào.'),
        // (Nếu có, liệt kê ra)
        ...managedGroups.map((group) => GroupListTile(group: group)),

        const SizedBox(height: 24),

        // Section 2: Nhóm bạn đã tham gia
        const Text(
          'Nhóm bạn đã tham gia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (joinedGroups.isEmpty)
          const Text('Bạn chưa tham gia nhóm nào.'),
        ...joinedGroups.map((group) => GroupListTile(group: group)),
      ],
    );
  }
}

// --- WIDGET TÁI SỬ DỤNG ---

/// Card cho Tab "Khám phá" (có nút Join)
class GroupCard extends StatelessWidget {
  final Group group;
  const GroupCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(group.imageUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${group.memberCount} thành viên',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Nút Tham gia / Rời khỏi
            group.isJoined
                ? OutlinedButton(
                    onPressed: () {
                      // Xử lý Rời nhóm
                    },
                    child: const Text('Rời khỏi'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Xử lý Tham gia
                    },
                    child: const Text('Tham gia'),
                  ),
          ],
        ),
      ),
    );
  }
}

/// ListTile cho Tab "Nhóm của tôi" (đơn giản hơn)
class GroupListTile extends StatelessWidget {
  final Group group;
  const GroupListTile({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(group.imageUrl),
      ),
      title: Text(
        group.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${group.memberCount} thành viên'),
      onTap: () {
        // Chuyển đến trang chi tiết nhóm
      },
    );
  }
}