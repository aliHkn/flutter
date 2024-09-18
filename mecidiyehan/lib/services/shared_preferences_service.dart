import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPreferencesService {
  static Future<void> loadSavedValues(
      List<TextEditingController> controllers,
      StateSetter setState,
      void Function(double, double) updateBrightness) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 12; i++) {
      String key = 'textController_$i';
      controllers[i].text = prefs.getString(key) ?? '';
    }

    setState(() {
      updateBrightness(prefs.getDouble('brightness1') ?? 0.0,
          prefs.getDouble('brightness2') ?? 0.0);
    });
  }

  static Future<void> saveValues(List<TextEditingController> controllers,
      double brightness1, double brightness2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 12; i++) {
      String key = 'textController_$i';
      await prefs.setString(key, controllers[i].text);
    }
    await prefs.setDouble('brightness1', brightness1);
    await prefs.setDouble('brightness2', brightness2);
  }
}
