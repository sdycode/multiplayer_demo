import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/styles.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';

extension Styles on num {
  ShapeBorder cardRoundShape() =>
      RoundedRectangleBorder(borderRadius: this.borderRadiusCircular());
}
