import 'package:flutter/material.dart';
import 'package:roomertenant/screens/tenant_complain.dart';

class APIprovider with ChangeNotifier {
  int dropdownvalue = 0;
  int userID = 0;
  String userHeader = "";

  sendDropDownValue(value) {
    dropdownvalue = value;
    notifyListeners();
  }

  getDropDownValue() => dropdownvalue;

  sendUserID(value) {
    userID = value;
    notifyListeners();
  }


  getUserID() => userID;
  sendComplainHeader(value) {
    userHeader = value;
    notifyListeners();
  }

  getComplainHeader() => userHeader;
}
