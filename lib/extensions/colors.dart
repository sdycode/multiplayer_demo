import 'package:flutter/material.dart';

extension MaterialColorr on Color {
  color() {
    return MaterialStateColor.resolveWith((states) => this);
  } percent([int op = 50]) {
    return this.withAlpha((op*2.55).toInt());
  }
}
