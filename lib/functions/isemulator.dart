import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isEmulator() async {
  AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  return androidDeviceInfo.model.contains('sdk_gphone');
}
