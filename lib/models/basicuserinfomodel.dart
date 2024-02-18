// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:multiplayer_demo/models/latlongpos.dart';

class BasicUserInfoModel {
  String uid;
  String photoUrl;
  String providerType;
  String name;
  String email;
  LatLongPos latLongPos;
  BasicUserInfoModel({
    required this.uid,
    required this.photoUrl,
    required this.providerType,
    required this.name,
    required this.email,
    required this.latLongPos,
  });

  BasicUserInfoModel copyWith({
    String? uid,
    String? photoUrl,
    String? providerType,
    String? name,
    String? email,
    LatLongPos? latLongPos,
  }) {
    return BasicUserInfoModel(
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      providerType: providerType ?? this.providerType,
      name: name ?? this.name,
      email: email ?? this.email,
      latLongPos: latLongPos ?? this.latLongPos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'photoUrl': photoUrl,
      'providerType': providerType,
      'name': name,
      'email': email,
      'latLongPos': latLongPos.toMap(),
    };
  }

  factory BasicUserInfoModel.fromMap(Map  map) {
    return BasicUserInfoModel(
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      providerType: map['providerType'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      latLongPos: LatLongPos.fromMap(map['latLongPos'] as Map ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicUserInfoModel.fromJson(String source) =>
      BasicUserInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BasicUserInfoModel(uid: $uid, photoUrl: $photoUrl, providerType: $providerType, name: $name, email: $email, latLongPos: $latLongPos)';
  }

  @override
  bool operator ==(covariant BasicUserInfoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.photoUrl == photoUrl &&
      other.providerType == providerType &&
      other.name == name &&
      other.email == email &&
      other.latLongPos == latLongPos;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      photoUrl.hashCode ^
      providerType.hashCode ^
      name.hashCode ^
      email.hashCode ^
      latLongPos.hashCode;
  }
}
