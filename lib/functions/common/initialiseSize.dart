import 'dart:math';

import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/global.dart';

void initialiseGloablSizes(BuildContext context) {
  h = MediaQuery.of(context).size.height;
  w = MediaQuery.of(context).size.width;
  dblog("build h w $h : $w");
}

initialiseGloablSizesForOrientation(BuildContext context,
    {Orientation orientation = Orientation.landscape}) {
  double minSize = min(
      MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

  double maxSize = max(
      MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

  if (orientation == Orientation.landscape) {
    h = minSize;
    w = maxSize;
  } else {
    w = minSize;
    h = maxSize;
  }
  dblog("sizes for $orientation : $w : $h");
}

void initialiseSizesForLandscape(BuildContext context) {
  initialiseGloablSizesForOrientation(context,
      orientation: Orientation.landscape);
}

void initialiseSizesForPortrait(BuildContext context) {
  initialiseGloablSizesForOrientation(context,
      orientation: Orientation.portrait);
}
