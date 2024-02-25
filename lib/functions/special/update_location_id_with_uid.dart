import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';

Future updateLocationIdWithUid(
    {required String uid, required LatLongPos latLongPos}) async {
  final ref = FirebaseDatabase.instance.ref();
  String hashKey = GeoHasher().encode(latLongPos.long, latLongPos.lat);
  await ref.child("locations").child(hashKey).set(uid);
}
