// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      data: json['data'] == null
          ? null
          : FeedData.fromJson(json['data'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'messages': instance.messages,
    };

FeedData _$FeedDataFromJson(Map<String, dynamic> json) => FeedData(
      items: (json['data'] as List<dynamic>?)
          ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedDataToJson(FeedData instance) => <String, dynamic>{
      'data': instance.items,
    };
