import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDateString({String format = 'yyyy-MM-dd'}) {
    final formatter = DateFormat(format);
    return formatter.format(this);
  }

  String toDateTimeString({String format = 'yyyy-MM-dd HH:mm'}) {
    final formatter = DateFormat(format);
    return formatter.format(this);
  }

  String toISOString() {
    return toIso8601String();
  }

  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years năm trước';
    }
  }
}