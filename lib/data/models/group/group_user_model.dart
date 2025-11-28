import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/auth/user.dart';

part 'group_user_model.g.dart';

@JsonSerializable()
class GroupUserModel {
  final String? id;
  final String? createdAt;
  final List<String>? roleNames;
  final String? note;
  final int? totalSold;
  final int? totalBought;
  final int? totalIntroduced;
  final UserModel? user;
  final String? role; // OWNER, MANAGER, MEMBER

  GroupUserModel({
    this.id,
    this.createdAt,
    this.roleNames,
    this.note,
    this.totalSold,
    this.totalBought,
    this.totalIntroduced,
    this.user,
    this.role,
  });

  factory GroupUserModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUserModelToJson(this);
}
