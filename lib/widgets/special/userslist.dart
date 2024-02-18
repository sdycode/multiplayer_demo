// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/adduser_to_userlist.dart';
import 'package:multiplayer_demo/functions/special/get_stream_for_came_requests.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/functions/special/sent_connection_request.dart';
import 'package:multiplayer_demo/functions/special/updatePlayerStatus.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/specials/data.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:multiplayer_demo/widgets/special/get_uid_mail.dart';
import 'package:tuple/tuple.dart';

class UsersListWidget extends StatefulWidget {
  const UsersListWidget({super.key});

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUsersStream();
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
      dblog("bsm dbevent is ${allUsers.length}");
      resetUserInfoMapFromUID(_users, where: "users");
      return _users;
    });
  }

  getUsersUsingFuture() async {
    final ref = FirebaseDatabase.instance.ref().child("users");
    DatabaseEvent dbevent = await ref.once();
    // dblog("dbevent ids ${dbevent.snapshot.children.length}");
    List<BasicUserInfoModel> _users = [];

    for (DataSnapshot e in dbevent.snapshot.children) {
      Map? map = e.value as Map;
      if (map != null) {
        try {
          BasicUserInfoModel model = BasicUserInfoModel.fromMap(map);
          _users.add(model);
        } catch (e) {
          dblog("bsm dbevent err $e");
        }
      }
    }
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    dblog("users data");
    updatePlayerStatus(uid: validId, status: PlayerStatus.available);
    getPlayerStatus(uid: validUser.uid);
    // getUsersUsingFuture();
    return SafeArea(
      child: Column(
        children: [
          StreamBuilder<List<BasicUserInfoModel>>(
              stream: just,
              builder: (_, data) {
                if (data.hasData) {
                  allUsers = data.data as List<BasicUserInfoModel>;
                  return Row(
                    children: allUsers.map((e) {
                      if (e.uid == auth.currentUser!.uid) {
                        return SizedBox();
                      }
                      if (requestOfMaybeConnectedUsers == null) {
                        return UserInfoWidgetFromUserSide(
                          userInfo: e,
                        );
                      }
                      int indexwhere = requestOfMaybeConnectedUsers!
                          .map((model) => model.item1)
                          .toList()
                          .indexWhere((element) => element.uid == e.uid);
                      // dblog(                          "indexwher $indexwhere : ${requestOfMaybeConnectedUsers!.length} / ${allUsers.length} ");
                      if (indexwhere < 0 ||
                          indexwhere >= requestOfMaybeConnectedUsers!.length) {
                        return UserInfoWidgetFromUserSide(
                          userInfo: e,
                        );
                      }

                      return UserInfoWidgetFromUserSide(
                        userInfo: e,
                        request: requestOfMaybeConnectedUsers!
                            .map((e) => e.item2)
                            .toList()[indexwhere],
                      );
                    }).toList(),
                  ).scrollRowWidget();
                }
                return FlutterLogo();
              }),
          "add random".roundButtonExpanded(
              expanded: false,
              onTap: () async {
                String uid = "user uid ${nowDTime.millisecondsSinceEpoch}";
                BasicUserInfoModel userInfoModel = BasicUserInfoModel(
                    uid: uid,
                    photoUrl: "user.photoURL   ",
                    providerType: "providerType",
                    name: "Guest",
                    email: getUIDMail(uid, "providerType"),
                    latLongPos: DeviceLocation.instance.currentPosition);

                final ref =
                    FirebaseDatabase.instance.ref().child("users").child(uid);
                await ref.update(userInfoModel.toMap());
              }),
        ],
      ),
    );
  }
}

class UserInfoWidgetFromUserSide extends StatelessWidget {
  final BasicUserInfoModel userInfo;
  final ConnectionRequest request;
  const UserInfoWidgetFromUserSide({
    Key? key,
    required this.userInfo,
    this.request = ConnectionRequest.notconnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = [ConnectionRequest.connected, ConnectionRequest.accepted]
            .contains(request)
        ? "Connected"
        : "";
    if ([ConnectionRequest.rejected, ConnectionRequest.notconnected]
        .contains(request)) {
      title = "Not Connected";
    }
    if (request == ConnectionRequest.sent) {
      title = "Request Sent";
    }
    return Card(
      child: Column(
        children: [
          TextWithFontWidget.black(
            text: userInfo.name.convertStringToTitleCase(),
            maxLines: 2,
          ).paddingWidget(),
          TextWithFontWidget.black(text: title),
          if ([ConnectionRequest.rejected, ConnectionRequest.notconnected]
              .contains(request))
            "Connect"
                .roundButton(
                    onTap: () async {
                      sendConnectionRequest(
                        receiverUid: userInfo.uid,
                      );
                    },
                    expanded: false)
                .paddingWidget(),
        ],
      ),
    );
  }
}

class UserInfoWidgetFromReceiverSide extends StatelessWidget {
  final BasicUserInfoModel userInfo;
  final ConnectionRequest request;
  const UserInfoWidgetFromReceiverSide({
    Key? key,
    required this.userInfo,
    this.request = ConnectionRequest.notconnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = [ConnectionRequest.connected, ConnectionRequest.accepted]
            .contains(request)
        ? "Connected"
        : "";
    if ([ConnectionRequest.rejected, ConnectionRequest.notconnected]
        .contains(request)) {
      title = "Not Connected";
    }
    return Card(
      child: Column(
        children: [
          TextWithFontWidget.black(
            text: userInfo.name.convertStringToTitleCase(),
            maxLines: 2,
          ).paddingWidget(),
          TextWithFontWidget.black(text: title),
          if ([ConnectionRequest.connected, ConnectionRequest.accepted]
              .contains(request))
            "Disconnect".roundButton(onTap: () async {
              await removeConnection(validUser.uid, userInfo.uid);
            }).paddingWidget(),
          if ([ConnectionRequest.rejected, ConnectionRequest.notconnected]
              .contains(request))
            "Connect".roundButton(
              onTap: () async {
                sendConnectionRequest(
                  receiverUid: userInfo.uid,
                );
              },
            ).paddingWidget(),
          if (request == ConnectionRequest.came)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                "Accept".roundButton(
                  onTap: () async {
                    acceptCameRequest(
                        senderUid: validUser.uid, receiverUid: userInfo.uid);
                  },
                ),
                "Reject".roundButton(
                  onTap: () async {
                    rejectCameRequest(
                        currentUserId: validUser.uid,
                        personWhoSentRequestId: userInfo.uid);
                  },
                ),
              ],
            ).paddingWidget()
        ],
      ),
    );
  }
}
