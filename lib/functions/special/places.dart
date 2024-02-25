import 'package:dart_geohash/dart_geohash.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/models/latlongpos.dart';
import 'package:multiplayer_demo/screens/tictactoe_game/tictactoe_homepage.dart';
import 'dart:math' as math;

import 'package:multiplayer_demo/widgets/special/get_location.dart';

isThisStringLiesInBetween(String start, String end, String given) {
  return start.compareTo(given) < 0 && given.compareTo(end) < 0;
}

// 18.530823, 73.847466. shivaji nagar
const LatLongPos shivajiNagar = LatLongPos(lat: 18.530823, long: 73.847466);
double calculateDistance(LatLongPos latLongPos1, LatLongPos latLongPos2) {
  double lat1 = latLongPos1.lat;
  double lon1 = latLongPos1.long;
  double lat2 = latLongPos2.lat;
  double lon2 = latLongPos2.long; // Convert degrees to radians
  final lat1Rad = degreesToRadians(lat1);
  final lon1Rad = degreesToRadians(lon1);
  final lat2Rad = degreesToRadians(lat2);
  final lon2Rad = degreesToRadians(lon2);

  // Calculate differences in latitude and longitude
  final dLat = lat2Rad - lat1Rad;
  final dLon = lon2Rad - lon1Rad;

  // Calculate part of the formula
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1Rad) *
          math.cos(lat2Rad) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);

  // Calculate the central angle
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  // Earth's radius in kilometers
  const earthRadiusKm = 6371.0;

  // Return the distance in kilometers
  return c * earthRadiusKm;
}

List<String> calculateGeoHashRange(String userGeoHash, double radius) {
  // Get the latitude and longitude from the GeoHash
  final coordinates = GeoHasher().decode(userGeoHash);
  final latitude = coordinates[1];
  final longitude = coordinates[0];

  // Calculate the bounding box corners based on radius and Earth's circumference
  final earthCircumference = 40075.017; // kilometers
  final degreesPerKilometer = 360 / earthCircumference;
  final latDelta = radius * degreesPerKilometer;
  final lonDelta = latDelta /
      math.cos(latitude * math.pi / 180); // Adjust for longitude at latitude

  final minLat = latitude - latDelta;
  final maxLat = latitude + latDelta;
  final minLon = longitude - lonDelta;
  final maxLon = longitude + lonDelta;
  dblog("latlong center ${DeviceLocation.instance.currentPosition}");
  dblog("latlong min $minLat $minLon");
  dblog("latlong max $maxLat $maxLon");

  // Get the bounding box GeoHashes
  final minGeoHash = GeoHasher().encode(minLat, minLon);
  final maxGeoHash = GeoHasher().encode(maxLat, maxLon);

  // Return the range of GeoHashes, including the provided userGeoHash
  return [userGeoHash, minGeoHash, maxGeoHash];
}

String convertStringLength(String string, int targetLength) {
  // Trim the string if it's longer than the target length
  final trimmedString =
      string.substring(0, targetLength.clamp(0, string.length));

  // Add spaces to the end of the string until it reaches the target length
  final padding =
      List<String>.filled(targetLength - trimmedString.length, ' ').join('');

  return trimmedString + padding;
}

bool isWithinCircle(double centerLat, double centerLong, double radiusKm,
    double lat, double long) {
  // Convert degrees to radians
  final centerLatRad = degreesToRadians(centerLat);
  final centerLongRad = degreesToRadians(centerLong);
  final latRad = degreesToRadians(lat);
  final longRad = degreesToRadians(long);

  // Calculate distance using Haversine formula
  final dLat = latRad - centerLatRad;
  final dLon = longRad - centerLongRad;
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(centerLatRad) *
          math.cos(latRad) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  // Earth's radius in kilometers
  const earthRadiusKm = 6371.0;

  // Check if distance is less than or equal to radius
  return c * earthRadiusKm <= radiusKm;
}

// Helper function to convert degrees to radians
double degreesToRadians(double degrees) {
  return degrees * math.pi / 180.0;
}

class PlaceLatlong {
  String name;
  double lat;
  double long;
  PlaceLatlong({
    required this.name,
    required this.lat,
    required this.long,
  });
} // Helper function to convert radians to degrees

double radiansToDegrees(double radians) {
  return radians * 180.0 / math.pi;
}

List<LatLongPos> getEndCornersSWtoNE(
    {required double centerLat,
    required double centerLong,
    required double radiusInKM}) {
  // Earth's radius in kilometers
  const earthRadiusKm = 6371.0;

  // Calculate distance in radians for 1 km on each side
  final distanceRadians = ((radiusInKM / 3)) / earthRadiusKm;

  // Calculate changes in latitude and longitude for each corner
  final deltaLatNorth =
      math.asin(math.sin(distanceRadians) / math.cos(centerLat));
  final deltaLatSouth = -deltaLatNorth;
  final deltaLonEast = distanceRadians / math.cos(centerLat);
  final deltaLonWest = -deltaLonEast;

  // Convert changes back to degrees
  final deltaLatNorthDegrees = radiansToDegrees(deltaLatNorth);
  final deltaLatSouthDegrees = radiansToDegrees(deltaLatSouth);
  final deltaLonEastDegrees = radiansToDegrees(deltaLonEast);
  final deltaLonWestDegrees = radiansToDegrees(deltaLonWest);

  // Calculate corner coordinates
  final northEast = LatLongPos(
      lat: centerLat + deltaLatNorthDegrees,
      long: centerLong + deltaLonEastDegrees);
  final northWest = LatLongPos(
      lat: centerLat + deltaLatNorthDegrees,
      long: centerLong + deltaLonWestDegrees);
  final southEast = LatLongPos(
      lat: centerLat + deltaLatSouthDegrees,
      long: centerLong + deltaLonEastDegrees);
  final southWest = LatLongPos(
      lat: centerLat + deltaLatSouthDegrees,
      long: centerLong + deltaLonWestDegrees);
  dblog("dirEW disr=t ${calculateDistance(northEast, northWest)}");
  dblog("dirEW disr=t ${calculateDistance(southWest, northEast)}");
  return [southWest, northEast];
}

List<LatLongPos> calculateSquareCorners(double centerLat, double centerLong) {
  // Earth's radius in kilometers
  const earthRadiusKm = 6371.0;

  // Calculate distance in radians for 1 km on each side
  final distanceRadians = 1 / earthRadiusKm;

  // Calculate changes in latitude and longitude for each corner
  final deltaLatNorth =
      math.asin(math.sin(distanceRadians) / math.cos(centerLat));
  final deltaLatSouth = -deltaLatNorth;
  final deltaLonEast = distanceRadians / math.cos(centerLat);
  final deltaLonWest = -deltaLonEast;

  // Convert changes back to degrees
  final deltaLatNorthDegrees = radiansToDegrees(deltaLatNorth);
  final deltaLatSouthDegrees = radiansToDegrees(deltaLatSouth);
  final deltaLonEastDegrees = radiansToDegrees(deltaLonEast);
  final deltaLonWestDegrees = radiansToDegrees(deltaLonWest);

  // Calculate corner coordinates
  final northEast = LatLongPos(
      lat: centerLat + deltaLatNorthDegrees,
      long: centerLong + deltaLonEastDegrees);
  final northWest = LatLongPos(
      lat: centerLat + deltaLatNorthDegrees,
      long: centerLong + deltaLonWestDegrees);
  final southEast = LatLongPos(
      lat: centerLat + deltaLatSouthDegrees,
      long: centerLong + deltaLonEastDegrees);
  final southWest = LatLongPos(
      lat: centerLat + deltaLatSouthDegrees,
      long: centerLong + deltaLonWestDegrees);

  return [northEast, northWest, southEast, southWest];
}

List<PlaceLatlong> places = [
  // 18.519576588315225, 73.8552745800192
  PlaceLatlong(name: "Shaniwar Wada", lat: 18.530247, long: 73.846567),
  PlaceLatlong(name: "Saras Baug", lat: 18.52937, long: 73.848473),
  PlaceLatlong(name: "Raja Kelkar Museum", lat: 18.528724, long: 73.850834),
  PlaceLatlong(name: "Sambhaji Garden", lat: 18.528812, long: 73.85335),
  PlaceLatlong(name: "Fergusson College Road", lat: 18.5279, long: 73.855047),
  PlaceLatlong(name: "Pune University", lat: 18.526573, long: 73.858252),
  PlaceLatlong(name: "Aga Khan Palace", lat: 18.52265, long: 73.857911),
  PlaceLatlong(name: "Osho Teerth Park", lat: 18.516417, long: 73.849017),
  PlaceLatlong(name: "Bund Garden", lat: 18.512267, long: 73.842333),
  PlaceLatlong(name: "Empress Gardens", lat: 18.510532, long: 73.840117),
  PlaceLatlong(
      name: "Bal Gandharva Rang Mandir", lat: 18.509127, long: 73.8395),
  PlaceLatlong(
      name: "Raja Ravi Varma Art Gallery", lat: 18.508639, long: 73.8373),
  PlaceLatlong(
      name: "Pune-Okayama Friendship Garden", lat: 18.508444, long: 73.837222),
  PlaceLatlong(name: "Sambhaji Park", lat: 18.507077, long: 73.835389),
  PlaceLatlong(
      name: "Pune Municipal Corporation", lat: 18.506486, long: 73.834833),
  PlaceLatlong(name: "Saraswati Baug", lat: 18.505472, long: 73.834467),
  PlaceLatlong(name: "Saraswati Ganesh Temple", lat: 18.505078, long: 73.83405),
  PlaceLatlong(name: "Pune Stock Exchange", lat: 18.5044, long: 73.833483),
  PlaceLatlong(name: "Pune Race Course", lat: 18.503417, long: 73.832817),
  PlaceLatlong(name: "Balewadi Sports Complex", lat: 18.502167, long: 73.83215),
  PlaceLatlong(name: "Nehru Stadium", lat: 18.501917, long: 73.8318),
  PlaceLatlong(
      name: "Shiv Chhatrapati Sports Complex", lat: 18.501667, long: 73.83145),
  PlaceLatlong(name: "Balaji Temple", lat: 18.5015, long: 73.831267),
  PlaceLatlong(name: "Pune Mirror Office", lat: 18.501083, long: 73.83055),
  PlaceLatlong(
      name: "Pune Municipal Corporation", lat: 18.50075, long: 73.830283),
  PlaceLatlong(name: "Saraswati Natyamandir", lat: 18.500417, long: 73.83),
  PlaceLatlong(name: "Saras Baug Bus Stop", lat: 18.500167, long: 73.82975),
  PlaceLatlong(name: "Pune Railway Station", lat: 18.499917, long: 73.8295),
  PlaceLatlong(name: "Pune Station Bus Stop", lat: 18.499667, long: 73.82925),
  PlaceLatlong(name: "GPO, Pune", lat: 18.499417, long: 73.829),
  PlaceLatlong(
      name: "Pune Municipal Corporation", lat: 18.499167, long: 73.82875),
  PlaceLatlong(name: "Deccan Gymkhana", lat: 18.498917, long: 73.8285),
  PlaceLatlong(name: "Sambhaji Bridge", lat: 18.498667, long: 73.82825),
  PlaceLatlong(name: "Rex Theatre", lat: 18.498417, long: 73.828),
];
