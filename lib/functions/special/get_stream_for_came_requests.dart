import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:tuple/tuple.dart';

Future<void> delayedLoop(Duration delay, bool condition(), int maxCount) async {
  int counter = 0;
  while (counter < maxCount && !condition()) {
    await Future.delayed(delay);
    counter++;
  }
  // Handle loop termination based on condition or counter
  if (condition()) {
    print("Loop terminated early due to condition");
  } else {
    print("Loop terminated after $counter iterations");
  }
}

Stream<List<Tuple2<BasicUserInfoModel, ConnectionRequest>>>?
    cameRequestIdStream;
List<Tuple2<BasicUserInfoModel, ConnectionRequest>>?
                requestOfMaybeConnectedUsers;
Future<void> getStreamForCameRequests() async {
  if (isInvalidCurrentUser) {
    return;
  }

  cameRequestIdStream = FirebaseDatabase.instance
      .ref()
      .child("connection_requests")
      .child(validUser.uid)
      .onValue
      .map((event) {
    List<Tuple2<BasicUserInfoModel, ConnectionRequest>> list = [];
    // dblog("uidreq snap ${validUser.uid} : ${event.snapshot.children.length}");

    event.snapshot.children.toList().forEach((e) {
      dblog("uidreq ${(e.value as Map).values.first.toString()}");
      // uids.add(e.key.toString());
      String uid = e.key.toString();
      String requestName = (e.value as Map).values.isEmpty
          ? ""
          : (e.value as Map).values.first.toString();
      ConnectionRequest request = parseConnectionRequest(requestName);
      if (allBasicInfoMap.containsKey(uid)) {
        list.add(Tuple2(allBasicInfoMap[uid]!, request));
      }
    });
    requestOfMaybeConnectedUsers = List.from(list);

    return list;
  });

  return;
}
