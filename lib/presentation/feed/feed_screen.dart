

import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Dữ liệu giả lập (Bạn sẽ thay thế bằng API call từ BLoC)
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu giả lập
    _posts = fetchDummyPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thảo luận'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Xử lý tìm kiếm
            },
          ),
        ],
      ),
      body: ListView.builder(
        // +1 cho widget "Tạo bài đăng"
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          // Widget đầu tiên luôn là card "Tạo bài đăng"
          if (index == 0) {
            return const CreatePostCard();
          }

          // Trừ 1 để lấy đúng index của post
          final post = _posts[index - 1];
          return PostCard(post: post);
        },
      ),
    );
  }
}

// --- CARD "BẠN ĐANG NGHĨ GÌ?" ---

class CreatePostCard extends StatelessWidget {
  const CreatePostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              // Lấy avatar của user đang đăng nhập
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // Dùng Expanded để Text chiếm hết phần còn lại
            Expanded(
              child: Text(
                'Bạn đang nghĩ gì?',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            // Nút đăng ảnh
            IconButton(
              icon: Icon(Icons.image, color: Colors.green[400]),
              onPressed: () {
                // Xử lý logic đăng bài (chuyển trang)
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- CARD HIỂN THỊ 1 BÀI ĐĂNG ---

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header của Post (Avatar, Tên, Thời gian)
          _buildPostHeader(),
          
          // 2. Nội dung text của Post
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(post.content),
          ),
          
          // 3. (Nếu có) Hình ảnh của Post
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
          // 4. Dải phân cách
          const Divider(height: 1),
          
          // 5. Footer (Like, Comment)
          _buildPostFooter(),
        ],
      ),
    );
  }

  // Widget con cho phần Header
  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.userAvatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  post.timestamp, // Ví dụ: "1 giờ trước"
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Xử lý menu (VD: Báo cáo, Xóa bài)
            },
          ),
        ],
      ),
    );
  }

  // Widget con cho phần Footer
  Widget _buildPostFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFooterButton(
            icon: Icons.thumb_up_outlined,
            label: 'Thích',
            onPressed: () {},
          ),
          _buildFooterButton(
            icon: Icons.comment_outlined,
            label: 'Bình luận',
            onPressed: () {},
          ),
          _buildFooterButton(
            icon: Icons.share_outlined,
            label: 'Chia sẻ',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Widget tái sử dụng cho các nút Like/Comment/Share
  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.grey[700], size: 20),
      label: Text(label, style: TextStyle(color: Colors.grey[700])),
    );
  }
}

// --- DỮ LIỆU GIẢ LẬP (DUMMY DATA) ---
// (Bạn sẽ xóa phần này khi tích hợp BLoC và Model thật)

class Post {
  final String userName;
  final String userAvatarUrl;
  final String timestamp;
  final String content;
  final String? imageUrl; // Dùng ? để cho phép post không có ảnh

  Post({
    required this.userName,
    required this.userAvatarUrl,
    required this.timestamp,
    required this.content,
    this.imageUrl,
  });
}

List<Post> fetchDummyPosts() {
  return [
    Post(
      userName: 'Nguyễn Văn A',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=1',
      timestamp: '15 phút trước',
      content:
          'Rất vui được tham gia cộng đồng! Hy vọng được kết nối với mọi người.',
    ),
    Post(
      userName: 'Trần Thị B',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=2',
      timestamp: '1 giờ trước',
      content: 'Một bài viết giới thiệu về sản phẩm mới của công ty chúng tôi.',
      imageUrl: 'https://picsum.photos/600/300?image=10',
    ),
    Post(
      userName: 'Lê Văn C',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      timestamp: 'Hôm qua',
      content:
          'Tìm kiếm đối tác trong lĩnh vực X. Doanh nghiệp nào quan tâm vui lòng bình luận bên dưới.',
    ),
  ];
}