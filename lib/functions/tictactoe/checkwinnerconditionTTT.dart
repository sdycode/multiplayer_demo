// ignore_for_file: file_names

import 'package:tuple/tuple.dart';

bool areAllBoxesAreMarked(List<int> blockMarks) {
  for (var e in blockMarks) {
    if (e == 0) {
      /// marking remaining
      return false;
    }
  }
  return true;
}

Tuple2<int, int> winnerNo(List<int> blockMarks) {
  /// -1 for tie, 0 for 1st player (X), 1 for O 2nd player
  // if (areAllBoxesAreMarked(blockMarks)) {
  //   return 0;
  // }
  List<List<int>> winningConditions = [
    [0, 1, 2], // Top row
    [3, 4, 5], // Middle row
    [6, 7, 8], // Bottom row
    [0, 3, 6], // Left column
    [1, 4, 7], // Middle column
    [2, 5, 8], // Right column
    [0, 4, 8], // Diagonal (top left to bottom right)
    [2, 4, 6], // Diagonal (top right to bottom left)
  ];

  // Validate input

  // Check each winning condition
    int count =0;
  for (var condition in winningConditions) {
    if (blockMarks[condition[0]] == blockMarks[condition[1]] &&
        blockMarks[condition[1]] == blockMarks[condition[2]] &&
        blockMarks[condition[0]] != 0) {
          return Tuple2(blockMarks[condition[0]], count);
       // Return winner number (1 or 2)
      //  Tuple2 (winner no 1/2,   stick no)
    }
    count++;
  }

  return Tuple2(0, 0);
}
