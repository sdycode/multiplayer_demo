import 'dart:developer';

import 'package:flutter/foundation.dart';


void dblog(String s) {
  if (kDebugMode) {
    log(s);
  }
}