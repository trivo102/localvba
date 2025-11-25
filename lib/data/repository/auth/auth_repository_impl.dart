import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/auth/create_user_req.dart';
import 'package:vba/data/models/auth/edit_user_req.dart';
import 'package:vba/data/models/auth/signin_user_req.dart';
import 'package:vba/data/models/auth/user.dart';
import 'package:vba/data/sources/auth/auth_service.dart';
import 'package:vba/domain/repository/auth/auth.dart';
import 'package:vba/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthService>().signup(createUserReq);
  }

  @override
  Future<Either> editUserInfo(EditUserReq edit) async {
    return await sl<AuthService>().editUserInfo(edit);
  }

  @override
  Future<Either<String, UserModel>> getUser() async {
    return await sl<AuthService>().getUser();
  }


  @override
  Future<bool> isSignedIn() async {
    return await sl<AuthService>().isSignedIn();
  }

  @override
  Future<Either> userMe() async {
    return await sl<AuthService>().userMe();
  }

  @override
  Future<Either> userPublic() async {
    return await sl<AuthService>().userPublic();
  }

  @override
  Future<Either> signOut() async {
    return await sl<AuthService>().signOut();
  }
}