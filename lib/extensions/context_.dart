import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

extension WidgetExt on BuildContext {
  double height() {
    return MediaQuery.of(this).size.height;
  }

  double width() {
    return MediaQuery.of(this).size.width;
  }

  bool checkIsKeyboardOpen() {
    return (Platform.isIOS
            ? MediaQuery.of(this).viewInsets.bottom
            : MediaQuery.of(this).viewInsets.bottom) >
        0;
  }

  Widget topPadding() {
    return SizedBox(
      height: Platform.isIOS
          ? MediaQuery.of(this).padding.top
          : MediaQuery.of(this).viewPadding.top,
    );
  }

  Widget leftRightNotchPadding() {
    return SizedBox(
      height: Platform.isIOS
          ? max(MediaQuery.of(this).padding.left,
              MediaQuery.of(this).padding.right)
          : max(MediaQuery.of(this).viewPadding.left,
              MediaQuery.of(this).viewPadding.right),
    );
  }

  EdgeInsets notchPadding() {
    return EdgeInsets.only(
        top: Platform.isIOS
            ? MediaQuery.of(this).viewPadding.top
            : MediaQuery.of(this).padding.top);
  }

  double sideNotchValueDouble() {
    return Platform.isIOS
            ? max(MediaQuery.of(this).viewPadding.left,
                MediaQuery.of(this).viewPadding.right)
            : 0
        // max(MediaQuery.of(this).viewPadding.left,
        //     MediaQuery.of(this).viewPadding.right)
        ;
  }

  double leftRightsideNotchValueDouble({required bool isLeft}) {
    // return isLeft ? 60 : 60;
    return Platform.isIOS
            ? isLeft
                ? MediaQuery.of(this).viewPadding.left
                : MediaQuery.of(this).viewPadding.right
            : isLeft
                ? MediaQuery.of(this).padding.left
                : MediaQuery.of(this).padding.right
        // max(MediaQuery.of(this).viewPadding.left,
        //     MediaQuery.of(this).viewPadding.right)
        ;
  }

  double topNotchValueDouble() {
    return Platform.isIOS
        ? MediaQuery.of(this).padding.top
        : MediaQuery.of(this).viewPadding.top;
  }

  double statusBarHeight() {
    return Platform.isIOS
        ? MediaQuery.of(this).padding.top
        : MediaQuery.of(this).viewPadding.top;
  }

  double keyBoardHeight() {
    return (Platform.isIOS
        ? MediaQuery.of(this).viewInsets.bottom
        : MediaQuery.of(this).viewInsets.bottom);
  }

  SizedBox keyBoardSpace() {
    return SizedBox(
      height: (Platform.isIOS
          ? MediaQuery.of(this).viewInsets.bottom
          : MediaQuery.of(this).viewInsets.bottom),
    );
  }
}
