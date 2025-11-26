import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? description;
  final String? photo;
  final int? numberOfMembers;
  final bool? hasConfirmDocument;
  final bool? autoApprovePost;
  final List<GroupUserModel>? groupUsers;
  final List<String?>? memberAvatars;

  GroupModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.photo,
    this.numberOfMembers,
    this.hasConfirmDocument,
    this.autoApprovePost,
    this.groupUsers,
    this.memberAvatars,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}

@JsonSerializable()
class GroupUserModel {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;
  final String? groupId;
  final List<String>? roleNames;
  final String? note;
  final int? totalSold;
  final int? totalBought;
  final int? totalIntroduced;
  final String? role;

  GroupUserModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.groupId,
    this.roleNames,
    this.note,
    this.totalSold,
    this.totalBought,
    this.totalIntroduced,
    this.role,
  });

  factory GroupUserModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUserModelToJson(this);
}
