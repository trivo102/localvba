// discover_page.dart
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khám phá'),
      ),
      body: ListView(
        children: [
          // 1. Box "Yêu cầu đang chờ"
          _buildPendingRequestsCard(),
          
          // 2. Section "Đề xuất cho bạn"
          _buildSuggestionsSection(context),
        ],
      ),
    );
  }

  // Card "Chưa có yêu cầu đang chờ"
  Widget _buildPendingRequestsCard() {
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

  // Section "Đề xuất cho bạn"
  Widget _buildSuggestionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          const Text(
            'Đề xuất cho bạn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhóm mà bạn có thể quan tâm',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          
          // Thanh tìm kiếm
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
          ),
          const SizedBox(height: 16),

          // Lưới các nhóm
          GridView.builder(
            // Tắt cuộn của GridView, để ListView chính cuộn
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7, // Tỷ lệ (width / height)
            ),
            itemCount: suggestedGroups.length,
            itemBuilder: (context, index) {
              final group = suggestedGroups[index];
              return GroupSuggestionCard(group: group);
            },
          ),
        ],
      ),
    );
  }
}

// Card cho 1 nhóm đề xuất
class GroupSuggestionCard extends StatelessWidget {
  final Group group;
  const GroupSuggestionCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias, // Để bo góc ảnh
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa
          Image.network(
            group.imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Thông tin
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
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
                      '${group.memberCount}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      group.date,
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
                onPressed: () {},
                child: const Text('Tham gia nhóm'),
              ),
            ),
          )
        ],
      ),
    );
  }
}