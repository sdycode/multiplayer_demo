import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/sheets/initialise_gameroom_sheet.dart';
import 'package:multiplayer_demo/specials/enums.dart';

class MulitplayerGameButton extends StatelessWidget {
  const MulitplayerGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return "Multiplyer Game".roundButton(onTap: () async {
      String roomId = "${validId}_${DateTime.now().millisecondsSinceEpoch}";
      GameRoom gameRoom = GameRoom(
        roomId: roomId,
        adminUid: validId,
        minPplayers: 2,
        maxPlayers: 4,
        players: [
          PlayerInRoom(
              uid: validId, playerInRoomStatus: PlayerInRoomStatus.joined.name)
        ],
      );
      await initialiseGameRoomSheet(context, gameRoom);
    }).paddingWidget();
  }
}
