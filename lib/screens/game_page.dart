// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/functions/special/only_nearby_devices.dart';
import 'package:share_plus/share_plus.dart';

import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/as_per_game/gameplay.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/screens/tictactoe.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

class GamePage extends StatefulWidget {
  // final Stream<GameRoom?>? gameroomStream;
  final GameRoom gameRoom;
  final bool newGame;
  // final PlayerInRoom playerInRoom;
  const GamePage({
    Key? key,
    // this.gameroomStream,
    required this.gameRoom,
    this.newGame = false,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Stream<GameRoom?>? gameRoomStream;
  late GameRoom gameRoom;
  late PlayerInRoom playerInRoom;
  late final bool newGame;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // gameRoomStream = widget.gameroomStream;
    newGame = widget.newGame;
    gameRoom = widget.gameRoom;
    startListeningGameRoom();
    startUpdateGame();
    switchUpdateValue();
  }

  TicTacToeGamePlay? ticTacToeGamePlay;

  startListeningGameRoom() async {
    gameRoomStream = FirebaseDatabase.instance
        .ref()
        .child("gamerooms")
        .child(gameRoom.roomId)
        .onValue
        .map((event) {
      try {
        Map? map = event.snapshot.value as Map?;
        dblog("gameRoomlisten ${gameRoom.players.length}");

        if (map != null) {
          gameRoom = GameRoom.fromMap(map);
          return gameRoom;
          // int indexwher = gameRoom.players.indexWhere((e) => e.uid == validId);
          // if (indexwher >= 0) {
          //   playerInRoom = gameRoom.players[indexwher];
        }

        // dblog("gameRoom no err ${gameRoom != null}");
      } catch (e) {
        dblog("gameRoom err $e");
      }
      return gameRoom;
    });
  }

  Stream<bool>? updateStream;
  bool update = true;
  switchUpdateValue() async {
    update = !update;
    final ref = FirebaseDatabase.instance
        .ref()
        .child("gameplays")
        .child(gameRoom.roomId);
    ticTacToeGamePlay = TicTacToeGamePlay(
        gamePlayId: gameRoom.roomId,
        playerIds: gameRoom.players.map((e) => e.uid).toList(),
        update: update,
        blockMarks: List.filled(9, 0));
    await ref.update(ticTacToeGamePlay!.toMap());
  }

  startUpdateGame() {
    updateStream = FirebaseDatabase.instance
        .ref()
        .child("gameplays")
        .child(gameRoom.roomId)
        .onValue
        .map((event) {
      Map map = event.snapshot.value as Map;
      try {
        ticTacToeGamePlay = TicTacToeGamePlay.fromMap(map);
        if (mounted) {
          setState(() {});
        }
      } catch (e) {}

      // dblog("updated ${(event.snapshot.value as Map)["update"]}");
      return (event.snapshot.value as Map)["update"] ?? true;
    });
  }

  Future startTicTacToeGame() async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child("gameplays")
        .child(gameRoom.roomId);
    ticTacToeGamePlay = TicTacToeGamePlay(
        gamePlayId: gameRoom.roomId,
        playerIds: gameRoom.players.map((e) => e.uid).toList(),
        blockMarks: List.filled(9, 0));
    await ref.update(ticTacToeGamePlay!.toMap());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Page"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<bool>(
              stream: updateStream,
              builder: (c, snap) {
                return SizedBox();
                // if (snap.hasData) {
                //   update = snap.data as bool;
                // }
                // return TextWithFontWidget(
                //     text: "Updated ${snap.data}/ $update");
              }),
          StreamBuilder<GameRoom?>(
              stream: gameRoomStream,
              builder: (context, pSnap) {
                return SizedBox();
                // return TextWithFontWidget(
                //   text: "gameRoomStream Stream ${pSnap.hasData}" +
                //       "ticTacToeGamePlay ${ticTacToeGamePlay != null} : ${gameRoom.players.length}",
                //   maxLines: 4,
                // );
                // return Row(
                //   children: gameRoom.players
                //       .map((e) => TextWithFontWidget(
                //               color:
                //                   e.uid == validId ? Colors.blue : Colors.white,
                //               text: allBasicInfoMap[e.uid]!
                //                   .name
                //                   .convertStringToTitleCase())
                //           .paddingWidget())
                //       .toList(),
                // ).scrollRowWidget();
              }),
          if (gameRoom.players.isNotEmpty &&
              gameRoom.adminUid == validId &&
              newGame)
            "Invite Friend"
                .roundButton(onTap: () async {
                  await Share.share(gameRoom.roomId);
                })
                .paddingWidget()
                .alignCenterWidget(),
          if (gameRoom.players.length >= 2)
            ((ticTacToeGamePlay != null)
                ? TicTacToe(
                    gameRoom: gameRoom,
                    roomId: gameRoom.roomId,
                    gamePlay: ticTacToeGamePlay!,
                  )
                : Expanded(
                    child: Center(
                    child: "Play         ".roundButton(onTap: () async {
                      switchUpdateValue();
                      startTicTacToeGame();
                      setState(() {});
                    }),
                  ))),
          // "Re Update".roundButton(onTap: () async {
          //   startListeningGameRoom();
          //   switchUpdateValue();
          //   setState(() {});
          // }),
        ],
      ),
    );
  }
}
