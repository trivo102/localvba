import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/sources/auth/auth_service.dart';
import 'package:vba/service_locator.dart';

class DioProvider {
  static Dio instance() {
    final dio = Dio();

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(HttpLogInterceptor());

    return dio;
  }
}

/// HTTP interceptor to log requests, responses, and errors.
class HttpLogInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String logMessage = "onRequest: ${options.uri}";

    if (options.data != null && options.data.toString().isNotEmpty) {
      logMessage += "\ndata=${options.data}";
    }
    if (options.method.isNotEmpty) {
      logMessage += "\nmethod=${options.method}";
    }
    if (options.headers.isNotEmpty) {
      logMessage += "\nheaders=${options.headers}";
    }
    if (options.queryParameters.isNotEmpty) {
      logMessage += "\nqueryParameters=${options.queryParameters}";
    }

    if (logMessage.isNotEmpty) {
      LogHelper.info(tag: "HttpLogInterceptor", message: logMessage);
    }

    handler.next(options);
  }

  /// Intercepts and logs the HTTP response details.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogHelper.debug(
      tag: "HttpLogInterceptor",
      message: "statusCode=${response.statusCode}\n",
      // "responseBody=${response.data}",
    );

    super.onResponse(response, handler);
  }

  /// Intercepts and logs any errors occurring during the HTTP request.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogHelper.error(
      tag: "HttpLogInterceptor",
      message:
          "onError: $err\n"
          "Response: ${err.response}",
    );

    super.onError(err, handler);
  }
}

/// Interceptor for handling authentication, adding tokens, and refreshing them if expired.
class AuthInterceptor extends Interceptor {
  String? _accessToken;
  final _secureStorage = const FlutterSecureStorage();
  final _tokenKey = 'auth_token';

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    LogHelper.debug(
      tag: "AuthInterceptor",
      message: "Adding Authorization token...",
    );

    _accessToken ??= await _secureStorage.read(key: _tokenKey);

    if (_accessToken != null) {
      options.headers["Authorization"] =
          "Bearer $_accessToken"; // Attach token to request headers.
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogHelper.debug(
      tag: "AuthInterceptor",
      message:
          "Response received: ${response.statusCode}", // Log HTTP response status.
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    LogHelper.debug(
      tag: "AuthInterceptor",
      message: "Error occurred: ${err.response?.statusCode}",
    );

    if (err.response?.statusCode == 401) {
      // Check if the error is due to token expiration.
      LogHelper.debug(
        tag: "AuthInterceptor",
        message: "Token expired, refreshing token...",
      );

      // Xóa session
      await _clearSession();


      // Trả về lỗi với message rõ ràng
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: 'Session expired. Please login again.',
        ),
      );
      return;
    }

    handler.next(err); // Continue error handling if not resolved.
  }

  /// Retries the failed request with a new access token.
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    requestOptions.headers["Authorization"] =
        "Bearer $_accessToken"; // Attach updated token.
    return dio.fetch(requestOptions);
  }

  /// Simulated function to refresh the token.
  Future<String?> _refreshToken() async {
    await Future.delayed(Duration(seconds: 2));
    return "new_access_token";
  }

  Future<void> _clearSession() async {
    try {
      // Gọi AuthService để xóa session
      await sl<AuthService>().signOut();
    } catch (e) {
      LogHelper.error(
        tag: "AuthInterceptor",
        message: "Error clearing session: $e",
      );
    }
  }
}
