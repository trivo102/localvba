// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeResponse _$UserMeResponseFromJson(Map<String, dynamic> json) =>
    UserMeResponse(
      data: json['data'] == null
          ? null
          : UserModel.fromJson(json['data'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserMeResponseToJson(UserMeResponse instance) =>
    <String, dynamic>{'data': instance.data, 'messages': instance.messages};
