import 'package:fpdart/fpdart.dart';
import 'package:vba/data/models/auth/create_user_req.dart';
import 'package:vba/data/models/auth/edit_user_req.dart';
import 'package:vba/data/models/auth/signin_user_req.dart';

abstract class AuthRepository {
  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> editUserInfo(EditUserReq edit);

  Future<Either> signin(SigninUserReq signinUserReq);

  Future<Either> getUser();

  Future<bool> isSignedIn();

  Future<Either> userMe();

  Future<Either> userPublic();

  Future<Either> signOut();
}