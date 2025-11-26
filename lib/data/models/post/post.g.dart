// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      owner: json['owner'] == null
          ? null
          : UserModel.fromJson(json['owner'] as Map<String, dynamic>),
      images: (json['postImages'] as List<dynamic>?)
          ?.map((e) => PostImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      likeCount: (json['likeCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'owner': instance.owner,
      'postImages': instance.images,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'isLiked': instance.isLiked,
    };

PostImage _$PostImageFromJson(Map<String, dynamic> json) => PostImage(
      id: json['id'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PostImageToJson(PostImage instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
    };
