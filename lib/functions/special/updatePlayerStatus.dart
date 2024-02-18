import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/specials/enums.dart';

Future updatePlayerStatus(
    {required String uid, required PlayerStatus status}) async {
  final ref = FirebaseDatabase.instance.ref().child("playerstatus").child(uid);
  await ref.set(status.name);
}

Future<PlayerStatus?> getPlayerStatus({
  required String uid,
}) async {
  final ref = await FirebaseDatabase.instance
      .ref()
      .child("playerstatus")
      .child(uid)
      .get();
  dblog("ref status ${ref.children.length} :${ref.value}");

  return (ref.value == null)
      ? null
      : playerStatusFromName((ref.value as String));
}
