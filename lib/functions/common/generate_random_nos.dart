

import 'dart:math';

List<int> generateRandomUniqueNumbers(int nos, int maxNo) {
  if (nos > maxNo) {
    int t =maxNo;
    maxNo =nos;
    nos = t;
    
    // throw ArgumentError('nos should be less than or equal to maxNo');
  }

  var random = Random();
  var uniqueNumbers = <int>{};

  while (uniqueNumbers.length < nos) {
    uniqueNumbers.add(random.nextInt(maxNo + 1));
  }

  return uniqueNumbers.toList();
}