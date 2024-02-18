import 'package:geolocator/geolocator.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';

class DeviceLocation {
  DeviceLocation._();

  static final DeviceLocation instance = DeviceLocation._();

  factory DeviceLocation() => instance;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  // Accessor methods and properties for location data

  LatLongPos permanentPosition = LatLongPos(lat: 0, long: 0);
  LatLongPos currentPosition = LatLongPos(lat: 0, long: 0);
  bool isPermanentPositionDummy() {
    return permanentPosition.lat == 0 && permanentPosition.long == 0;
  }

  bool isCurrentPositionDummy() {
    return currentPosition.lat == 0 && currentPosition.long == 0;
  }

  getAndSetCurrentPosition() async {
    Position? position = await getCurrentPosition();
    dblog("latlongpos $position");
    if (position != null) {
      currentPosition =
          LatLongPos(lat: position.latitude, long: position.longitude);
    }
  }

  getAndSetPermanentPosition() async {
    Position? position = await getCurrentPosition();
    if (position != null) {
      permanentPosition =
          LatLongPos(lat: position.latitude, long: position.longitude);
    }
  }

  Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      try {
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) return lastPosition;
      } catch (e) {}
    }
    dblog("permi $hasPermission");
    try {
      final position = await _geolocatorPlatform.getCurrentPosition();
      return position;
    } catch (e) {}
    return null;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await _geolocatorPlatform.requestPermission();
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    dblog("permission ${permission.name}");
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await _geolocatorPlatform.requestPermission();

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _geolocatorPlatform.openLocationSettings();
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }
}
