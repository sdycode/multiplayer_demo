import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/isemulator.dart';
import 'package:multiplayer_demo/functions/special/update_location_id_with_uid.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:multiplayer_demo/widgets/special/get_uid_mail.dart';

Future addBasicUserInfoToFirebase(User user) async {
  String providerType = "Guest";
  if (user.providerData.isNotEmpty) {
    providerType = user.providerData.first.providerId;
  }
  bool isemultor = await isEmulator();
  LatLongPos pos = DeviceLocation.instance.currentPosition;
  LatLongPos balad =
      const LatLongPos(lat: 20.626691282782208, long: 75.2271231571789);
  LatLongPos bahal =
      const LatLongPos(lat: 20.58762773015267, long: 75.0464965328857);

  LatLongPos pachora =
      const LatLongPos(lat: 20.659193607933776, long: 75.34967534958295);

  if (user.displayName.toString().contains("balad")) {
    pos = balad;
  }
  if (user.displayName.toString().contains("bahal")) {
    pos = bahal;
  } if (user.displayName.toString().contains("pachora")) {
    pos = pachora;
  }
  BasicUserInfoModel userInfoModel = BasicUserInfoModel(
      uid: user.uid,
      photoUrl: user.photoURL ?? "",
      providerType: providerType,
      name: user.displayName ?? "Guest",
      email: user.email ?? getUIDMail(user.uid, providerType),
      latLongPos: pos);

  final ref = FirebaseDatabase.instance.ref().child("users").child(user.uid);
  await ref.update(userInfoModel.toMap());
  await updateLocationIdWithUid(latLongPos: pos, uid: user.uid);
}
