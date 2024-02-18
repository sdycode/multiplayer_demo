import 'dart:convert';

import 'package:multiplayer_demo/extensions/datetime.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:http/http.dart' as http;

Future<DateTime> getInternetTime() async {
  const serverUrl = 'http://worldtimeapi.org/api/ip';
  // 'http://pool.ntp.org/4.us.pool.ntp.org';
  var now = DateTime.now();
  var offset = now.timeZoneOffset.inMinutes;
  try {
    var response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          Map<String, dynamic>.from(jsonDecode(response.body));
      final String dateTimeString = responseData['datetime'];

      // Parse the dateTimeString to a DateTime object
      final DateTime now = DateTime.parse(dateTimeString);
      if (now != null) {
        dblog(
            "now ${nowDTime} : london ${now} : net our ${now.add(Duration(minutes: offset))}");
        return now;
      } else {
        print('Failed to parse time from server response.');
        return DateTime.now();
      }
    } else {
      print('Failed to fetch time from server (${response.statusCode}).');
      return DateTime.now();
    }
  } catch (e) {
    print('Failed Error fetching time from server: $e');
    return DateTime.now();
  }
}
