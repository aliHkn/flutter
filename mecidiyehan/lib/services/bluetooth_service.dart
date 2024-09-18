import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static Future<BluetoothState> getBluetoothState() async {
    return await FlutterBluetoothSerial.instance.state;
  }

  static Stream<BluetoothState> onBluetoothStateChanged() {
    return FlutterBluetoothSerial.instance.onStateChanged();
  }
}
