import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/places.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';
 import 'package:multiplayer_demo/widgets/special/get_location.dart';

class LatLongPage extends StatefulWidget {
  const LatLongPage({super.key});

  @override
  State<LatLongPage> createState() => _LatLongPageState();
}

class _LatLongPageState extends State<LatLongPage> {
  @override
  Widget build(BuildContext context) {
    dblog("latlongpos ${DeviceLocation.instance.isCurrentPositionDummy()}");
    if (DeviceLocation.instance.isCurrentPositionDummy()) {
      DeviceLocation.instance.getAndSetCurrentPosition();
    }
    GeoHasher geoHasher = GeoHasher();
    dblog("encode str ${geoHasher.encode(2.0004009, 2)}");
    String userGeoHash = geoHasher.encode(
        DeviceLocation.instance.currentPosition.lat,
        DeviceLocation.instance.currentPosition.long);
    dblog(
        "range $userGeoHash : ${calculateGeoHashRange(userGeoHash, 2)} : ${DeviceLocation.instance.currentPosition}");

    List<String> hashesKeysOfLatlongs = [];
    String shivajiNagarHasKey =
        geoHasher.encode(shivajiNagar.long, shivajiNagar.lat);
    int directCount = 0;
    int hashCount = 0;

    final corners = calculateSquareCorners(shivajiNagar.lat, shivajiNagar.long);
    double diagdist = calculateDistance(corners[1], corners[0]);
    hashesKeysOfLatlongs.clear();
    for (final corner in corners) {
      hashesKeysOfLatlongs.add(geoHasher.encode(corner.long, corner.lat));
      dblog("corner $corner : ${geoHasher.encode(corner.long, corner.lat)}");
      dblog("${geoHasher.encode(corner.long, corner.lat)}  :  ");
    }
    for (var place in places) {
      String key = geoHasher.encode(place.long, place.lat);
      List values = geoHasher.decode(key);
      hashesKeysOfLatlongs.add(key);
      double hashDistance = calculateDistance(
          shivajiNagar, LatLongPos(lat: values[1], long: values[0]));

      double directDistance = calculateDistance(
          shivajiNagar, LatLongPos(lat: place.lat, long: place.long));
      // dblog(          "${convertStringLength(place.name, 15)} vallues ${place.lat.toStringAsFixed(6)} : ${place.long.toStringAsFixed(6)} :  $key : ${values}");
      // dblog(          "dist ${directDistance.toStringAsFixed(4)} : ${hashDistance.toStringAsFixed(4)}");
      bool inCircle = isWithinCircle(
          shivajiNagar.lat, shivajiNagar.long, 1, place.lat, place.long);

      if (inCircle) {
        dblog(
            "Place : ${convertStringLength(place.name, 15)}  : ${directDistance}");
        directCount++;
      }
    }
    dblog("Placecount has dir $directCount");

    List<LatLongPos> cornerPoints = getEndCornersSWtoNE(
        centerLat: shivajiNagar.lat,
        centerLong: shivajiNagar.long,
        radiusInKM: 0.5);

    List<String> range = [
      geoHasher.encode(cornerPoints[0].long, cornerPoints[0].lat),
      geoHasher.encode(cornerPoints[1].long, cornerPoints[1].lat)
    ];

    // dblog(        "rangelatlong ${geoHasher.decode(range[1])}: ${geoHasher.decode(range[2])} : $minmaxdist ");
    for (var hashkey in hashesKeysOfLatlongs) {
      bool present = isThisStringLiesInBetween(range[0], range[1], hashkey);
      // if(isThisStringLiesInBetween)
      // dblog("Placecount preset $present ${range} : $hashkey");

      if (present) {
        // dblog("present ")
        hashCount++;
      }
    }
    dblog("Placecount has hash $hashCount / ${hashesKeysOfLatlongs.length}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            "upload".roundButton(onTap: () async {
              hashesKeysOfLatlongs.clear();
              for (var place in places) {
                String key = geoHasher.encode(place.long, place.lat);
                hashesKeysOfLatlongs.add(key);
              }
              // Query Firebase Realtime Database
              var ref = FirebaseDatabase.instance.ref();
              await Future.forEach(hashesKeysOfLatlongs, (key) {
                ref.child("locations").child(key).set(key);
              });
            }),
            "Get Filtered".roundButton(onTap: () async {
              List<LatLongPos> cornerPoints = getEndCornersSWtoNE(
                  centerLat: shivajiNagar.lat,
                  centerLong: shivajiNagar.long,
                  radiusInKM: 1.5);

              List<String> range = [
                geoHasher.encode(cornerPoints[0].long, cornerPoints[0].lat),
                geoHasher.encode(cornerPoints[1].long, cornerPoints[1].lat)
              ];
              hashesKeysOfLatlongs.clear();
              for (var place in places) {
                String key = geoHasher.encode(place.long, place.lat);
                hashesKeysOfLatlongs.add(key);
              }
              hashCount = 0;
              for (var hashkey in hashesKeysOfLatlongs) {
                bool present =
                    isThisStringLiesInBetween(range[0], range[1], hashkey);
                // if(isThisStringLiesInBetween)
                // dblog("Placecount preset $present ${range} : $hashkey");

                if (present) {
                  dblog("present $hashkey $hashCount");
                  hashCount++;
                }
              }
              var ref = FirebaseDatabase.instance.ref();
              hashCount = 0;
              DatabaseEvent dbEvent = await ref
                  .child("locations")
                  .orderByKey()
                  .startAt(range[0])
                  .endAt(range[1])
                  .once();
              dblog("dbEvent present ${dbEvent.snapshot.children.length}");
              dbEvent.snapshot.children.forEach((element) {
                dblog("present ${element.value} $hashCount : dbev");
                hashCount++;
              });
            })
          ],
        ),
      )),
    );
  }
}

