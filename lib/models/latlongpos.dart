// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LatLongPos {
  double lat;
  double long;
  LatLongPos({
    required this.lat,
    required this.long,
  });

  LatLongPos copyWith({
    double? lat,
    double? long,
  }) {
    return LatLongPos(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'long': long,
    };
  }

  factory LatLongPos.fromMap(Map map) {
    return LatLongPos(
      lat: map['lat'] as double,
      long: map['long'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LatLongPos.fromJson(String source) =>
      LatLongPos.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LatLongPos(lat: $lat, long: $long)';

  @override
  bool operator ==(covariant LatLongPos other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.long == long;
  }

  @override
  int get hashCode => lat.hashCode ^ long.hashCode;
}
