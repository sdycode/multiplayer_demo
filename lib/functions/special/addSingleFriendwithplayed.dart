import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/functions/special/join_2_strings_asper_order.dart';

Future addSingleFriendwithplayed(String friendUid, {String? myUid}) async {
  if (isInvalidCurrentUser) {
    return;
  }

  String _myUid = myUid ?? validId;
  String joinedUids = join2StringsAsperOrder(_myUid, friendUid);
  final ref =
      FirebaseDatabase.instance.ref().child("friendswithplayed2playergame");
  await ref.child(_myUid).child(friendUid).set(friendUid);
  await ref.child(friendUid).child(_myUid).set(_myUid);
}

Stream<List<String>>? getFriendWhomWithPlayed() {
  Stream<List<String>>? friendStream;
  friendStream = FirebaseDatabase.instance
      .ref()
      .child("friendswithplayed2playergame")
      .child(validId)
      .onValue
      .map((event) {
    dblog("friendswithplayed2playergame ${event.snapshot.children.length}");
    List<String> friendUIds = [];
    for (var e in event.snapshot.children) {
      friendUIds.add(e.key.toString());
    }
    return friendUIds;
  });
  return friendStream;
}

Future updateCurrentInvite({
  required String uidWhoInvited,
  required String uidToWhomInvited,
}) async {
  final ref = FirebaseDatabase.instance.ref().child("currentinvite");
  await ref.child(uidToWhomInvited).set(uidWhoInvited);
}
