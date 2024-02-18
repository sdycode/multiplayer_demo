import 'package:flutter/material.dart';

Future<DateTime?> showAndPickDatePickerDialog(BuildContext context,
{
  DateTime? initialDate,
   DateTime? firstDate,
}
) async {
  return showDatePicker(
    context: context,
    initialDate: initialDate?? DateTime.now(),
    firstDate: firstDate?? DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365 * 100)),
    selectableDayPredicate: (day) {
      return true;
    },
  );
}

Future<TimeOfDay?> showAndPickTimePickerDialog(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}
