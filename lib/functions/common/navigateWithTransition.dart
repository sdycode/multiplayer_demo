import 'package:flutter/material.dart';
import 'package:multiplayer_demo/functions/common/transition_route.dart';

Future navigateWithTransitionToScreen(BuildContext context, Widget page) async {
  // return await Navigator.push(context,MaterialPageRoute(builder: (context) => page,));
  return await Navigator.push(context, transitionRouteForNavigation(page));
}

Future navigateReplaceWithTransitionToScreen(BuildContext context, Widget page,
    {bool replace = true}) async {
  if (replace) {
    return await Navigator.pushReplacement(
        context, transitionRouteForNavigation(page));
  } else {
    navigateWithTransitionToScreen(context, page);
  }
}
