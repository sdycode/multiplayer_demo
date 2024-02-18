import 'package:flutter/material.dart';

Route transitionFadeRouteForNavigation(Widget page) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 1500),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const double begin = 0;
      const double end = 1;
      const curve = Curves.ease;

      var tween =
          Tween<double>(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        // : animation.drive(tween),
        opacity: animation.drive(tween),
        child: child,
      );
    },
  );
}

Future navigateWithFadeTransitionToScreen(
    BuildContext context, Widget page) async {
  return await Navigator.push(context, transitionFadeRouteForNavigation(page));
}
