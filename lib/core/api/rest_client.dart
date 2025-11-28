import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:vba/core/constants/app_urls.dart';
import 'package:vba/data/responses/attended_groups_response.dart';
import 'package:vba/data/responses/feed_response.dart';
import 'package:vba/data/responses/group_users_response.dart';
import 'package:vba/data/responses/managed_groups_response.dart';
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

  @GET('/post/feed')
  Future<FeedResponse> getFeed(
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
  );

  @GET('/group/managed-groups')
  Future<ManagedGroupsResponse> getManagedGroups(
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
    @Query('sortBy') String sortBy,
    @Query('q') String q,
    @Query('takeAll') bool takeAll,
  );

  @GET('/group/attended-groups')
  Future<AttendedGroupsResponse> getAttendedGroups(
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
    @Query('sortBy') String sortBy,
    @Query('q') String q,
    @Query('takeAll') bool takeAll,
  );

  @GET('/group/recommended')
  Future<ManagedGroupsResponse> getRecommendedGroups(
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
    @Query('sortBy') String sortBy,
    @Query('q') String q,
    @Query('takeAll') bool takeAll,
  );

  @GET('/group/pending')
  Future<ManagedGroupsResponse> getPendingGroups(
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
    @Query('sortBy') String sortBy,
    @Query('q') String q,
    @Query('takeAll') bool takeAll,
  );

  @GET('/post')
  Future<FeedResponse> getGroupPosts(
    @Query('groupId') String groupId,
    @Query('page') int page,
    @Query('take') int take,
    @Query('order') String order,
    @Query('includeComments') bool includeComments,
  );

  @GET('/group/users')
  Future<GroupUsersResponse> getGroupUsers(
    @Query('groupId') String groupId,
    @Query('page') int page,
    @Query('take') int take,
    @Query('takeAll') bool takeAll,
  );
}
