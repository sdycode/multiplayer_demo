import 'dart:math';

extension Valid on String {
  bool isValidDoubleValue() {
    return double.tryParse(this) != null;
  }

  bool isValidIntValue() {
    return int.tryParse(this) != null;
  }

  double getDoubleValue() {
    if (this.isValidDoubleValue()) {
      return double.parse(this);
    }
    return 0;
  }

  int getInt() {
    if (this.isValidDoubleValue()) {
      return double.parse(this).toInt();
    }
    return 0;
  }
}

isValidDoubleValue(String v) {
  return double.tryParse(v) != null;
}

double getDoubleValue(String v) {
  if (isValidDoubleValue(v)) {
    return double.parse(v);
  }
  return 0;
}

extension Number on int {
  int random(){
    return Random().nextInt(this);
  }
  String nTh() {
    switch (this) {
      case 1:
        return "1st";
      case 2:
        return "2nd";
      case 3:
        return "3rd";

      default:
        return "${this.toString()}th";
    }
  }

  String singleToDoubleDigit() {
    if (this < 10) {
      return "0$this";
    }
    return this.toString();
  }

  int secondsReminderFromTotalSeconds() {
    return this % 60;
  }

  int incrementValue([int i = 1, int? upto]) {
    if (upto != null && this + 1 > upto) {
      return this;
    }
    return this + i;
  }

  int incrementValueUpTo({int max = 25}) {
    if (this + 1 > max) {
      return this;
    }
    return this + 1;
  }

  int decrementValueUpto0({int step = 1}) {
    if (this - step < 0) {
      return 0;
    } else {
      return this - step;
    }
  }

  int decrementValueUpto({int limit = 0, int step = 1}) {
    if (this - step < limit) {
      return limit;
    } else {
      return this - step;
    }
  }
}
