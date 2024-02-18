import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/specials/enums.dart';

Future sendConnectionRequest({
  required String receiverUid,
}) async {
  if (isInvalidCurrentUser) {
    return;
  }
  final ref = FirebaseDatabase.instance
      .ref()
      .child("connection_requests")
      .child(validUser.uid)
      .child(receiverUid);
  await ref.update({"request": ConnectionRequest.sent.name});
  await updateCameRequestOnReceiverSide(
    senderUid: validUser.uid,
    receiverUid: receiverUid,
  );
}

Future updateCameRequestOnReceiverSide({
  required String senderUid,
  required String receiverUid,
}) async {
  final ref = FirebaseDatabase.instance
      .ref()
      .child("connection_requests")
      .child(receiverUid)
      .child(validUser.uid);
  await ref.update({"request": ConnectionRequest.came.name});
}

Future updateRequest(
    {required String parentId,
    required String childId,
    required ConnectionRequest request}) async {
  final ref = FirebaseDatabase.instance
      .ref()
      .child("connection_requests")
      .child(parentId)
      .child(childId);
  await ref.update({"request": request.name});
}

Future updateRequestToConnectedOnBothSides({
  required String senderUid,
  required String receiverUid,
}) async {
  await updateRequest(
      parentId: senderUid,
      childId: receiverUid,
      request: ConnectionRequest.connected);
  await updateRequest(
      parentId: receiverUid,
      childId: senderUid,
      request: ConnectionRequest.connected);
}

Future rejectCameRequest(
    {required String currentUserId,
    required String personWhoSentRequestId}) async {
  await updateRequest(
      parentId: currentUserId,
      childId: personWhoSentRequestId,
      request: ConnectionRequest.rejected);
  await updateRequest(
      parentId: personWhoSentRequestId,
      childId: currentUserId,
      request: ConnectionRequest.notconnected);
}

Future acceptCameRequest({
  required String senderUid,
  required String receiverUid,
}) async {
  await updateRequestToConnectedOnBothSides(
      receiverUid: receiverUid, senderUid: senderUid);
}



Future removeConnection(String senderUid, String receiverUid)async {
    await updateRequest(
      parentId: senderUid,
      childId: receiverUid,
      request: ConnectionRequest.notconnected);
  await updateRequest(
      parentId: receiverUid,
      childId: senderUid,
      request: ConnectionRequest.notconnected);
}