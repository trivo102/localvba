
import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/auth/user.dart';

part 'user_me_response.g.dart';


@JsonSerializable()
class UserMeResponse {
  final UserModel? data;
  final List<String>? messages;

  UserMeResponse({
    this.data,
    this.messages,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) =>
      _$UserMeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserMeResponseToJson(this);
}