import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/nums.dart';
import 'package:multiplayer_demo/extensions/strings.dart';

extension TimeOfDayExt on TimeOfDay {
  bool areTimeOfDayEqual(
    TimeOfDay time1,
  ) {
    return time1.hour == this.hour && time1.minute == this.minute;
  }

  String hmAMPMFormat() {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, this.hour, this.minute);
    final format = DateFormat.jm(); // 'jm' is for 12 hours format with AM/PM
    return format.format(dateTime);
  }

  String hAMPMFormat() {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, this.hour, this.minute);
    String formattedTime = DateFormat('hh a').format(dateTime);

    return formattedTime;
  }
//   String formatTimeOfDay() {
//   final now = DateTime.now();
//   final dateTime = DateTime(now.year, now.month, now.day, this.hour, this.minute);
//   final formattedTime = DateFormat('hh:mm a').format(dateTime);
//   return formattedTime;
// }
}

extension DateTimeExt on String {
  TimeOfDay timeOfDay(String timeString) {
    try {
      // Extracting the hour and minute strings from the given format
      String time = timeString.substring(10, 15);

      // Parsing the hour and minute from the extracted string
      List<String> timeSplit = time.split(':');
      int hour = int.parse(timeSplit[0]);
      int minute = int.parse(timeSplit[1]);

      // Creating and returning the TimeOfDay object
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String weekdayDMFormat() {
    DateTime now = DateTime.now();

    DateTime friday = now.add(Duration(days: DateTime.friday - now.weekday));
    String formattedDate = DateFormat('d MMMM').format(DateTime(2023, 9, 8));
    return weekdaysFullname[friday.weekday % 7] + ", " + formattedDate;
  }

  String yearFormat() {
    DateTime dateTime = DateTime.parse(this);
    return dateTime.year.toString();
  }

  String dMYFormat() {
    DateTime dateTime = DateTime.parse(this);
    return DateFormat('d MMM y').format(dateTime);
  }

  String hmFormat() {
    DateTime dateTime = DateTime.parse(this);

    int hours = dateTime.hour;
    int minutes = dateTime.minute;
    return "$hours:$minutes";
  }

  String dnMFormat() {
    DateTime dateTime = DateTime.parse(this);
    String formattedDate = DateFormat('d\nMMM').format(dateTime);
    return formattedDate;
  }

  String timeMinSec() {
    DateTime dateTime = DateTime.parse(this);
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    return formattedTime;
  }

  String ddMMMyyyyFormatt() {
    DateTime dateTime = DateTime.parse(this);

    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  String hmAMFormat() {
    String formattedTime =
        DateFormat('hh:mm a').format(DateTime.parse('2012-02-27 13:27:00'));
    return formattedTime;
  }

  DateTime getDateTime() {
    DateTime? dateTime = DateTime.tryParse(this);
    return dateTime ?? DateTime.now();
  }
}

extension DateTimeExtInt on int {
  DateTime datetimeFromTimeStamp() {
    int timestamp = this;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return dateTime;
  }
}

DateTime get nowDTime => DateTime.now();
List<String> weekdays = [
  "Sun",
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
];
List<String> weekdaysFullname = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

extension DateTimeValue on DateTime {
  String dd_mm_yyyyFormat() {
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();
    return '${day}_${month}_$year';
  }

  String mmmmDYFormat() {
    String formattedDate = DateFormat('MMMM d, y').format(this);
    return formattedDate;
  }

  String dMFormat() {
    String formattedDate = DateFormat('dd MMM', 'en_US').format(this);
    return formattedDate;
  }

  String dNMFormat() {
    String formattedDate = DateFormat('dd MMM', 'en_US').format(this);
    formattedDate = formattedDate.replaceAll(" ", "\n");
    return formattedDate;
  }

  String ddMMyyyyFormat() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  bool checkIfYesterday({
    DateTime? currentDateTime,
  }) {
    DateTime time = currentDateTime ?? DateTime.now();
    DateTime yesterday = time.subtract(Duration(days: 1));
    return this.year == yesterday.year &&
        this.month == yesterday.month &&
        this.day == yesterday.day;
  }

  bool areDatesSame(
    DateTime date,
  ) {
    return this.year == date.year &&
        this.month == date.month &&
        this.day == date.day;
  }

  bool checkIfToday({DateTime? currentDateTime}) {
    DateTime time = currentDateTime ?? DateTime.now();

    return this.year == time.year &&
        this.month == time.month &&
        this.day == time.day;
  }

  bool checkIfTomorrow({DateTime? currentDateTime}) {
    DateTime time = currentDateTime ?? DateTime.now();

    DateTime tomorrow = time.add(Duration(days: 1));
    return this.year == tomorrow.year &&
        this.month == tomorrow.month &&
        this.day == tomorrow.day;
  }

  DateTime resetTimeAndKeepDate() {
    return DateTime(
      this.year,
      this.month,
      this.day,
      0,
      0,
      0,
    );
  }

  String monthNameYearFormat() {
    return DateFormat('MMM, yyyy').format(this);
  }

  bool isGivenDateToday() {
    DateTime now = DateTime.now();
    return this.year == now.year &&
        this.month == now.month &&
        this.day == now.day;
  }

  bool isThisWithinLastThreeDays() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(this);
    return difference.inDays <= 3 && difference.inDays >= 0;
  }

  String dayAndWeekDayFormat() {
    return (this.day.toString() + "\n" + weekdays[this.weekday - 1]);
  }

  String hmFormatt() {
    int hours = this.hour;
    int minutes = this.minute;
    return "$hours:$minutes";
  }

  String hmAMPMFormatt() {
    int hours = this.hour;
    int minutes = this.minute;
    String AMPM = hours < 12 ? "AM" : "PM";
    return "${(hours % 12).singleToDoubleDigit()}:${minutes.singleToDoubleDigit()} $AMPM";
  }

  TimeOfDay timeOfDayFromDateTime() {
    return TimeOfDay(hour: this.hour, minute: this.minute);
  }

  DateTime changeOnlyTimeForGivenTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(
      this.year,
      this.month,
      this.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  String dMFormattt() {
    // Create a date format with the desired pattern
    final dateFormat = DateFormat("dd MMM");

    // Format the date
    String formattedDate = dateFormat.format(this);

    return formattedDate;
  }

  Duration dateDifference() {
    return DateTime.now().difference(this);
  }

  String ddMMMyyyyFormatt() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String yMDFormat() {
    DateTime d = this;

    return "${d.year}-${d.month.singleToDoubleDigit()}-${d.day.singleToDoubleDigit()}";
  }

  String dMYFormat() {
    return DateFormat('d MMM y').format(this);
  }
}

extension TimeString on String {
  String dateTimeGMT() {
    return DateTime.parse(this).hmAMPMFormatt();
  }

  String dateTimeZString() {
    return DateTime.parse(this).hmAMPMFormatt();
  }

  DateTime dateTimeZ() {
    return DateTime.parse(this);
  }

  String todaytommyesterday() {
    DateTime date = DateTime.parse(this);
    if (date.checkIfYesterday()) {
      return "Yesterday";
      print('Given DateTime is yesterday');
    } else if (date.checkIfToday()) {
      return "Today";
      print('Given DateTime is today');
    } else if (date.checkIfTomorrow()) {
      return "Tomorrow";
      print('Given DateTime is tomorrow');
    } else {
      return date.dMFormat();
      print('Given DateTime is none of yesterday, today, or tomorrow');
    }
  }

  String hmAMPMFormatt() {
    return DateTime.parse(this).hmAMPMFormatt();
  }

  String formatDateWithType2() {
    // September 6th - 07:30 PM

    DateTime dateTime = DateTime.parse(this);
    String month = DateFormat.MMMM().format(dateTime);
    String day = DateFormat.d().format(dateTime);

    String hour = DateFormat.H().format(dateTime);
    String minute = DateFormat.m().format(dateTime);
    String amPm = dateTime.hour < 12 ? "AM" : "PM";

    String formattedDate = '$month $day';

    // Add suffix to day (e.g., 1st, 2nd, 3rd, 4th, etc.)
    if (day.endsWith('1') && !day.endsWith('11')) {
      formattedDate += 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      formattedDate += 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      formattedDate += 'rd';
    } else {
      formattedDate += 'th';
    }

    formattedDate += ' - $hour:$minute $amPm';

    return formattedDate;
  }
}
