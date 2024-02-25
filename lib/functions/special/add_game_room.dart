import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';

Stream<List<String>>? incomingRoomsStream;
startIncomingRoomsStream() {
  incomingRoomsStream = FirebaseDatabase.instance
      .ref()
      .child("roomids_in_players")
      .child(validId)
      .onValue
      .map((e) {
    return e.snapshot.children.map((e) => e.value.toString()).toList();
    // return [];
  });
}

/// https://console.firebase.google.com/u/0/project/game2048-15642/database/game2048-15642-default-rtdb/data/~2Fgamerooms~2Fixas0mfgDAZMhp8xXPaHRZAxT253_1708354527509
Future<bool> checkThisRoomIdExistOrNot(String id) async {
  final ref = FirebaseDatabase.instance.ref().child("gamerooms");
  DataSnapshot snapshot = await ref.get();
  dblog("rid len ${snapshot.children.length}");
  for (var rId in snapshot.children) {
    dblog(" ${rId.key.toString()} : ${rId.key.toString() == id}");
    if (rId.key.toString() == id) {
      return true;
    }
  }
  return false;
}

Future addOrUpdateGameRoom(GameRoom gameRoom) async {
  final ref =
      FirebaseDatabase.instance.ref().child("gamerooms").child(gameRoom.roomId);
  await ref.update(gameRoom.toMap());
}

Future<GameRoom?> getGameRoomFromRoomId(String roomId) async {
  final ref = FirebaseDatabase.instance.ref().child("gamerooms").child(roomId);
  dblog("getGameRoomFromRoomId before");

  DatabaseEvent devent = await ref.once();
  dblog("getGameRoomFromRoomId de ${devent.runtimeType}");

  try {
    GameRoom gameRoom = GameRoom.fromMap(devent.snapshot.value as Map);
    dblog("getGameRoomFromRoomId successfull");

    return gameRoom;
  } catch (e) {
    dblog("getGameRoomFromRoomId err $e");
  }
  return null;
}

Future addOrUpdateGameroomIdinitsPlayersIds(
    {required String roomId, required List<String> playerIds}) async {
  await Future.forEach(playerIds, (pId) async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child("roomids_in_players")
        .child(pId)
        .child(roomId)
        .set(roomId);
  });
}

Future removeRoomIdFromPlayerIds(
    {required String roomId, required List<String> playerIds}) async {
  await Future.forEach(playerIds, (pId) async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child("roomids_in_players")
        .child(pId)
        .child(roomId)
        .remove();
    // .set(roomId);
  });
}
