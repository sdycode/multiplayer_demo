// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/common/navigateWithTransition.dart';
import 'package:multiplayer_demo/functions/special/createOrUpdateGroup.dart';
import 'package:multiplayer_demo/functions/special/get_stream_for_came_requests.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/screens/login_page.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/sheets/group_creation_sheet.dart';
import 'package:multiplayer_demo/sheets/initialise_gameroom_sheet.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:multiplayer_demo/widgets/special/gruop_list_widget.dart';
import 'package:multiplayer_demo/widgets/special/incoming_rooms.dart';
import 'package:multiplayer_demo/widgets/special/request_came_list.dart';
import 'package:multiplayer_demo/widgets/special/userslist.dart';

Widget get homePage => const HomePage();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (DeviceLocation.instance.isCurrentPositionDummy()) {
      DeviceLocation.instance.getAndSetCurrentPosition();
    }
    getStreamForCameRequests();
  }

  TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    getGroups();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: SafeArea(
          child: Column(children: [
            TextWithFontWidget(
                text: auth.currentUser!.displayName ?? "No Name"),
            GroupListWidget(),
            CameRequestListWidget(),
            const UsersListWidget(),
            IncomingRoomsWidget()
                .paddingWidget()
                .addAbove(widget: TextWithFontWidget(text: "Incoming rooms")),
            "Multiplyer Game".roundButton(onTap: () async {
              String roomId =
                  "${validId}_${DateTime.now().millisecondsSinceEpoch}";
              GameRoom gameRoom = GameRoom(
                roomId: roomId,
                adminUid: validId,
                minPplayers: 2,
                maxPlayers: 4,
                players: [
                  PlayerInRoom(
                      uid: validId,
                      playerInRoomStatus: PlayerInRoomStatus.joined.name)
                ],
              );
              await initialiseGameRoomSheet(context, gameRoom);
            }).paddingWidget(),
            "Create Group".roundButton(onTap: () async {
              await openGroupCreationSheet(context, groupNameController);
            }).paddingWidget(),
            "Get Location".roundButtonExpanded(onTap: () async {
              Position? position =
                  await DeviceLocation.instance.getCurrentPosition();
              dblog("position ${position?.toString()}");
            }),
            "Signout".roundButtonExpanded(onTap: () async {
              await FirebaseAuth.instance.signOut();

              navigateReplaceWithTransitionToScreen(context, const LoginPage());
            })
          ]).scrollColumnWidget(),
        ),
      ),
    );
  }
}
