// dummy_pages.dart
import 'package:flutter/material.dart';

// Đây là 4 trang con cho 4 tab
// Bạn sẽ thay thế nội dung của chúng sau

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thảo luận')),
      body: const Center(
        child: Text('Trang Thảo luận (Feed)'),
      ),
    );
  }
}

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhóm')),
      body: const Center(
        child: Text('Trang Nhóm (Groups)'),
      ),
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khám phá')),
      body: const Center(
        child: Text('Trang Khám phá (Discover)'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: const Center(
        child: Text('Trang Hồ sơ (Profile)'),
      ),
    );
  }
}