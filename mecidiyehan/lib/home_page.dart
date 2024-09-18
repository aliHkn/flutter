import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'widgets/select_device_dialog.dart';
import 'widgets/contact_dialog.dart';
import 'services/shared_preferences_service.dart';
import 'services/bluetooth_service.dart';
import 'services/permission_service.dart';
import 'utils/numeric_text_formatter.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothConnection? _connection;
  bool _isConnected = false;
  final List<TextEditingController> _textControllers =
      List.generate(12, (index) => TextEditingController());
  double _brightness1 = 0.0;
  double _brightness2 = 0.0;

  final List<String> _labels = [
    'Melengiç Kahvesi',
    'Limonata',
    'Beyran',
    'Lahmacun',
    'Patlıcan Kebabı',
    'AliNazik',
    'Küşleme',
    'Peynirli Künefe',
    'Hasır Künefe',
    'Çikolatalı Muska Katmer',
    'Serpme Kahvaltı',
    'Katmer',
  ];

  final List<String> _keys = [
    '"nmcgdchvnhmsykl"',
    '"mlytncnhmd"',
    '"ynyrcdhnbm"',
    '"chynmdnhlmc"',
    '"bdclycpkmbnhnt"',
    '"mylhnczndk"',
    '"ksnchydmml"',
    '"fydcklynnrhnpm"',
    '"cnhksdynhfrm"',
    '"rnmmkkcthmdsy"',
    '"dmhtklchyvn"',
    '"hmhcrmnkyt"',
  ];

  @override
  void initState() {
    super.initState();
    PermissionService.checkPermissions();
    BluetoothService.getBluetoothState().then((state) {
      setState(() {});
    });

    BluetoothService.onBluetoothStateChanged().listen((BluetoothState state) {
      setState(() {});
    });

    SharedPreferencesService.loadSavedValues(_textControllers, setState,
        (brightness1, brightness2) {
      _brightness1 = brightness1;
      _brightness2 = brightness2;
    });
  }

  Future<void> _listBondedDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectDeviceDialog(
          devices: devices,
          onSelect: (device) {
            setState(() {});
            Navigator.of(context).pop();
            _connectToDevice(device);
          },
        );
      },
    );
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      setState(() {
        _connection = connection;
        _isConnected = true;
      });
    } catch (e) {
      print('Bağlantı sağlanamadı, hata oluştu: $e');
    }
  }

  void _sendMessage() {
    if (_isConnected && _connection != null) {
      Map<String, String> data = {};

      for (int i = 0; i < _textControllers.length; i++) {
        data[_keys[i]] =
            _textControllers[i].text.isEmpty ? "-13" : _textControllers[i].text;
      }

      data['"1hlnlrpdkkymc"'] = _brightness1.toString();
      data['"2dycmprnllkhk"'] = _brightness2.toString();
      data['"password"'] = '"cmidgiaeayenH"';

      _connection!.output.add(Uint8List.fromList(data.toString().codeUnits));

      SharedPreferencesService.saveValues(
          _textControllers, _brightness1, _brightness2);
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MecidiyeHan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.contact_page, color: Colors.white),
          onPressed: _showContactDialog,
        ),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.bluetooth,
                  color: _isConnected ? Colors.green : Colors.white,
                ),
                if (!_isConnected)
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 12,
                    ),
                  ),
              ],
            ),
            onPressed: _listBondedDevices,
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Asset/Mecidiye-Han-mobil-arkaplan.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _textControllers.length, // Fix itemCount
                  itemBuilder: (context, index) {
                    // Always return _buildTextField for each index
                    if (index == 9) {
                      return Column(
                        children: [
                          _buildTextField(index, _labels[index]),
                          const Text(
                            'Parlaklık',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          Slider(
                            value: _brightness1,
                            min: 0,
                            max: 7,
                            divisions: 8,
                            onChanged: (double value) {
                              setState(() {
                                _brightness1 = value;
                              });
                            },
                          ),
                        ],
                      );
                    } else if (index == 11) {
                      return Column(
                        children: [
                          _buildTextField(index, _labels[index]),
                          const Text(
                            'Parlaklık',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          Slider(
                            value: _brightness2,
                            min: 0,
                            max: 15,
                            divisions: 16,
                            onChanged: (double value) {
                              setState(() {
                                _brightness2 = value;
                              });
                            },
                          ),
                        ],
                      );
                    } else {
                      return _buildTextField(index, _labels[index]);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Yükle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(int index, String labelText) {
    List<TextInputFormatter> inputFormatters;

    if (index >= 0 && index < 10) {
      inputFormatters = [NumericTextFormatter()];
    } else if (index == 10 || index == 11) {
      inputFormatters = [NumericTextFormatter1()];
    } else {
      inputFormatters = [];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textControllers[index],
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.redAccent),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: inputFormatters,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showContactDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ContactDialog();
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}
