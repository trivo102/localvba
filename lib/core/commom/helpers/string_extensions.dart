import 'package:intl/intl.dart';

extension StringExtensions on String {
  DateTime? toDate({String format = 'yyy-MM-dd'}) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(this);
    } catch (e) {
      return null;
    }
  }
  String? reformatDate({
    required String from,
    required String to,
  }) {
    try {
      final date = DateFormat(from).parse(this);
      return DateFormat(to).format(date);
    } catch (e) {
      return null;
    }
  }
}

