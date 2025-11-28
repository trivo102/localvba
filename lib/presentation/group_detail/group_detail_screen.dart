import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:vba/data/models/group/group_model.dart';
import 'package:vba/presentation/group_detail/group_feed_tab/group_feed_tab.dart';
import 'package:vba/presentation/group_detail/group_info_tab/group_info_tab.dart';
import 'package:vba/presentation/group_detail/group_users_tab/group_users_tab.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Thảo luận", 'Thành viên', "Thông tin"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. ẢNH BÌA & APP BAR
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
                leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),
              title: innerBoxIsScrolled ? Text(widget.group.name ?? '') : null,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(  
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.group.photo ?? '', // Ảnh bìa demo
                      fit: BoxFit.cover,
                    ),
                    // Lớp phủ đen mờ để text dễ đọc nếu cần
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withAlpha(128)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. THÔNG TIN CƠ BẢN (Tên nhóm)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.name ?? '',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            // 3. TAB BAR (Dính lại khi cuộn)
            SliverPersistentHeader(
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true, // Cho phép cuộn ngang nếu nhiều tab
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: _tabs.map((name) => Tab(text: name)).toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        // 4. NỘI DUNG TỪNG TAB
        body: TabBarView(
          controller: _tabController,
          children: [
            GroupFeedTab(),   // Tab Thảo luận
            GroupUsersTab(),   // Tab Thành viên
            GroupInfoTab(group: widget.group),   // Tab Thông tin
          ],
        ),
      ),
    );
  }

}

// Helper class cho Sticky TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Nền trắng cho TabBar
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

