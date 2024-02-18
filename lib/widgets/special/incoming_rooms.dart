import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/add_game_room.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/updatePlayerStatus.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/group_model.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

class IncomingRoomsWidget extends StatefulWidget {
  const IncomingRoomsWidget({super.key});

  @override
  State<IncomingRoomsWidget> createState() => _IncomingRoomsWidgetState();
}

class _IncomingRoomsWidgetState extends State<IncomingRoomsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startIncomingRoomsStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
        stream: incomingRoomsStream,
        builder: (_, snap) {
          if (snap.hasData) {
            List<String> roomIds = [];
            roomIds = snap.data!;
            return Row(
              children: roomIds.map((e) {
                Stream<GameRoom?>? gameRoomStream;
                PlayerInRoom playerInRoom = PlayerInRoom(uid: validId);
                GameRoom? gameRoom;
                gameRoomStream = FirebaseDatabase.instance
                    .ref()
                    .child("gamerooms")
                    .child(e)
                    .onValue
                    .map((event) {
                  try {
                    gameRoom = GameRoom.fromMap(event.snapshot.value as Map);
                    if (gameRoom != null) {
                      int indexwher =
                          gameRoom!.players.indexWhere((e) => e.uid == validId);
                      if (indexwher >= 0) {
                        playerInRoom = gameRoom!.players[indexwher];
                      }
                    }
                    // dblog("gameRoom no err ${gameRoom != null}");
                  } catch (e) {
                    dblog("gameRoom err $e");
                  }

                  return gameRoom;
                });
                return StreamBuilder<GameRoom?>(
                    stream: gameRoomStream,
                    builder: (context, pSnap) {
                      return Card(
                        color: Colors.grey,
                        child: Column(
                          children: [
                            if (gameRoom != null)
                              TextWithFontWidget(
                                  text:
                                      gameRoom!.gamename.toString() + " name"),
                            TextWithFontWidget(
                                text: playerInRoom.playerInRoomStatus),
                            if (playerInRoom.playerInRoomStatus ==
                                    PlayerInRoomStatus.leaved.name &&
                                gameRoom != null)
                              "Join".roundButton(onTap: () async {
                                int indexwher = gameRoom!.players
                                    .indexWhere((e) => e.uid == validId);
                                if (indexwher >= 0) {
                                  gameRoom!.players[indexwher] =
                                      playerInRoom.copyWith(
                                          playerInRoomStatus:
                                              PlayerInRoomStatus.joined.name);
                                }

                                await addOrUpdateGameRoom(
                                  gameRoom!,
                                );
                              }).paddingWidget()
                          ],
                        ),
                      );
                    });
              }).toList(),
            ).scrollRowWidget();
          }
          return FlutterLogo();
        });
  }
}
