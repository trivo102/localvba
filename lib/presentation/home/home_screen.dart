// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/presentation/discover/discover_screen.dart';
import 'package:vba/presentation/feed/feed_screen.dart';
import 'package:vba/presentation/groups/groups_screen.dart';
import 'package:vba/presentation/home/bloc/home_cubit.dart';
import 'package:vba/presentation/home/widgets/dummy_pages.dart';
import 'package:vba/presentation/profile/profile_screen.dart';
// Import các trang con (chúng ta sẽ tạo file dummy ở bước 3)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Danh sách các trang con tương ứng với Bottom Nav Bar
  final List<Widget> _pages = const [
    FeedScreen(),      // Index 0
    GroupsScreen(),    // Index 1
    DiscoverScreen(),  // Index 2
    ProfileScreen(),   // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    // Chúng ta cung cấp HomeCubit cho cây widget của HomePage
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        // Body sẽ lắng nghe state từ HomeCubit để thay đổi
        body: BlocBuilder<HomeCubit, int>(
          builder: (context, pageIndex) {
            // IndexedStack giữ state của các tab
            return IndexedStack(
              index: pageIndex,
              children: _pages,
            );
          },
        ),

        // Bottom Nav Bar cũng lắng nghe HomeCubit
        bottomNavigationBar: BlocBuilder<HomeCubit, int>(
          builder: (context, pageIndex) {
            return BottomNavigationBar(
              // Dùng state 'pageIndex' để biết tab nào đang active
              currentIndex: pageIndex,
              
              // Khi người dùng bấm tab, gọi hàm của Cubit
              onTap: (index) {
                context.read<HomeCubit>().changeTab(index);
              },

              // ----- Styling -----
              // 'fixed' để 4 tab luôn hiển thị tên (không bị 'shifting')
              type: BottomNavigationBarType.fixed, 
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              // ----- End Styling -----

              // Các tab
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum),
                  label: 'Thảo luận',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Nhóm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Khám phá',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Hồ sơ',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}