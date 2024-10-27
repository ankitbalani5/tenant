import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Whatsapp {
    openwhatsapp(BuildContext context,
      {required String number, required String content}) async {
    var whatsapp = number;
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=${content}";
    print(whatsappURlAndroid);
    print(whatsapp);
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse(content)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("whatsapp not installed in your phone")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {}
    }
  }
}
