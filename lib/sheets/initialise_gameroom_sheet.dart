import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/navigate.dart';
import 'package:multiplayer_demo/functions/common/showsnackbar.dart';
import 'package:multiplayer_demo/functions/special/add_game_room.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/specials/data.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

Future initialiseGameRoomSheet(BuildContext context, GameRoom gameRoom) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, state) {
          return Column(
            children: [
              Column(
                children: [
                  Divider(),
                  Column(
                    children: gameRoom.players.map((player) {
                      if (player.uid == validId) {
                        return SizedBox();
                      }
                      if (allBasicInfoMap.values
                          .map((e) => e.uid)
                          .toList()
                          .contains(player.uid)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextWithFontWidget.black(
                                    text: allBasicInfoMap[player.uid]!.name)
                                .paddingWidget(),
                            IconButton(
                                onPressed: () {
                                  gameRoom.players
                                      .removeWhere((e) => e.uid == player.uid);
                                  state(() {});
                                },
                                icon: Icon(Icons.close))
                          ],
                        );
                      }
                      return SizedBox();
                    }).toList(),
                  ),
                  Divider(),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allUsers.length,
                      itemBuilder: (c, i) {
                        return gameRoom.players
                                .map((e) => e.uid)
                                .toList()
                                .contains(allUsers[i].uid)
                            ? SizedBox()
                            : ElevatedButton.icon(
                                onPressed: () {
                                  if (!gameRoom.players
                                      .map((e) => e.uid)
                                      .contains(allUsers[i].uid)) {
                                    gameRoom.players.add(PlayerInRoom(
                                        uid: allUsers[i].uid,
                                        playerInRoomStatus:
                                            PlayerInRoomStatus.leaved.name));
                                    state(() {});
                                  }
                                },
                                icon: Icon(Icons.add_photo_alternate),
                                label: Text(
                                  allUsers[i].name + "\n" + allUsers[i].uid,
                                  maxLines: 5,
                                ));
                      }).expnd(),
                ],
              ).expnd(),
              "Start Game".roundButton(onTap: () async {
                if (gameRoom.players.length >= gameRoom.minPplayers) {
                  await addOrUpdateGameRoom(gameRoom);
                  await addOrUpdateGameroomIdinitsPlayersIds(
                      roomId: gameRoom.roomId,
                      playerIds: gameRoom.players.map((e) => e.uid).toList());
                  navigatePopContext(context);
                } else {
                  showSnackbarWithButton(context,
                      "Select Minimum ${gameRoom.minPplayers} players");
                }
              })
            ],
          );
        }).maxHeightForWidget(context.height() * 0.8);
      });
}
