import 'package:flutter/material.dart';

class APIprovider with ChangeNotifier {
  int dropdownvalue = 0;

  sendDropDownValue(value) {
    dropdownvalue = value;
    notifyListeners();
  }

  getDropDownValue() => dropdownvalue;
}
