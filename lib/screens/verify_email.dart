import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:roomertenant/screens/new_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  var _formKey = GlobalKey<FormState>();
  var otpController = TextEditingController();
  String? mobile;

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    mobile = pref.getString('mobile_no').toString();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                color: Constant.bgLight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Verify OTP',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Container
            Positioned(
                top: 85,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Please enter your 6 digit verification code'),
                                ),
                                SizedBox(height: 20,),
                                Pinput(
                                  length: 6,
                                  controller: otpController,
                                  inputFormatters: [NumericOnlyPasteFormatter()],
                                  // focusNode: focusNode,
                                  androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.smsUserConsentApi,
                                  listenForMultipleSmsOnAndroid: true,
                                  // defaultPinTheme: defaultPinTheme,
                                  // separatorBuilder: (index) => const SizedBox(width: 8),
                                  /*validator: (value) {
                                                    return value == null || value.isEmpty || value.length != 6 ? 'Enter OTP' : null;
                                                  },*/
                                  validator: (value) {
                                    if(value == null || value.isEmpty || value.length != 6){
                                      return 'Please enter valid OTP';
                                    }
                                    return null;
                                  },
                                  // onClipboardFound: (value) {
                                  //   debugPrint('onClipboardFound: $value');
                                  //   pinController.setText(value);
                                  // },
                                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                                  onCompleted: (pin) {
                                    debugPrint('onCompleted: $pin');
                                  },
                                  onChanged: (value) {
                                    debugPrint('onChanged: $value');
                                  },
                                  cursor: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 9),
                                        width: 22,
                                        height: 1,
                                        // color: focusedBorderColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                    onTap: () async {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          elevation: 0.0,
                                          backgroundColor:Colors.transparent,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.all(Radius.circular(20))),
                                          // // contentPadding: EdgeInsets.all(24),
                                          insetPadding: EdgeInsets.symmetric(horizontal: 155),
                                          content: Container(
                                              color: Colors.transparent,
                                              height: 40,
                                              width: 40,
                                              child: const CircularProgressIndicator(color: Constant.bgText,)),
                                        );
                                      },);
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      var mobile_no = pref.getString('mobile_no').toString();
                                      API.forgotPassword(mobile_no).then((value) async {
                                        if(value.success == 1){
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.details.toString()), backgroundColor: Colors.green));

                                        }else{
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.details.toString()), backgroundColor: Colors.green));
                                        }
                                      });
                                    },
                                    child: Text('Resend Code', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),))
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){

                              if(_formKey.currentState!.validate()){
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    elevation: 0.0,
                                    backgroundColor:Colors.transparent,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.all(Radius.circular(20))),
                                    // // contentPadding: EdgeInsets.all(24),
                                    insetPadding: EdgeInsets.symmetric(horizontal: 155),
                                    content: Container(
                                        color: Colors.transparent,
                                        height: 40,
                                        width: 40,
                                        child: const CircularProgressIndicator(color: Constant.bgText)),
                                  );
                                },);

                                API.interestedOtp('verifyOTPNumber',
                                    mobile.toString(), otpController.text).then((value) async {
                                  if(value['success'] == 1){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewPassword()));
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                  }
                                });

                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Constant.bgText,
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(child: Text('Verify', style: TextStyle(color: Colors.white),))),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ]
      ),
      // bottomNavigationBar: BottomAppBar(
      //   surfaceTintColor: Colors.white,
      //   child:
      // ),
    );
  }
}


class NumericOnlyPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Only allow numeric input
    final numericRegex = RegExp(r'^[0-9]*$');
    if (numericRegex.hasMatch(newValue.text)) {
      return newValue;
    } else {
      // Filter out non-numeric characters
      final filteredText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      return TextEditingValue(
        text: filteredText,
        selection: TextSelection.collapsed(offset: filteredText.length),
      );
    }
  }
}
