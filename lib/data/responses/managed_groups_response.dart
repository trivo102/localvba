import 'package:json_annotation/json_annotation.dart';
import 'package:vba/data/models/group/group_model.dart';

part 'managed_groups_response.g.dart';

@JsonSerializable()
class ManagedGroupsResponse {
  final int? code;
  final ManagedGroupsData? data;
  final List<String>? messages;

  ManagedGroupsResponse({
    this.code,
    this.data,
    this.messages,
  });

  factory ManagedGroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagedGroupsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ManagedGroupsResponseToJson(this);
}

@JsonSerializable()
class ManagedGroupsData {
  final List<GroupModel>? data;
  final GroupMeta? meta;
  final int? totalEvents;
  final int? maxAttendees;
  final int? totalGroups;
  final int? membersPerGroup;
  final bool? hasReport;

  ManagedGroupsData({
    this.data,
    this.meta,
    this.totalEvents,
    this.maxAttendees,
    this.totalGroups,
    this.membersPerGroup,
    this.hasReport,
  });

  factory ManagedGroupsData.fromJson(Map<String, dynamic> json) =>
      _$ManagedGroupsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ManagedGroupsDataToJson(this);
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
