import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/auth/user.dart';
part 'post.g.dart';

@JsonSerializable()
class PostModel {
  final String? id;
  final String? content;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  final UserModel? owner;
  @JsonKey(name: 'postImages')
  final List<PostImage>? images;
  final int? likeCount;
  final int? commentCount;
  final bool? isLiked;

  PostModel({
    this.id,
    this.content,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.owner,
    this.images,
    this.likeCount,
    this.commentCount,
    this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

@JsonSerializable()
class PostImage {
  final String? id;
  final String? url;

  PostImage({
    this.id,
    this.url,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) =>
      _$PostImageFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageToJson(this);
}