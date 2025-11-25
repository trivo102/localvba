import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/auth/user.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  final Data? data;
  final List<String>? messages;

    UserResponse({
        this.data,
        this.messages
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);

    Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class Data {
    final UserModel? user;
    final Token? token;
    final RefreshToken? refreshToken;

    Data({
        this.user,
        this.token,
        this.refreshToken,
    });

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
    Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class RefreshToken {
    final int? expiresIn;
    final String? refreshToken;

    RefreshToken({
        this.expiresIn,
        this.refreshToken,
    });

    factory RefreshToken.fromJson(Map<String, dynamic> json) => _$RefreshTokenFromJson(json);
    Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);
}

@JsonSerializable()
class Token {
    final int? expiresIn;
    final String? accessToken;

    Token({
        this.expiresIn,
        this.accessToken,
    });

    factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
    Map<String, dynamic> toJson() => _$TokenToJson(this);

}

