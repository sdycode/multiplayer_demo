import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
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

Future addOrUpdateGameRoom(GameRoom gameRoom) async {
  final ref =
      FirebaseDatabase.instance.ref().child("gamerooms").child(gameRoom.roomId);
  await ref.update(gameRoom.toMap());
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
