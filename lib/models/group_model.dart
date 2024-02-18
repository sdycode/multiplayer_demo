// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GroupModel {
  final String id;
  String adminUid;
  String groupName;
  String photoURL;
  List<String> membersIds;
  GroupModel({
    required this.id,
    required this.adminUid,
    required this.groupName,
    this.photoURL = "",
    required this.membersIds,
  });

  GroupModel copyWith({
    String? id,
    String? adminUid,
    String? groupName,
    String? photoURL,
    List<String>? membersIds,
  }) {
    return GroupModel(
      id: id ?? this.id,
      adminUid: adminUid ?? this.adminUid,
      groupName: groupName ?? this.groupName,
      photoURL: photoURL ?? this.photoURL,
      membersIds: membersIds ?? this.membersIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'adminUid': adminUid,
      'groupName': groupName,
      'photoURL': photoURL,
      'membersIds': membersIds,
    };
  }

  factory GroupModel.fromMap(Map map) {
    return GroupModel(
      id: map['id'] as String,
      adminUid: map['adminUid'] as String,
      groupName: map['groupName'] as String,
      photoURL: map['photoURL'] as String,
      membersIds: map['membersIds'] == null
          ? []
          : List.from((map['membersIds'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupModel(id: $id, adminUid: $adminUid, groupName: $groupName, photoURL: $photoURL, membersIds: $membersIds)';
  }

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.adminUid == adminUid &&
        other.groupName == groupName &&
        other.photoURL == photoURL &&
        listEquals(other.membersIds, membersIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        adminUid.hashCode ^
        groupName.hashCode ^
        photoURL.hashCode ^
        membersIds.hashCode;
  }
}
