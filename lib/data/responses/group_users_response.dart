import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/group/group_user_model.dart';

part 'group_users_response.g.dart';

@JsonSerializable()
class GroupUsersResponse {
  final int? code;
  final GroupUsersData? data;
  final List<String>? messages;

  GroupUsersResponse({
    this.code,
    this.data,
    this.messages,
  });

  factory GroupUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUsersResponseToJson(this);
}

@JsonSerializable()
class GroupUsersData {
  @JsonKey(name: 'data')
  final List<GroupUserModel>? users;
  final GroupUsersMeta? meta;

  GroupUsersData({
    this.users,
    this.meta,
  });

  factory GroupUsersData.fromJson(Map<String, dynamic> json) =>
      _$GroupUsersDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUsersDataToJson(this);
}

@JsonSerializable()
class GroupUsersMeta {
  final int? page;
  final int? take;
  final int? itemCount;
  final int? pageCount;
  final bool? hasPreviousPage;
  final bool? hasNextPage;

  GroupUsersMeta({
    this.page,
    this.take,
    this.itemCount,
    this.pageCount,
    this.hasPreviousPage,
    this.hasNextPage,
  });

  factory GroupUsersMeta.fromJson(Map<String, dynamic> json) =>
      _$GroupUsersMetaFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUsersMetaToJson(this);
}
