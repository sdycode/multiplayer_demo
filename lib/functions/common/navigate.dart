import 'package:flutter/material.dart';

Future navigateTo(BuildContext context, Widget page) async {
  return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

navigatePopContext(BuildContext context, {bool forceBack = true}) {
  if (forceBack) {
    Navigator.pop(context);
  } else {
    Navigator.maybePop(context);
  }
}
