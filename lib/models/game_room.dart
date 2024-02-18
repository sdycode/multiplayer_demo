// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:multiplayer_demo/models/playerinroom.dart';

class GameRoom {
  String roomId;
  String adminUid;
  String gamename;
  int minPplayers;
  int maxPlayers;
  List<PlayerInRoom> players;
  bool visibleToAll;
  GameRoom({
    required this.roomId,
    required this.adminUid,
    this.gamename = "",
    this.minPplayers = 2,
    this.maxPlayers = 4,
    required this.players,
    this.visibleToAll = true,
  });

  GameRoom copyWith({
    String? roomId,
    String? adminUid,
    String? gamename,
    int? minPplayers,
    int? maxPlayers,
    List<PlayerInRoom>? players,
    bool? visibleToAll,
  }) {
    return GameRoom(
      roomId: roomId ?? this.roomId,
      adminUid: adminUid ?? this.adminUid,
      gamename: gamename ?? this.gamename,
      minPplayers: minPplayers ?? this.minPplayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      players: players ?? this.players,
      visibleToAll: visibleToAll ?? this.visibleToAll,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'adminUid': adminUid,
      'gamename': gamename,
      'minPplayers': minPplayers,
      'maxPlayers': maxPlayers,
      'players': players.map((x) => x.toMap()).toList(),
      'visibleToAll': visibleToAll,
    };
  }

  factory GameRoom.fromMap(Map map) {
    return GameRoom(
      roomId: map['roomId'] as String,
      adminUid: map['adminUid'] as String,
      gamename: map['gamename'] as String,
      minPplayers: map['minPplayers'] as int,
      maxPlayers: map['maxPlayers'] as int,
      players: List<PlayerInRoom>.from(
        (map['players'] as List<dynamic>).map<PlayerInRoom>(
          (x) => PlayerInRoom.fromMap(x as Map),
        ),
      ),
      visibleToAll: map['visibleToAll'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameRoom.fromJson(String source) =>
      GameRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameRoom(roomId: $roomId, adminUid: $adminUid, gamename: $gamename, minPplayers: $minPplayers, maxPlayers: $maxPlayers, players: $players, visibleToAll: $visibleToAll)';
  }

  @override
  bool operator ==(covariant GameRoom other) {
    if (identical(this, other)) return true;

    return other.roomId == roomId &&
        other.adminUid == adminUid &&
        other.gamename == gamename &&
        other.minPplayers == minPplayers &&
        other.maxPlayers == maxPlayers &&
        listEquals(other.players, players) &&
        other.visibleToAll == visibleToAll;
  }

  @override
  int get hashCode {
    return roomId.hashCode ^
        adminUid.hashCode ^
        gamename.hashCode ^
        minPplayers.hashCode ^
        maxPlayers.hashCode ^
        players.hashCode ^
        visibleToAll.hashCode;
  }
}
