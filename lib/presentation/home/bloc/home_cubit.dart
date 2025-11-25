// home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit này chỉ quản lý một số nguyên (int), chính là index của tab
class HomeCubit extends Cubit<int> {
  // Khởi tạo, tab đầu tiên (index 0) được chọn
  HomeCubit() : super(0);

  // Hàm để UI gọi khi người dùng bấm
  void changeTab(int index) {
    emit(index); // Phát ra state mới
  }
}