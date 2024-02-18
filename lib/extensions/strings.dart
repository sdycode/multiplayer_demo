import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/global.dart';

import 'package:multiplayer_demo/extensions/colors.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

// extension CapitaliseFirstLetter

extension OnString on String {
  DecorationImage decoImg({BoxFit? fit, double? opacity}) {
    return DecorationImage(
        image: AssetImage(this),
        fit: fit ?? BoxFit.fill,
        opacity: opacity ?? 1);
  }

  TextStyle fontTextStyle() {
    return TextStyle(fontFamily: this);
  }

  String convertStringToTitleCase() {
    List<String> words = this.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord = word[0].toUpperCase() + word.substring(1);
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }

  String capitalFirstLetterInString() {
    if (this.trim().isEmpty) {
      return this;
    }
    if (this.trim().length == 1) {
      return this.toUpperCase();
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  Widget roundButton(
      {Color? bgColor,
      required VoidCallback onTap,
      bool flex = true,
      Color? textColor,
      FontWeight? fontWeight,
      double? fontsize,
      double? horzPad,
      bool nonTappable = false,
      bool expanded = true,
      bool loading = false,
      Widget? rightIcon,
      Widget? leftIcon,
      double? vertPadding,
      int? maxLines}) {
    return TextButton(
        onPressed: () {
          if (!loading) {
            onTap();
          }
        },
        style: ButtonStyle(
            backgroundColor: ((bgColor ?? const Color(0xff0988D1))
                    .withOpacity(loading ? 0.6 : 1))
                .color(),
            shape: MaterialStateProperty.all(const StadiumBorder())),
        child: loading
            ? const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ).verticalPadding(pad: w * 0.02)
            : TextWithFontWidget(
                text: this,
                maxLines: maxLines ?? 1,
                fontsize: fontsize ?? 18,
                fontweight: fontWeight ?? FontWeight.w500,
                color: textColor ?? Colors.white,
              )
                .addToLeft(widget: leftIcon)
                .addToRight(widget: rightIcon)
                .symmetricPadding(horz: horzPad ?? 4, vert: vertPadding ?? 4));
  }

  Widget roundButtonExpanded(
      {Color? bgColor,
      required VoidCallback onTap,
      bool flex = true,
      Color? textColor,
      FontWeight? fontWeight,
      double? fontsize,
      double? horzPad,
      bool nonTappable = false,
      bool expanded = true,
      bool loading = false,
      Widget? rightIcon,
      Widget? leftIcon,
      double? vertPadding,
      int? maxLines}) {
    return Container(
      width: expanded ? double.infinity : null,
      child: TextButton(
          onPressed: () {
            if (!loading) {
              onTap();
            }
          },
          style: ButtonStyle(
              backgroundColor: ((bgColor ?? const Color(0xff0988D1))
                      .withOpacity(loading ? 0.6 : 1))
                  .color(),
              shape: MaterialStateProperty.all(const StadiumBorder())),
          child: loading
              ? const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ).verticalPadding(pad: w * 0.02)
              : TextWithFontWidget(
                  text: this,
                  maxLines: maxLines ?? 1,
                  fontsize: fontsize ?? 18,
                  fontweight: fontWeight ?? FontWeight.w500,
                  color: textColor ?? Colors.white,
                )
                  .addToLeft(widget: leftIcon)
                  .addToRight(widget: rightIcon)
                  .symmetricPadding(
                      horz: horzPad ?? 4, vert: vertPadding ?? 4)),
    );
  }

  Widget elevatedStringButton(VoidCallback onTap,
      {Color? bgColor,
      bool flex = true,
      Color? textColor,
      double? fontsize,
      double? horzPad,
      bool nonTappable = false,
      bool expanded = false,
      bool loading = false}) {
    return ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
                foregroundColor: textColor == null
                    ? Colors.black.color()
                    : textColor.color(),
                backgroundColor: bgColor == null
                    // Color(0xffAE0000)
                    ? (const Color(0xff0988D1)
                            .withOpacity(nonTappable ? 0.5 : 1))
                        .color()
                    : bgColor.color()),
            onPressed: loading ? () {} : onTap,
            child: loading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ).verticalPadding(pad: w * 0.02)
                : Text(
                    this,
                    style: TextStyle(
                        fontSize: fontsize ?? w * 0.048,
                        color: textColor ?? Colors.white),
                  ).verticalPadding(pad: w * 0.03))
        .symmetricPadding(horz: horzPad ?? w * 0.02 * 0, vert: w * 0.02);
  }

  Widget elevatedStringButtonHorzExpanded(VoidCallback onTap,
      {Color? bgColor,
      bool flex = true,
      Color? textColor,
      double? fontsize,
      double? horzPad,
      bool nonTappable = false,
      bool expanded = false,
      bool loading = false}) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
                  foregroundColor: textColor == null
                      ? Colors.black.color()
                      : textColor.color(),
                  backgroundColor: bgColor == null
                      // Color(0xffAE0000)
                      ? (const Color(0xff0988D1)
                              .withOpacity(nonTappable ? 0.5 : 1))
                          .color()
                      : bgColor.color()),
              onPressed: loading ? () {} : onTap,
              child: loading
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ).verticalPadding(pad: w * 0.02)
                  : Text(
                      this,
                      style: TextStyle(
                          fontSize: fontsize ?? w * 0.048,
                          color: textColor ?? Colors.white),
                    ).verticalPadding(pad: w * 0.03))
          .symmetricPadding(horz: horzPad ?? w * 0.02 * 0, vert: w * 0.02),
    ).expnd(isExpand: expanded);
  }
}
