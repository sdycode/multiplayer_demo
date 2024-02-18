import 'package:flutter/services.dart';

final TextInputFormatter intFormatters = FilteringTextInputFormatter.digitsOnly;
final TextInputFormatter doubleFormatterr = FilteringTextInputFormatter.allow(
  RegExp(r'^[\d\s.-]*$'), // Allows digits, spaces, dashes, and dots
);

final TextInputFormatter capitalLetterAndNumberFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]'));
final TextInputFormatter lettersAndNumbers =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
bool isValidEmail(String email) {
  // Robust regular expression based on RFC 5322:
  final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return emailRegex.hasMatch(email);
}
