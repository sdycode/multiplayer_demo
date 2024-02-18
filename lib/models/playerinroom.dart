// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:multiplayer_demo/specials/enums.dart';

class PlayerInRoom {
  String uid;
  String playerInRoomStatus;
  PlayerInRoom({
    required this.uid,
    this.playerInRoomStatus = "leaved",
  });

  PlayerInRoom copyWith({
    String? uid,
    String? playerInRoomStatus,
  }) {
    return PlayerInRoom(
      uid: uid ?? this.uid,
      playerInRoomStatus: playerInRoomStatus ?? this.playerInRoomStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'playerInRoomStatus': playerInRoomStatus,
    };
  }

  factory PlayerInRoom.fromMap(Map  map) {
    return PlayerInRoom(
      uid: map['uid'] as String,
      playerInRoomStatus: map['playerInRoomStatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerInRoom.fromJson(String source) =>
      PlayerInRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PlayerInRoom(uid: $uid, playerInRoomStatus: $playerInRoomStatus)';

  @override
  bool operator ==(covariant PlayerInRoom other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.playerInRoomStatus == playerInRoomStatus;
  }

  @override
  int get hashCode => uid.hashCode ^ playerInRoomStatus.hashCode;
}
