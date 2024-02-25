// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/paths.dart';

import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/as_per_game/gameplay.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:tuple/tuple.dart';

import '../functions/tictactoe/checkwinnerconditionTTT.dart';

class TicTacToe extends StatefulWidget {
  final String roomId;
  final TicTacToeGamePlay gamePlay;
  final GameRoom gameRoom;
  const TicTacToe({
    Key? key,
    required this.roomId,
    required this.gamePlay,
    required this.gameRoom,
  }) : super(key: key);

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late TicTacToeGamePlay gamePlay;
  late final GameRoom gameRoom;
  Stream<TicTacToeGamePlay>? playStream;
  startTicTacGamePlay() async {
    playStream = FirebaseDatabase.instance
        .ref()
        .child("gameplays")
        .child(widget.roomId)
        .onValue
        .map((event) {
      Map? map = event.snapshot.value as Map?;

      dblog("sgameplays updated ${map != null} [${map?.entries.first.key}]");
      if (map != null) {
        try {
          gamePlay = TicTacToeGamePlay.fromMap(map);
          return gamePlay;
        } catch (e) {
          dblog("sgameplays err ${e}");
        }
      }

      return widget.gamePlay;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gamePlay = widget.gamePlay;
    gameRoom = widget.gameRoom;
    startTicTacGamePlay();
  }

  bool get isMyTurn =>
      gameRoom.players.indexWhere((e) => e.uid == validId) == gamePlay.turnNo;

  updateGameValues() async {
    await FirebaseDatabase.instance
        .ref()
        .child("gameplays")
        .child(widget.roomId)
        .update(gamePlay.toMap());
  }

  Widget rowStick({int i = 0}) {
    return Container(
      width: stickLength,
      height: stickThickness,
      color: Colors.primaries[i],
    ).ignoreWidget();
  }

  Widget columnStick({int i = 0}) {
    return Container(
      width: stickThickness,
      height: stickLength,
      color: Colors.primaries[i],
    ).ignoreWidget();
  }

  Widget diagonalStick({bool lToR = true, int i = 0}) {
    return SizedBox(
      width: w,
      height: w,
      child: Transform.rotate(
        angle: (pi * 0.25) * (lToR ? 1 : -1),
        child: Center(
          child: Container(
            width: stickThickness,
            height: stickLength * 1.41,
            color: Colors.primaries[i * 2 % Colors.primaries.length],
          ),
        ),
      ),
    ).ignoreWidget();
  }

  double get cardSize => (w / 3);
  List<Tuple2<double, double>> get leftTopPositions => [
        Tuple2(
            (w - stickLength) * 0.5, (cardSize) * 0.5 - stickThickness * 0.5),
        Tuple2(
            (w - stickLength) * 0.5, (cardSize) * 1.5 - stickThickness * 0.5),
        Tuple2(
            (w - stickLength) * 0.5, (cardSize) * 2.5 - stickThickness * 0.5),
        Tuple2(
            (cardSize) * 0.5 - stickThickness * 0.5, (w - stickLength) * 0.5),
        Tuple2(
            (cardSize) * 1.5 - stickThickness * 0.5, (w - stickLength) * 0.5),
        Tuple2(
            (cardSize) * 2.5 - stickThickness * 0.5, (w - stickLength) * 0.5),
        const Tuple2(0, 0),
        const Tuple2(0, 0),
      ];
  double get stickThickness => w * 0.04;
  double get stickLength => w * 0.8;
  Tuple2<int, int> winnerTuple = const Tuple2(0, 0);
  // bool isTurn1 = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TicTacToeGamePlay>(
        stream: playStream,
        builder: (context, snap) {
          if (snap.hasData && snap.data != null) {
            gamePlay = snap.data as TicTacToeGamePlay;
          }
          winnerTuple = winnerNo(gamePlay.blockMarks);

          int myPlayerNo = gameRoom.players.indexWhere((e) => e.uid == validId);

          String myMarkSign = gamePlay.firstPlayerNo == myPlayerNo ? "X" : "O";
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWithFontWidget(
                  text: "Your Sign : $myMarkSign",
                  color: Colors.yellow,
                  fontsize: w * 0.12,
                  maxLines: 1,
                ).paddingWidget(),
                TextWithFontWidget(
                  text: isMyTurn ? "Your Turn" : "Opponents Turn",
                  color: isMyTurn ? Colors.green : Colors.red,
                  fontsize: w * 0.08,
                  maxLines: 2,
                ).paddingWidget(),
                Stack(
                  children: [
                    GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: 9,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (c, i) {
                              return InkWell(
                                borderRadius: 12.borderRadiusCircular(),
                                onTap: () async {
                                  if (!isMyTurn) {
                                    return;
                                  }
                                  if (gamePlay.blockMarks[i] == 0) {
                                    gamePlay.blockMarks[i] =
                                        [1, 2][gamePlay.turnNo];
                                    gamePlay.turnNo = (gamePlay.turnNo + 1) %
                                        gameRoom.players.length;
                                    await updateGameValues();
                                  }
                                },
                                child: Card(
                                  color: Colors.blueGrey,
                                  shape: 12.cardRoundShape(),
                                  child: TextWithFontWidget(
                                          fontsize: w * 0.2,
                                          fontweight: FontWeight.bold,
                                          text: [
                                            "",
                                            "X",
                                            "O"
                                          ][gamePlay.blockMarks[i]])
                                      .alignCenterWidget(),
                                ).paddingWidget(),
                              );
                            })
                        .opaqueWithIgnore(
                            ignore: winnerTuple.item1 > 0,
                            opacityValue: winnerTuple.item1 > 0 ? 0.4 : 1),
                    if (winnerTuple.item1 > 0)
                      Positioned(
                          left: leftTopPositions[winnerTuple.item2].item1,
                          top: leftTopPositions[winnerTuple.item2].item2,
                          child: winnerTuple.item2 <= 2
                              ? rowStick()
                              : (winnerTuple.item2 <= 5
                                  ? columnStick()
                                  : diagonalStick(
                                      lToR: winnerTuple.item2 == 7
                                          ? true
                                          : false)))
                  ],
                ).boxAroundWidget(w, w),
                if (winnerTuple.item1 > 0)
                  Card(
                    child: TextWithFontWidget(
                      text: (winnerTuple.item1 - 1) == myPlayerNo
                          ? "You Won"
                          : "You Lose",
                      color: (winnerTuple.item1 - 1) == myPlayerNo
                          ? Colors.amber
                          : Colors.brown,
                      fontsize: w * 0.16,
                      fontweight: FontWeight.bold,
                    ).paddingWidget(),
                  ).paddingWidget(),
                // TextWithFontWidget(
                //         text: "Winner ${winnerTuple.item1} :  ${[
                //   "",
                //   "X",
                //   "O"
                // ][winnerTuple.item1]}")
                //     .paddingWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    "Restart".roundButton(onTap: () {
                      gamePlay.blockMarks = List.filled(9, 0);
                      gamePlay.turnNo = 0;
                      winnerTuple = const Tuple2(0, 0);
                      updateGameValues();
                    }).paddingWidget(),
                    if (isMyTurn &&
                        gamePlay.blockMarks
                                .where((element) => element == 0)
                                .length ==
                            9)
                      "Switch Turn".roundButton(onTap: () {
                        gamePlay.turnNo = gamePlay.turnNo == 0 ? 1 : 0;
                        gamePlay.firstPlayerNo = gamePlay.turnNo;
                        updateGameValues();
                      })
                  ],
                ),
              ],
            ).scrollColumnWidget(),
          );
        });
  }
}
