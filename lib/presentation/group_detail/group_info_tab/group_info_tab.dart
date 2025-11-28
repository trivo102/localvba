import 'package:flutter/material.dart';
import 'package:vba/data/models/group/group_model.dart';

class GroupInfoTab extends StatelessWidget {
  final GroupModel group;
  const GroupInfoTab({Key? key, required this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final memberCount = group.numberOfMembers ?? 0;
    final hasAutoApprove = group.autoApprovePost ?? false;
    final hasDocumentConfirm = group.hasConfirmDocument ?? false;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. CARD THÔNG TIN CƠ BẢN
        _buildInfoCard(
          title: group.name ?? "Giới thiệu nhóm",
          children: [
            if (group.description != null && group.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  group.description!,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ),
            _buildInfoRow(
              Icons.visibility_outlined, 
              "Hiển thị", 
              "Mọi người đều có thể tìm thấy nhóm này.",
            ),
            if (hasAutoApprove)
              _buildInfoRow(
                Icons.check_circle_outline, 
                "Tự động duyệt bài", 
                "Bài viết được đăng ngay lập tức.",
              ),
            if (hasDocumentConfirm)
              _buildInfoRow(
                Icons.verified_outlined, 
                "Xác minh tài liệu", 
                "Yêu cầu xác minh tài liệu khi tham gia.",
              ),
          ],
        ),

        const SizedBox(height: 16),

        // 2. CARD THỐNG KÊ
        _buildInfoCard(
          title: "Hoạt động Nhóm",
          children: [
            _buildStatRow(Icons.people, "Thành viên", memberCount.toString()),
            if (group.createdAt != null)
              _buildStatRow(
                Icons.calendar_today, 
                "Ngày tạo", 
                _formatDate(group.createdAt!),
              ),
            if (group.updatedAt != null)
              _buildStatRow(
                Icons.update, 
                "Cập nhật lần cuối", 
                _formatDate(group.updatedAt!),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // 3. MEMBER AVATARS (if available)
        if (group.memberAvatars != null && group.memberAvatars!.isNotEmpty)
          _buildInfoCard(
            title: "Thành viên gần đây",
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: group.memberAvatars!.take(10).map((avatar) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundImage: avatar != null 
                        ? NetworkImage(avatar)
                        : null,
                    child: avatar == null 
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString.split('T').first;
    }
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue), // Icon màu xanh như web
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}