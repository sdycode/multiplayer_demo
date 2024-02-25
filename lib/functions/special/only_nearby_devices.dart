import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/places.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';

Future<List<String>> getOnlyNearByDevices({double radiusInKM = 0.2}) async {
  List<String> nearMeUids = [];
  GeoHasher geoHasher = GeoHasher();
  if (DeviceLocation.instance.isCurrentPositionDummy()) {
    await DeviceLocation.instance.getAndSetCurrentPosition();
  }
  List<LatLongPos> cornerPoints = getEndCornersSWtoNE(
      centerLat: DeviceLocation.instance.currentPosition.lat,
      centerLong: DeviceLocation.instance.currentPosition.long,
      radiusInKM: radiusInKM);
  dblog("dbevent ${DeviceLocation.instance.currentPosition} ");
  dblog(
      "dbevent ${geoHasher.encode(DeviceLocation.instance.currentPosition.long, DeviceLocation.instance.currentPosition.lat)}");
  List<String> range = [
    geoHasher.encode(cornerPoints[0].long, cornerPoints[0].lat),
    geoHasher.encode(cornerPoints[1].long, cornerPoints[1].lat)
  ];
  range.sort();
  var ref = FirebaseDatabase.instance.ref();

  LatLongPos pachora =
      const LatLongPos(lat: 20.659193607933776, long: 75.34967534958295);
  double pdist =
      calculateDistance(pachora, DeviceLocation.instance.currentPosition);
  dblog("pdist $pdist");
  DatabaseEvent dbEvent = await ref
      .child("locations")
      .orderByKey()
      .startAt(range[0])
      .endAt(range[1])
      .once();
  dblog(
      "dbEvent nearMeUids range ${dbEvent.snapshot.children.length} ${range[0]} / ${range[1]} ");
  dbEvent.snapshot.children.toList().forEach((element) {
    // bool present  = isWithinCircle(centerLat, centerLong, radiusKm, lat, long)
    nearMeUids.add(element.key.toString());
  });
  // nearMeUids.addAll(range);
  nearMeUids.sort();
  dblog("dbEvent nearMeUids ${nearMeUids.length} ${nearMeUids}");

  return nearMeUids;
}
