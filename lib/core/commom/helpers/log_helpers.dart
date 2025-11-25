import 'package:flutter/foundation.dart';
class LogHelper {
  static const String _prefix = "vba";

  /// ANSI color codes for better log readability
  static const String _colorDebug = "\x1B[36m"; // Cyan
  static const String _colorInfo = "\x1B[34m"; // Blue
  static const String _colorWarning = "\x1B[33m"; // Yellow
  static const String _colorError = "\x1B[31m"; // Red
  static const String _colorReset = "\x1B[0m"; // Reset color

  static void debug({required String tag, required String message}) =>
      _log("DEBUG", tag, message, _colorDebug);

  static void info({required String tag, required String message}) =>
      _log("ℹINFO", tag, message, _colorInfo);

  static void warning({required String tag, required String message}) =>
      _log("WARNING", tag, message, _colorWarning);

  static void error({
    required String tag,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log("ERROR", tag, message, _colorError);
    if (kDebugMode && error != null) {
      print("$_colorError$_prefix [ERROR] $tag: $error$_colorReset");
    }
    if (kDebugMode && stackTrace != null) {
      print("$_colorError$_prefix [STACKTRACE] $tag:\n$stackTrace$_colorReset");
    }
  }

  static void _log(String level, String tag, String message, String color) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print("$color$_prefix [$level] [$timestamp] $tag: $message$_colorReset");
    }
  }
}