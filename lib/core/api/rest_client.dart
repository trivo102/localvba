import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:vba/core/constants/app_urls.dart';
import 'package:vba/data/responses/user_me_response.dart';
import 'package:vba/data/responses/user_response.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: AppUrls.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST('/auth/login')
  Future<UserResponse> onLogin(@Body() Map<String, dynamic> body);

  @GET('/users/me')
  Future<UserMeResponse> userMe();

  @GET('/users/public/{id}')
  Future<UserMeResponse> userPublic(@Path('id') String? id);
}