import 'package:get_it/get_it.dart';
import 'package:vba/core/api/dio_provider.dart';
import 'package:vba/data/repository/auth/auth_repository_impl.dart';
import 'package:vba/data/sources/auth/auth_service.dart';
import 'package:vba/domain/repository/auth/auth.dart';
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
}