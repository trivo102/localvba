

import 'package:vba/data/models/auth/user.dart';

class CreateUserReq extends UserModel {
  final String password;

  CreateUserReq({
    required super.email,
    required this.password,
    required super.fullName,
  });
}