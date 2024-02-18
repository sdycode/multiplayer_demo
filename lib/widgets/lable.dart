 
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/paths.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

Widget lable(String text) {
  return TextWithFontWidget.black(
    text: text,
    fontsize: w * 0.04,
  );
}

Widget title(String text) {
  return TextWithFontWidget.black(
    text: text,
    align: TextAlign.start,
    fontsize: w * 0.046,
    fontweight: FontWeight.bold,
  );
}

Widget subTitle(String text) {
  return TextWithFontWidget.black(
    text: text,
    align: TextAlign.start,
    fontsize: w * 0.04,
    fontweight: FontWeight.w800,
  );
}