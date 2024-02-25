// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:multiplayer_demo/constants/paths.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/extensions/formatters.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';

class TextFieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final List<Widget>? emailValidatorSuffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? textInputType;
  final int? maxLengths;
  final int? maxLines;
  final bool showEyeButton;
  final List<TextInputFormatter>? inputFormatters;
  final bool withPrimaryBorder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<String>? autofillHints;
  final FocusNode? focusNode;
  final bool enableRoundStadiumBorder;
  const TextFieldBox({
    Key? key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.emailValidatorSuffixIcon,
    this.onSubmitted,
    this.textInputType,
    this.maxLengths,
    this.maxLines,
    this.showEyeButton = false,
    this.inputFormatters,
    this.withPrimaryBorder = true,
    this.suffixIcon,
    this.prefixIcon,
    this.autofillHints,
    this.focusNode,
    this.enableRoundStadiumBorder = true,
  }) : super(key: key);
  TextFieldBox.onlyDigit({
    Key? key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.textInputType,
    this.maxLengths,
    this.onSubmitted,
    this.maxLines,
    this.showEyeButton = false,
    this.inputFormatters,
    this.withPrimaryBorder = true,
    this.autofillHints,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.emailValidatorSuffixIcon,
    this.enableRoundStadiumBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late ThemesProvider tp;
    // tp = Provider.of(context);
    bool showPassword = showEyeButton;
    return StatefulBuilder(builder: (context, state) {
      // dblog("isValidEmail ${controller.text}");
      return TextField(
              focusNode: focusNode,
              autofillHints: autofillHints ?? [],
              inputFormatters: inputFormatters,
              maxLength: maxLengths,
              maxLines: maxLines ?? 1,
              controller: controller,
              keyboardType: textInputType,
              onChanged: (d) {
                if (onChanged != null) {
                  onChanged!(d);
                }
                if (emailValidatorSuffixIcon != null) {
                  state(() {});
                }
              },
              onSubmitted: onSubmitted,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w600),
              cursorColor: Theme.of(context).primaryColor,
              // Color(0xffAE0000),
              obscureText: showEyeButton && !showPassword,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                  suffix: suffixIcon ?? null,
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w400),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: withPrimaryBorder
                          ? roundBorderStyle.borderSide
                          : BorderSide.none,
                      borderRadius: (enableRoundStadiumBorder ? 100 : 12)
                          .borderRadiusCircular()),
                  focusedBorder: roundBorderStyle.copyWith(
                      borderRadius: (enableRoundStadiumBorder ? 100 : 12)
                          .borderRadiusCircular(),
                      borderSide: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).secondaryHeaderColor)),
                  prefixIcon: prefixIcon,
                  suffixIcon: (emailValidatorSuffixIcon != null &&
                          emailValidatorSuffixIcon!.length > 1)
                      ? (isValidEmail(controller.text.trim())
                          ? emailValidatorSuffixIcon![0]
                          : emailValidatorSuffixIcon![1])
                      : showEyeButton
                          ? IconButton(
                              onPressed: () {
                                showPassword = !showPassword;
                                state(() {});
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined,
                                color: Theme.of(context).primaryColor,
                              ))
                          : null
                  // enabledBorder: primaryBorderStyle.copyWith(
                  //     borderSide: BorderSide(width: 0.6, color: tp.color.hint)),
                  // border: primaryBorderStyle.copyWith(
                  //     borderSide:
                  //         BorderSide(width: 0.6, color: tp.color.hint)
                  //         )
                  ))
          .symmetricPadding(horz: 0, vert: 0)
          .symmetricPadding(horz: 0);
    });
  }
}
