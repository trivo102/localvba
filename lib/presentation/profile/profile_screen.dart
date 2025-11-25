import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vba/core/commom/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:vba/core/commom/helpers/string_extensions.dart';
import 'package:vba/presentation/profile/bloc/profile_bloc.dart';
import 'package:vba/presentation/profile/widgets/business_tab_page.dart';

class ProfileScreen extends StatefulWidget {
  // const ProfilePage({Key? key}) : super(key: key); // Dùng cho
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _tabCount = 3;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Widget xây dựng phần Header (Avatar, Tên, Chức vụ...)
  Widget _buildProfileHeader() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        final user = state.user;
        final groupRoleNames = user?.groupRoleNames ?? [];
        String? birthdate = user?.birthdate;
        if (birthdate?.isNotEmpty == true) {
          birthdate =
              birthdate?.reformatDate(from: 'yyyy-MM-dd', to: 'dd/MM/yyyy') ??
              birthdate;
        }
        return Container(
          color: Colors.white, // Màu nền của header
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.avatar != null
                    ? NetworkImage(user!.avatar ?? '')
                    : null, // Tải ảnh từ API
                backgroundColor: Colors.blue,
                child: user?.avatar == null
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 12),
              Text(
                user?.fullName ?? '', // user.fullName
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                user?.companyName ?? '', // user.title
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Column(
                        children: [
                          const SizedBox(height: 16),

                          // A. Nút Action (Sao chép link / QR)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.copy, size: 16),
                                label: const Text('Sao chép liên kết'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.qr_code, size: 16),
                                label: const Text('Mã QR'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // B. Danh sách chức vụ (Tags/Chips)
                          if (groupRoleNames.isNotEmpty) ...[
                            Wrap(
                              spacing: 8.0, // Khoảng cách ngang
                              runSpacing: 8.0, // Khoảng cách dọc
                              alignment: WrapAlignment.center,
                              children: groupRoleNames
                                  .map(
                                    (role) =>
                                        _buildRoleChip(role, isPrimary: true),
                                  )
                                  .toList(),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // C. Thông tin liên hệ (Cards)
                          _buildInfoRow(
                            Icons.phone,
                            'ZALO/SĐT',
                            user?.phone ?? '',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.email,
                            'EMAIL',
                            user?.email ?? '',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.cake,
                            'SINH NHẬT',
                            birthdate ?? '',
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleChip(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? Colors.blue[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: isPrimary ? Border.all(color: Colors.blue.shade200) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.blue[800] : Colors.black87,
          fontSize: 12,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(ProfileEventStarted()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.isLoggedOut) {
            // Dispatch event LoggedOut tới AuthenticationBloc
            context.read<AuthenticationBloc>().add(SignOut());
            // Chuyển về trang login
            context.go('/');
          }
        },
        child: DefaultTabController(
          length: _tabCount,
          child: Scaffold(
            // NestedScrollView là chìa khóa
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                    // Đây là các widget "trôi nổi" phía trên
                    return <Widget>[
                      // 1. AppBar chính
                      SliverAppBar(
                        title: const Text('Hồ sơ'),
                        pinned: true, // AppBar dính lại
                        floating: true, // Hiển thị ngay khi cuộn lên
                        actions: [
                          // Nút "Chỉnh sửa"
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Xử lý logic
                              print('Bấm nút Chỉnh sửa');
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ), // Icon logout màu đỏ cho nổi bật
                            tooltip: 'Đăng xuất',
                            onPressed: () {
                              _showLogoutDialog(context); // Gọi hàm dialog
                            },
                          ),
                        ],
                        // Force-elevated khi cuộn (để thấy ranh giới)
                        forceElevated: innerBoxIsScrolled,
                      ),

                      // 2. Header Profile (Avatar, Tên...)
                      SliverToBoxAdapter(child: _buildProfileHeader()),

                      // 3. Thanh TabBar (Sẽ dính lại)
                      SliverPersistentHeader(
                        delegate: _SliverTabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            // Cấu hình Tab
                            isScrollable: false, // 4 tab thì không cần cuộn
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            tabs: const [
                              Tab(text: 'Doanh nghiệp'),
                              Tab(text: 'Sản phẩm'),
                              Tab(text: 'Ưu đãi'),
                              // Giao diện web có 4 tab, tôi điều chỉnh lại
                            ],
                          ),
                        ),
                        pinned: true, // Dính lại khi cuộn
                      ),
                    ];
                  },
              // 4. Nội dung của các Tab
              body: TabBarView(
                controller: _tabController,
                children: const [
                  // Trang cho tab "Doanh nghiệp"
                  BusinessTabPage(),
                  // Trang cho tab "Sản phẩm & Dịch vụ"
                  ProductsTabPage(),
                  // Trang cho tab "Ưu đãi"
                  OffersTabPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          // Nút Hủy
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          // Nút Đồng ý
          TextButton(
            onPressed: () async {
              // 1. Đóng dialog trước
              Navigator.of(ctx).pop();

              // 2. Gọi logic logout
             context.read<ProfileBloc>().add(ProfileEventLogout());
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// --- CÁC TRANG CON CHO TABBARVIEW ---
// (Bạn sẽ tách ra file riêng khi code logic)

class ProductsTabPage extends StatelessWidget {
  const ProductsTabPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text(
          'Sản phẩm & Dịch vụ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Đây là nơi hiển thị danh sách sản phẩm, dịch vụ...'),
      ],
    );
  }
}

class OffersTabPage extends StatelessWidget {
  const OffersTabPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text(
          'Ưu đãi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Đây là nơi hiển thị các ưu đãi, khuyến mãi...'),
      ],
    );
  }
}

// --- LỚP HELPER ĐỂ "DÍNH" TABBAR ---
// (Bạn không cần sửa file này)
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Thêm một Container màu trắng để TabBar không bị trong suốt
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
