
import 'package:flutter/services.dart';

setPortrait(){
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);
}