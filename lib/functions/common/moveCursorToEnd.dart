import 'package:flutter/material.dart';

void moveCursorToEnd(TextEditingController controller) {
  controller.selection = TextSelection.fromPosition(
    TextPosition(offset: controller.text.length),
  );
}
