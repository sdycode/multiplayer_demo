// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TicTacToeGamePlay {
  final String gamePlayId;
  final List<String> playerIds;
  List<int> blockMarks;
  int turnNo;
  bool update;
  int firstPlayerNo;
  TicTacToeGamePlay(
      {required this.gamePlayId,
      required this.playerIds,
      required this.blockMarks,
      this.turnNo = 0,
      this.update = true,
      this.firstPlayerNo = 0});

  TicTacToeGamePlay copyWith({
    String? gamePlayId,
    List<String>? playerIds,
    List<int>? blockMarks,
    int? turnNo,
    bool? update,
    int? firstPlayerNo,
  }) {
    return TicTacToeGamePlay(
      gamePlayId: gamePlayId ?? this.gamePlayId,
      playerIds: playerIds ?? this.playerIds,
      blockMarks: blockMarks ?? this.blockMarks,
      turnNo: turnNo ?? this.turnNo,
      update: update ?? this.update,
      firstPlayerNo: firstPlayerNo ?? this.firstPlayerNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gamePlayId': gamePlayId,
      'playerIds': playerIds,
      'blockMarks': blockMarks,
      'turnNo': turnNo,
      'update': update,
      'firstPlayerNo': firstPlayerNo,
    };
  }

  factory TicTacToeGamePlay.fromMap(Map  map) {
    return TicTacToeGamePlay(
      gamePlayId: map['gamePlayId'] as String,
      playerIds: List<String>.from((map['playerIds'] as List)),
      blockMarks: List<int>.from((map['blockMarks'] as List)),
      turnNo: map['turnNo'] as int,
      update: map['update'] as bool,
      firstPlayerNo:map['firstPlayerNo']==null?0: map['firstPlayerNo'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicTacToeGamePlay.fromJson(String source) =>
      TicTacToeGamePlay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TicTacToeGamePlay(gamePlayId: $gamePlayId, playerIds: $playerIds, blockMarks: $blockMarks, turnNo: $turnNo, update: $update, firstPlayerNo: $firstPlayerNo)';
  }

  @override
  bool operator ==(covariant TicTacToeGamePlay other) {
    if (identical(this, other)) return true;

    return other.gamePlayId == gamePlayId &&
        listEquals(other.playerIds, playerIds) &&
        listEquals(other.blockMarks, blockMarks) &&
        other.turnNo == turnNo &&
        other.update == update &&
        other.firstPlayerNo == firstPlayerNo;
  }

  @override
  int get hashCode {
    return gamePlayId.hashCode ^
        playerIds.hashCode ^
        blockMarks.hashCode ^
        turnNo.hashCode ^
        update.hashCode ^
        firstPlayerNo.hashCode;
  }
}
