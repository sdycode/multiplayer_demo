// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/createOrUpdateGroup.dart';
import 'package:multiplayer_demo/functions/special/createOrUpdateGroup.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';

import 'package:multiplayer_demo/models/group_model.dart';
import 'package:multiplayer_demo/specials/data.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

class GroupDetailedPage extends StatefulWidget {
  final GroupModel groupModel;
  const GroupDetailedPage({
    Key? key,
    required this.groupModel,
  }) : super(key: key);

  @override
  State<GroupDetailedPage> createState() => _GroupDetailedPageState();
}

class _GroupDetailedPageState extends State<GroupDetailedPage> {
  late final GroupModel groupModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupModel = widget.groupModel;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (groupModel.adminUid == validUser.uid)
            Row(
              children: [
                TextWithFontWidget(text: "You are admin"),
              ],
            ),
          TextWithFontWidget(text: "Members"),
          Row(
            children: groupModel.membersIds.map((e) {
              if (allBasicInfoMap.containsKey(e)) {
                return Card(
                  color: Colors.grey,
                  child: Row(
                    children: [
                      TextWithFontWidget(
                        text: allBasicInfoMap[e]!.name,
                        maxLines: 2,
                      ).paddingWidget(),
                      "Remove".roundButton(onTap: () async {
                        await removeMemberFromGroupModel(
                            groupModel: groupModel, memberUid: e);
                        startUsersStream();
                        if (mounted) {
                          setState(() {});
                        }
                      }).paddingWidget()
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            }).toList(),
          ).scrollRowWidget(),
          TextWithFontWidget(text: "Add New Members"),
          StreamBuilder<List<BasicUserInfoModel>>(
              stream: just,
              builder: (_, data) {
                if (data.hasData) {
                  allUsers = data.data as List<BasicUserInfoModel>;

                  return Column(
                    children: allUsers.map((e) {
                      if (groupModel.membersIds.contains(e.uid)) {
                        return SizedBox();
                      }
                      return Card(
                        color: Colors.grey,
                        child: Row(
                          children: [
                            TextWithFontWidget(
                              text: e.name,
                              maxLines: 2,
                            ).paddingWidget().expnd(),
                            "Add".roundButton(onTap: () async {
                              await addNewmemberToGroupUsingGroupModel(
                                  groupModel: groupModel, memberUid: e.uid);
                              startUsersStream();
                              if (mounted) {
                                setState(() {});
                              }
                            }).paddingWidget()
                          ],
                        ),
                      );
                    }).toList(),
                  ).scrollColumnWidget();
                }

                return SizedBox();
              }).expnd(),
        ],
      )),
    );
  }
}
