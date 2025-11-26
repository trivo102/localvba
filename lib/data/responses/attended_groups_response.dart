import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/group/group_model.dart';

part 'attended_groups_response.g.dart';

@JsonSerializable()
class AttendedGroupsResponse {
  final int? code;
  final AttendedGroupsData? data;
  final List<String>? messages;

  AttendedGroupsResponse({
    this.code,
    this.data,
    this.messages,
  });

  factory AttendedGroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendedGroupsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedGroupsResponseToJson(this);
}

@JsonSerializable()
class AttendedGroupsData {
  final List<GroupModel>? data;
  final GroupMeta? meta;
  final int? totalEvents;
  final int? maxAttendees;
  final int? totalGroups;
  final int? membersPerGroup;
  final bool? hasReport;

  AttendedGroupsData({
    this.data,
    this.meta,
    this.totalEvents,
    this.maxAttendees,
    this.totalGroups,
    this.membersPerGroup,
    this.hasReport,
  });

  factory AttendedGroupsData.fromJson(Map<String, dynamic> json) =>
      _$AttendedGroupsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedGroupsDataToJson(this);
}

@JsonSerializable()
class GroupMeta {
  final int? page;
  final int? take;
  final int? itemCount;
  final int? pageCount;
  final bool? hasPreviousPage;
  final bool? hasNextPage;

  GroupMeta({
    this.page,
    this.take,
    this.itemCount,
    this.pageCount,
    this.hasPreviousPage,
    this.hasNextPage,
  });

  factory GroupMeta.fromJson(Map<String, dynamic> json) =>
      _$GroupMetaFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMetaToJson(this);
}
