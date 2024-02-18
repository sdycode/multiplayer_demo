import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> internetAvaliable() async {
  ConnectivityResult res = await Connectivity().checkConnectivity();
  if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

Future<bool> noInternetAvailable() async {
  return !(await internetAvaliable());
}

void onNetChanged({required ValueChanged<ConnectivityResult> onChanged}) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if ([ConnectivityResult.mobile, ConnectivityResult.wifi].contains(result)) {
      onChanged(result);
    }
  });
}
