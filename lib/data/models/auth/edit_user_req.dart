import 'package:vba/data/models/auth/user.dart';

class EditUserReq extends UserModel {
  final String? password;

  EditUserReq({
    required super.email,
    this.password,
    required super.fullName,
  });
}