import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:provider/provider.dart';
import 'package:multiplayer_demo/constants/global.dart';


class SnackBarMessage {
  static void show({required BuildContext context, required String message}) {
    showSnackbarWithButton(context, message);
  }
}

showSnackbarWithButton(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 4),
    content: TextWithFontWidget(
      text: message,
      fontsize: w * 0.045,
      align: TextAlign.start,
      maxLines: 10,
      color: Colors.white,
    ),
    action: SnackBarAction(
        label: "OK",
        textColor: Colors.blue.shade300,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }),
  ));
  Timer(Duration(seconds: 4), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  });
}
