import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:multiplayer_demo/widgets/special/get_uid_mail.dart';

Future addBasicUserInfoToFirebase(User user) async {
  String providerType = "Guest";
  if (user.providerData.isNotEmpty) {
    providerType = user.providerData.first.providerId;
  }
  BasicUserInfoModel userInfoModel = BasicUserInfoModel(
      uid: user.uid,
      photoUrl: user.photoURL ?? "",
      providerType: providerType,
      name: user.displayName ?? "Guest",
      email: user.email ?? getUIDMail(user.uid, providerType),
      latLongPos: DeviceLocation.instance.currentPosition);

  final ref = FirebaseDatabase.instance.ref().child("users").child(user.uid);
  await ref.update(userInfoModel.toMap());
}
