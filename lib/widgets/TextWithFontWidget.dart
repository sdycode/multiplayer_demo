import 'package:flutter/material.dart';
 
import 'package:provider/provider.dart';


class TextWithFontWidget extends StatelessWidget {
  final String text;
  final double fontsize;
  final FontWeight fontweight;
  final Color color;
  final TextAlign align;
  final int maxLines;
  TextOverflow? overflow;
  TextStyle? font;
  String? fontFamily;
  bool? useGoogleFont;
  final bool? isUnderlined;
  bool? primary;
  TextWithFontWidget(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 20,
      this.fontweight = FontWeight.normal,
      this.overflow = TextOverflow.visible,
      this.font,
      this.isUnderlined,
      this.color = Colors.white,
      this.align = TextAlign.center,
      this.fontFamily,
      this.useGoogleFont = false})
      : super(key: key);
  TextWithFontWidget.large(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 40,
      this.fontweight = FontWeight.normal,
      this.overflow = TextOverflow.visible,
      this.font,
      this.isUnderlined,
      this.color = Colors.black,
      this.align = TextAlign.center,
      this.fontFamily,
      this.useGoogleFont = false})
      : super(key: key);
  TextWithFontWidget.primary(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 20,
      this.fontweight = FontWeight.normal,
      this.overflow = TextOverflow.visible,
      this.font,
      this.isUnderlined,
      this.color = Colors.black,
      this.align = TextAlign.center,
      this.fontFamily,
      this.primary = true,
      this.useGoogleFont = false})
      : super(key: key);
  TextWithFontWidget.title(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 20,
      this.fontweight = FontWeight.normal,
      this.overflow = TextOverflow.visible,
      this.color = Colors.black,
      this.align = TextAlign.center,
      this.fontFamily,
      this.isUnderlined,
      this.useGoogleFont = false})
      : super(key: key);

  
  TextWithFontWidget.black(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 20,
      this.fontweight = FontWeight.normal,
      this.font,
      this.isUnderlined,
      this.color = Colors.black,
      this.align = TextAlign.center,
      this.fontFamily})
      : super(key: key);
  TextWithFontWidget.white(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.fontsize = 20,
      this.fontweight = FontWeight.normal,
      this.font,
      this.isUnderlined,
      this.color = Colors.white,
      this.align = TextAlign.center,
      this.fontFamily})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // font = font ?? GoogleFonts.poppins();
    if (fontFamily != null) {
      font = TextStyle(fontFamily: fontFamily);
    }
    if (useGoogleFont != null && useGoogleFont == true) {
    } else {
      if (fontFamily != null) {
        font = TextStyle(fontFamily: fontFamily);
      } else {
        // font = TextStyle(fontFamily: Fonts.Blair);
      }
    }
    // ThemesProvider tp = Provider.of<ThemesProvider>(context, listen: false);
    return Text(text,
        textAlign: align,
        maxLines: maxLines,
        style: font == null
            ? TextStyle(
                overflow: overflow,
                color: primary != null ? Theme.of(context).primaryColor : color,
                fontSize: fontsize,
                decoration:
                    isUnderlined == null ? null : TextDecoration.underline,
                fontWeight: fontweight)
            : font?.copyWith(
                overflow: overflow,
                color: primary != null ?Theme.of(context).primaryColor  : color,
                decoration:
                    isUnderlined == null ? null : TextDecoration.underline,
                fontSize: fontsize,
                fontWeight: fontweight));
  }
}
