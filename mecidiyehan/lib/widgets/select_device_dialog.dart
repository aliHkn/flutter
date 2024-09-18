import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SelectDeviceDialog extends StatelessWidget {
  final List<BluetoothDevice> devices;
  final ValueChanged<BluetoothDevice> onSelect;

  const SelectDeviceDialog(
      {super.key, required this.devices, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cihazı Seçin'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: devices.map((device) {
            return ListTile(
              title: Text(device.name ?? ''),
              subtitle: Text(device.address),
              onTap: () => onSelect(device),
            );
          }).toList(),
        ),
      ),
    );
  }
}
