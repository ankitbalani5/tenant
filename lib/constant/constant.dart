import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

const Color kappbluecolor = Color(0xff6151FF);

class Constant{
  // static const String navIconColor = '0xff001944';
  static const Color bgLight = Color(0xff8787FF);
  static const Color bgDark = Color(0xff6F6FE4);
  static const Color bgIcon = Color(0xff7777EF);
  static const Color bgButton = Color(0xff6151FF);
  static const Color bgTile = Color(0xffF6F5FF);
  static const Color bgPending = Color(0xffF8D636);
  static const Color bgText = Color(0xff312F8B);
  static const Color bgBtnDark = Color(0xff6151FF);
  static const Color bgBtnLight = Color(0xffE7E5FF);
  static const Color bgGreyText = Color(0xff6F7894);
  // static const Color bgDownloadIcon = Color(0xff6151FF);

  Future<void> saveLatLng (double lat, double lng, String address) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble('lat', lat);
    await sp.setDouble('lng', lng);
    await sp.setString('address', address);
  }

  Future<double> getLat () async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getDouble('lat')??0.0;
  }

  Future<double> getLng () async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getDouble('lng')??0.0;
  }

  Future<String?> getAddress () async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('address')?? "";
  }
}