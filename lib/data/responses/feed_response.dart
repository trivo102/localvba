import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/post/post.dart';
part 'feed_response.g.dart';
@JsonSerializable()
class FeedResponse {
  final FeedData? data;

  final List<String>? messages;

  FeedResponse({
    this.data,
    this.messages,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);
}

@JsonSerializable()
class FeedData {
  @JsonKey(name: 'data')
  final List<PostModel>? items;

  FeedData({this.items});

  factory FeedData.fromJson(Map<String, dynamic> json) =>
      _$FeedDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeedDataToJson(this);
}

