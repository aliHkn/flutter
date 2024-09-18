import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();
  }
}
