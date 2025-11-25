import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vba/core/api/rest_client.dart';
import 'package:vba/data/models/auth/create_user_req.dart';
import 'package:vba/data/models/auth/edit_user_req.dart';
import 'package:vba/data/models/auth/signin_user_req.dart';
import 'package:vba/data/models/auth/user.dart';
import 'package:vba/data/responses/user_response.dart';
import 'package:vba/service_locator.dart';

abstract class AuthService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq);
  Future<Either<String, String>> signin(SigninUserReq signinUserReq);
  Future<Either<String, String>> signOut();
  Future<Either<String, UserModel>> getUser();
  Future<Either<String, String>> editUserInfo(EditUserReq edit);
  Future<bool> isSignedIn();
  Future<Either<String, UserModel>> userMe();
  Future<Either<String, UserModel>> userPublic();
}

class AuthServiceImpl extends AuthService {

  UserModel? _currentUser;
  Token? _token;
  final _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_model';

  @override
  Future<Either<String, String>> editUserInfo(EditUserReq edit) {
    // TODO: implement editUserInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<String, UserModel>> getUser() async {
    _currentUser = await _getSession();
    if(_currentUser != null) {
      return Right(_currentUser!);
    }
    return Left('User data not found');
  }

  @override
  Future<bool> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> signOut() async {
    try {
      await _clearSession();
      return Right('Signin was Successful');
    } catch (e) {
      return const Left('Error signing in');
    }
  }

  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
   try {
      await _clearSession();
      final client = RestClient(localDio);
      final body = {
        'email': signinUserReq.email,
        'password': signinUserReq.password
      };
      final response = await client.onLogin(body);
      final data = response.data;
      if(data != null) {
        _currentUser = data.user;
        _token = data.token;
        await _saveSession();
        return Right('Signin was Successful');
      }
      return Left('Error signing in');
    } catch (e) {
      return const Left('Error signing in');
    }
  }

  @override
  Future<Either<String, UserModel>> userMe() async {
    try {
      final client = RestClient(localDio);
      final response = await client.userMe();
      final data = response.data;
      if(data != null) {
        return Right(data);
      }
      return Left('Error signing in');
    } catch (e) {
      return const Left('Error get user me');
    }
  }

  @override
  Future<Either<String, UserModel>> userPublic() async {
    try {
      final client = RestClient(localDio);
      final response = await client.userPublic(_currentUser?.id);
      final data = response.data;
      if(data != null) {
        return Right(data);
      }
      return Left('Error get user public');
    } catch (e) {
      return const Left('Error get user public');
    }
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  Future<void> _saveSession() async {
    // 1. Lưu Token vào Secure Storage
    await _secureStorage.write(key: _tokenKey, value: _token!.accessToken);

    // 2. Lưu UserModel (dưới dạng JSON string) vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Convert object -> Map -> JSON string
    final userJson = jsonEncode(_currentUser?.toJson()); 
    await prefs.setString(_userKey, userJson);
  }
  
  Future<UserModel?> _getSession() async {
    // 1. Đọc Token từ Secure Storage
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) {
      return null; // Không có session, user phải login
    }

    // 2. Đọc UserModel từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) {
      return null; // Lỗi (có token mà ko có user), bắt login lại
    }

    // 3. Convert JSON string -> Map -> UserModel
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // Nếu lỗi parse JSON, xóa session cũ và bắt login lại
      await _clearSession();
      return null;
    }
  }


  Future<void> _clearSession() async {
    // 1. Xóa Token
    await _secureStorage.delete(key: _tokenKey);

    // 2. Xóa UserModel
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

    _currentUser = null;
    _token = null;
  }
}