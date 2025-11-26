import 'package:get_it/get_it.dart';
import 'package:vba/core/api/dio_provider.dart';
import 'package:vba/data/repository/auth/auth_repository_impl.dart';
import 'package:vba/data/repository/group/group_repository_impl.dart';
import 'package:vba/data/repository/post/feed_repository_impl.dart';
import 'package:vba/data/sources/auth/auth_service.dart';
import 'package:vba/data/sources/group/group_service.dart';
import 'package:vba/data/sources/post/feed_service.dart';
import 'package:vba/domain/repository/auth/auth.dart';
import 'package:vba/domain/repository/group/group_repository.dart';
import 'package:vba/domain/repository/post/feed_repository.dart';
import 'package:vba/domain/usecase/group/get_attended_groups.dart';
import 'package:vba/domain/usecase/group/get_managed_groups.dart';
import 'package:vba/domain/usecase/post/get_feed_usecase.dart';
import 'package:vba/domain/usecase/user/get_user.dart';
import 'package:vba/domain/usecase/user/logout.dart';
import 'package:vba/domain/usecase/user/signin.dart';
import 'package:vba/domain/usecase/user/user_me.dart';
import 'package:vba/domain/usecase/user/user_public.dart';

final sl = GetIt.instance;
final localDio = DioProvider.instance();

Future<void> initializeDependencies() async {
 
  // Auth
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerLazySingleton<UserMeUseCase>(() => UserMeUseCase());
  sl.registerLazySingleton<UserPublicUseCase>(() => UserPublicUseCase());
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase());

  // Feed
  sl.registerSingleton<FeedRepository>(FeedRepositoryImpl());
  sl.registerSingleton<FeedService>(FeedServiceImpl());
  sl.registerLazySingleton<GetFeedUseCase>(() => GetFeedUseCase());

  // Group
  sl.registerSingleton<GroupService>(GroupServiceImpl());
  sl.registerSingleton<GroupRepository>(GroupRepositoryImpl());
  sl.registerSingleton<GetManagedGroupsUseCase>(GetManagedGroupsUseCase());
  sl.registerSingleton<GetAttendedGroupsUseCase>(GetAttendedGroupsUseCase());
}