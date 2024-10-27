import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Common{
  static showDialogLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 40.0,
                    child: SpinKitChasingDots(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: const Text(
                      'Please wait',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static hideDialogLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  static toastWarning(BuildContext context, String message, {Color? backgroundcolor, Color? textcolor}) {
    var snackBar = SnackBar(
      // action: SnackBarAction(
      //   label: "Ok",
      //   onPressed: () {},
      //   textColor: textcolor ?? Colors.white,
      // ),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(color: textcolor ?? Colors.white),
      ),
      backgroundColor: backgroundcolor ?? Colors.red,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
  static showSimpleLoading({Color? color}) {
    return Center(
      child: SpinKitPulse(
        color: color ?? Colors.blue,
      ),
    );
  }
}