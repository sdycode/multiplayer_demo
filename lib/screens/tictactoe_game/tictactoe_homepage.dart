// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:multiplayer_demo/constants/global.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/common/navigateWithTransition.dart';
import 'package:multiplayer_demo/functions/common/showsnackbar.dart';
import 'package:multiplayer_demo/functions/special/addSingleFriendwithplayed.dart';
import 'package:multiplayer_demo/functions/special/add_game_room.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/join_2_strings_asper_order.dart';
import 'package:multiplayer_demo/functions/special/only_nearby_devices.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/models/game_room.dart';
import 'package:multiplayer_demo/models/playerinroom.dart';
import 'package:multiplayer_demo/screens/game_page.dart';
import 'package:multiplayer_demo/screens/login_page.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:multiplayer_demo/widgets/special/checkinternet_connection_widget.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:multiplayer_demo/widgets/textfieldbox.dart';

const String _baseSequence = '0123456789bcdefghjkmnpqrstuvwxyz';

class TicTacToeHomepage extends StatefulWidget {
  const TicTacToeHomepage({super.key});

  @override
  State<TicTacToeHomepage> createState() => _TicTacToeHomepageState();
}

class _TicTacToeHomepageState extends State<TicTacToeHomepage> {
  TextEditingController roomIdController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    roomIdController.dispose();
  }

  Stream<List<BasicUserInfoModel>>? just;
  startUsersStream() async {
    final ref = FirebaseDatabase.instance.ref();
    just = ref.child("users").onValue.map((event) {
      Map? map = event.snapshot.children.first.value as Map?;

      dblog(
          "users dbevent ${event.snapshot.children.length} : ${map.runtimeType}");
      List<BasicUserInfoModel> _users = [];
      event.snapshot.children.toList().forEach((e) {
        Map? map = (e.value) as Map?;
        // dblog("map dbevent is ${map.runtimeType}");

        if (map != null) {
          try {
            BasicUserInfoModel model = BasicUserInfoModel.fromMap(map);
            _users.add(model);
          } catch (e) {
            dblog("bsm dbevent err $e");
          }
        }
      });
      dblog("bsm dbevent is ${_users.length}");
      resetUserInfoMapFromUID(_users, where: "users");
      return _users;
    });
  }

  Stream<String>? uidWhoIsInviting;
  startCurrentInvitedUidStream() async {
    if (isInvalidCurrentUser) {
      return;
    }
    uidWhoIsInviting = FirebaseDatabase.instance
        .ref()
        .child("currentinvite")
        .child(validId)
        .onValue
        .map((event) {
      uidWhoIsInvitingString = event.snapshot.value.toString();
      // if(mounted){
      //   setState(() {

      //   });
      // }
      return event.snapshot.value.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUsersStream();
    startCurrentInvitedUidStream();
  }

  String uidWhoIsInvitingString = "";
  @override
  Widget build(BuildContext context) {
    getOnlyNearByDevices().then((value) {
      dblog("nearbys ${value.length}");
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isValidCurrentUser
            ? (validUser.displayName ?? "No Name")
            : "Hello"),
        actions: [
          "Logout".roundButton(onTap: () async {
            await FirebaseAuth.instance.signOut();

            navigateReplaceWithTransitionToScreen(context, const LoginPage());
          })
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder(
                  stream: just,
                  builder: (c, s) {
                    return SizedBox();
                  }),
              StreamBuilder(
                  stream: uidWhoIsInviting,
                  builder: (c, s) {
                    if (s.hasData) {
                      uidWhoIsInvitingString = s.data!;
                      // dblog("uidWhoIsInvitingString $uidWhoIsInvitingString");
                    }
                    return SizedBox();
                  }),
              TextFieldBox(
                controller: roomIdController,
                hint: "Enter game id",
                suffixIcon: InkWell(
                    onTap: () {
                      roomIdController.clear();
                    },
                    child: Icon(Icons.close)),
              ).boxAroundWidget(w, w * 0.25).paddingWidget(),
              "Join Game".roundButton(onTap: () async {
                bool present = await checkThisRoomIdExistOrNot(
                    "D8mpi38PNPSgzZmwcLSIyCJhWrN2_1708420937729"

                    // roomIdController.text.trim()
                    );
                dblog("present $present");
                if (present) {
                  // ixas0mfgDAZMhp8xXPaHRZAxT253_1708354527509
                  GameRoom? gameRoom = await getGameRoomFromRoomId(
                      // "ixas0mfgDAZMhp8xXPaHRZAxT253_1708418255589",
                      // "ixas0mfgDAZMhp8xXPaHRZAxT253_1708354527509"
                      roomIdController.text.trim()
                      // "D8mpi38PNPSgzZmwcLSIyCJhWrN2_1708420937729"
                      );

                  if (gameRoom != null) {
                    // dblog("gameRoom.players bef ${gameRoom.players.length}");
                    gameRoom.players.add(PlayerInRoom(
                        uid: validId,
                        playerInRoomStatus: PlayerInRoomStatus.joined.name));
                    // dblog("gameRoom.players afr ${gameRoom.players.length}");
                    await addOrUpdateGameRoom(gameRoom);
                    await addOrUpdateGameroomIdinitsPlayersIds(
                        roomId: gameRoom.roomId,
                        playerIds: gameRoom.players.map((e) => e.uid).toList());
                    addSingleFriendwithplayed(gameRoom.players.first.uid,
                        myUid: validId);
                    navigateWithTransitionToScreen(
                        context,
                        GamePage(
                          gameRoom: gameRoom,
                        ));
                  } else {
                    showSnackbarWithButton(context, "Some error occured");
                  }
                } else {
                  showSnackbarWithButton(context,
                      "This game id does not exist or it is incorrect");
                }
              }).paddingWidget(),
              "Start New Game".roundButton(onTap: () async {
                String roomId =
                    // "ixas0mfgDAZMhp8xXPaHRZAxT253_1708418255589";
                    "${validId}_${DateTime.now().millisecondsSinceEpoch}";
                // "D8mpi38PNPSgzZmwcLSIyCJhWrN2_1708420937729";
                GameRoom gameRoom = GameRoom(
                  roomId: roomId,
                  adminUid: validId,
                  minPplayers: 2,
                  maxPlayers: 2,
                  players: [
                    PlayerInRoom(
                        uid: validId,
                        playerInRoomStatus: PlayerInRoomStatus.joined.name)
                  ],
                );
                await addOrUpdateGameRoom(gameRoom);
                navigateWithTransitionToScreen(
                    context,
                    GamePage(
                      gameRoom: gameRoom,
                      newGame: true,
                    ));
              }).paddingWidget(),
              StreamBuilder<List<String>>(
                  stream: getFriendWhomWithPlayed(),
                  builder: (_, snap) {
                    List<String> ids = [];
                    if (snap.hasData) {
                      ids = snap.data!;
                    }
                    return Row(
                      children: ids
                          .map((e) => Card(
                                child: Column(
                                  children: [
                                    TextWithFontWidget.black(
                                      text: (allBasicInfoMap.containsKey(e)
                                              ? allBasicInfoMap[e]!.name
                                              : "Name")
                                          .convertStringToTitleCase(),
                                    ).paddingWidget(),
                                    "${uidWhoIsInvitingString == e ? "Join" : "Play"} "
                                        .roundButton(onTap: () async {
                                      String roomId =
                                          join2StringsAsperOrder(validId, e);
                                      if (uidWhoIsInvitingString == e) {
                                        GameRoom? invitedGameRoom =
                                            await getGameRoomFromRoomId(roomId);
                                        if (invitedGameRoom != null) {
                                          navigateWithTransitionToScreen(
                                              context,
                                              GamePage(
                                                  gameRoom: invitedGameRoom));
                                        } else {
                                          showSnackbarWithButton(context,
                                              "This game room not created yet");
                                        }
                                        return;
                                      }

                                      // String roomId =                                       // "${validId}_${DateTime.now().millisecondsSinceEpoch}";
                                      GameRoom gameRoom = GameRoom(
                                        roomId: roomId,
                                        adminUid: validId,
                                        minPplayers: 2,
                                        maxPlayers: 2,
                                        players: [
                                          PlayerInRoom(
                                              uid: validId,
                                              playerInRoomStatus:
                                                  PlayerInRoomStatus
                                                      .joined.name),
                                          PlayerInRoom(
                                              uid: e,
                                              playerInRoomStatus:
                                                  PlayerInRoomStatus
                                                      .joined.name)
                                        ],
                                      );
                                      await addOrUpdateGameRoom(gameRoom);
                                      await updateCurrentInvite(
                                          uidToWhomInvited: e,
                                          uidWhoInvited: validId);
                                      navigateWithTransitionToScreen(context,
                                          GamePage(gameRoom: gameRoom));
                                    }).paddingWidget()
                                  ],
                                ),
                              ))
                          .toList(),
                    ).scrollRowWidget();
                  }),
            ],
          ),
          CheckInterentWidget()
        ],
      ),
    );
  }
}
/*
  
*/
