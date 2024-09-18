import 'package:flutter/services.dart';

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^\d{0,4}(\d{0,3})?$');
    if (newValue.text.length <= 4 && regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class NumericTextFormatter1 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^\d{0,5}(\.\d{0,4})?$');
    if (newValue.text.length <= 6 && regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}