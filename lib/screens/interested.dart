import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/interestedOtpModel.dart';
import 'package:roomertenant/screens/booknow_bloc/booknow_bloc.dart';
import 'package:roomertenant/screens/interested_bloc/interested_bloc.dart';
import 'package:roomertenant/screens/login_bloc/login_bloc.dart';
import 'package:roomertenant/screens/no_login.dart';
import 'package:roomertenant/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'explore_bloc/explore_bloc.dart';
import 'internet_check.dart';

class Interested extends StatefulWidget {
  static const String id = 'interested';
  const Interested({super.key});

  @override
  State<Interested> createState() => _InterestedState();
}

class _InterestedState extends State<Interested> {
  var _formKeySendOtp = GlobalKey<FormState>();
  var _formKey = GlobalKey<FormState>();
  var nameEmailValid = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var otpController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var messageController = TextEditingController();
  bool phoneReadonly = false;
  bool process = false;
  bool otpVerify = false;
  String? name;
  String? email;
  String? residentId;
  String? bdid;
  String? branchId;
  String? mobile_no;
  bool isVisible = false;
  int secondsRemaining=60;
  String runningtime="60";
  bool enableResend = false;
  bool afterverify = false;
  late Timer timer;
  bool otpSeen = false;
  bool resendOtpText = false;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );

  @override
  void initState() {
    fetchData();
    phoneController.clear();
    print('phone${phoneController.text}');
    isVisible = false;
    print(isVisible);
    super.initState();
  }

  resendOtp(){
    enableResend = true;
    setState(() {

    });
    secondsRemaining = 60;
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      print("::::::::");
      print(secondsRemaining);

      if (secondsRemaining != 0) {

        secondsRemaining--;


      } else {
        resendOtpText = true;
        enableResend = false;
        phoneReadonly = false;
        timer.cancel();
        otpController.text='';
        setState(() {

        });

        // secondsRemaining = _;

      }
      runningtime=secondsRemaining.toString().padLeft(2, '0');
      setState(() {

      });
    });
  }

  /*resendOtp(){
    enableResend = true;
    setState(() {

    });
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = false;

          // secondsRemaining = _;
        });
      }
    });
  }*/

  @override
  void dispose(){
    phoneController.dispose();
    super.dispose();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    residentId = await pref.getString('id');
    mobile_no = await pref.getString('mobile_no');
    branchId = await pref.getString('branchId');
    // nameController.text = await pref.getString('resident_name') ?? '';
    // phoneController.text = '';
    // emailController.text = await pref.getString('email') ?? '';
    // messageController.text = ''; // Initialize messageController


  }
  
  Future<void> openBottomSheet(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset('assets/interested/interested_page.svg'),
                const Text('Thank you for showing Interest!', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('We have shared your details with the property owner they will contact you soon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500, fontSize: 15),),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Constant.bgTile),
                    child: const Text('Close', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w500),),
                    onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Constant.bgLight, // Color for Android
      // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    return WillPopScope(
        onWillPop: () async {
      setState(() {
        isVisible = false;
      });
      return true;
    },
      child: Scaffold(
      body: NetworkObserverBlock(
        child: Stack(
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
                      'Sign up',
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
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 20,),
                          const Text('Sign up', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Constant.bgLight),),
                          const Text('Get a BTRoomer account and find your right place', style: TextStyle(color: Color(0xff6F7894), fontSize: 14),),
                          const SizedBox(height: 20,),
                          otpVerify == false ? Form(
                            key: _formKeySendOtp,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(/*horizontal: 10,*/vertical: 10),
                              child: TextFormField(
                                // initialValue: name??'',
                                onChanged: (value) {
                                  otpVerify = false;
                                  enableResend = false;
                                  isVisible = false;
                                  otpSeen = false;
                                  otpController.clear();
                                  timer.cancel();
                                  resendOtpText = false;
                                  setState(() {

                                  });
                                },
                                readOnly: otpVerify /*phoneReadonly*/,
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10), // Limit input to 6 characters
                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                ],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                  suffixIcon: otpVerify == false ?BlocListener<InterestedBloc, InterestedState>(listener: (context, state) {
                                    if(state is InterestedLoading){
                                      Center(child: const CircularProgressIndicator());
                                    }
                                    if(state is InterestedSuccess){
                                      if(state.interestedModel.success == 1){
                                        otpSeen = true;
                                        if(enableResend == false){
                                          print("<<<<>>>><<<");
                                          resendOtp();

                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.green,));
                                        phoneReadonly = true;
                                        setState(() {

                                        });
                                      }else{
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.red,));

                                      }
                                      print('InterestedBloc Success---------');

                                    }
                                    if(state is InterestedError){
                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red,));

                                      Center(child: Container(child: Text(state.error.toString()),),);
                                    }
                                  },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: InkWell(
                                            onTap: enableResend == true? null : (){
                                              if(_formKeySendOtp.currentState!.validate()){
                                                if(enableResend == false){
                                                  BlocProvider.of<InterestedBloc>(context).add(InterestedRefreshEvent('sendOTPOnMobile',
                                                      phoneController.text.toString()));
                                                }
                                                // resendOtp();

                                              }
                                            },

                                            child:
                                            Visibility(
                                              visible: !otpVerify /*phoneReadonly == true ? false : true*/,
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: enableResend == true ? Colors.grey : Constant.bgButton ,
                                                ),
                                                child: Center(
                                                    child: Text(resendOtpText ? 'Resend OTP' : 'Send OTP',
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize: 12, fontFamily: 'Product Sans'),)),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ):SizedBox(),
                                  /*Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: otpVerify ? const Icon(Icons.check, color: Colors.green,) :
                                    SvgPicture.asset('assets/interested/phone.svg'),
                                  ),*/
                                  label: const Text('Mobile Number'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty || value.length != 10){
                                    return 'Enter mobile number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ) : SizedBox(),
                          SizedBox(height: 10,),
                          otpVerify == false ? Visibility(
                            visible: enableResend,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Resend: $runningtime',style: TextStyle(color: Colors.red),),
                                )),): SizedBox(),

                          SizedBox(height: 10,),

                          // otpVerify == false ?BlocListener<InterestedBloc, InterestedState>(listener: (context, state) {
                          //   if(state is InterestedLoading){
                          //     const CircularProgressIndicator();
                          //   }
                          //   if(state is InterestedSuccess){
                          //     if(state.interestedModel.success == 1){
                          //       otpSeen = true;
                          //       if(enableResend == false){
                          //         print("<<<<>>>><<<");
                          //         resendOtp();
                          //
                          //       }
                          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.green,));
                          //       phoneReadonly = true;
                          //       setState(() {
                          //
                          //       });
                          //     }else{
                          //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.red,));
                          //
                          //     }
                          //     print('InterestedBloc Success---------');
                          //
                          //   }
                          //   if(state is InterestedError){
                          //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red,));
                          //
                          //     Center(child: Container(child: Text(state.error.toString()),),);
                          //   }
                          // },
                          //   child: Padding(
                          //       padding: const EdgeInsets.all(0.0),
                          //       child: InkWell(
                          //         onTap: enableResend == true? null : (){
                          //           if(_formKeySendOtp.currentState!.validate()){
                          //             if(enableResend == false){
                          //               BlocProvider.of<InterestedBloc>(context).add(InterestedRefreshEvent('sendOTPOnMobile',
                          //                   phoneController.text.toString()));
                          //             }
                          //             // resendOtp();
                          //
                          //           }
                          //         },
                          //
                          //         child:
                          //         Visibility(
                          //           visible: !otpVerify /*phoneReadonly == true ? false : true*/,
                          //           child: Container(
                          //             height: 50,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(30),
                          //               color: enableResend == true ? Colors.grey : Constant.bgButton ,
                          //             ),
                          //             child: Center(
                          //                 child: Text(resendOtpText ? 'Resend OTP' : 'Send OTP',
                          //                   style: TextStyle(color: Colors.white,
                          //                       fontSize: 18, fontFamily: 'Product Sans'),)),
                          //           ),
                          //         ),
                          //       )
                          //   ),
                          // ):SizedBox(),

                          otpVerify == false ?BlocBuilder<InterestedBloc, InterestedState>(builder: (context, state) {
                            if(state is InterestedLoading){
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            if(state is InterestedSuccess){
                              return Visibility(
                                  visible: phoneController.text.isNotEmpty && state.interestedModel.success == 1 ? isVisible = true : isVisible = false,
                                  child: BlocListener<InterestedBloc, InterestedState>(listener: (context, state) {
                                    if(state is InterestedLoading){
                                      const CircularProgressIndicator();
                                    }
                                    if(state is InterestedSuccess){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString())));
                                    }
                                    if(state is InterestedError){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
                                      print('error---${state.error.toString()}');
                                    }
                                  },
                                    child: Visibility(
                                      visible: otpSeen/*enableResend*//*otpVerify == true ? false : true*/,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20,),
                                            Text('Enter OTP', style: TextStyle(color: Constant.bgButton, fontSize: 16),),
                                            const SizedBox(height: 10,),
                                            /*Pinput(
                                              length: 6,
                                              controller: otpController,
                                              // focusNode: focusNode,
                                              androidSmsAutofillMethod:
                                              AndroidSmsAutofillMethod.smsUserConsentApi,
                                              listenForMultipleSmsOnAndroid: true,
                                              // defaultPinTheme: defaultPinTheme,
                                              // separatorBuilder: (index) => const SizedBox(width: 8),
                                              *//*validator: (value) {
                                            return value == null || value.isEmpty || value.length != 6 ? 'Enter OTP' : null;
                                          },*//*
                                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                                border: Border.all(color: Colors.redAccent),
                                              ),
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
                                            ),*/
                                            Pinput(
                                              length: 6,
                                              controller: otpController,
                                              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                                              listenForMultipleSmsOnAndroid: true,
                                              inputFormatters: [NumericOnlyPasteFormatter()],
                                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                                border: Border.all(color: Colors.redAccent),
                                              ),
                                              focusedPinTheme: defaultPinTheme.copyBorderWith(
                                                border: Border.all(color: Colors.blueAccent), // Change this to your desired color
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty || value.length != 6) {
                                                  return 'Please enter valid OTP';
                                                }
                                                return null;
                                              },
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                            /*TextFormField(
                                    controller: otpController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6), // Limit input to 6 characters
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                    ],
                                    decoration: InputDecoration(
                                        suffixIconConstraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                        label: const Text('OTP'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),

                                        )
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty || value.length != 6){
                                        return 'Enter OTP';
                                      }
                                      return null;
                                    },
                                  ),*/
                                            // Text('data')
                                            const SizedBox(height: 20,),
                                            InkWell(
                                              onTap: (){
                                                if(_formKey.currentState!.validate()){
                                                  API.interestedOtp('verifyOTPNumber',
                                                      phoneController.text.toString(), otpController.text).then((value) async {
                                                    if(value['success'] == 1){
                                                      isVisible = false;
                                                      otpVerify = true;
                                                      afterverify=true;
                                                      timer.cancel();
                                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                                      pref.setBool('otpVerify', otpVerify);
                                                      setState(() {
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));


                                                    }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                                    }
                                                  });
                                                  // print(state.interestedModel.details.toString());
                                                  // Navigator.pop(context);

                                                }
                                              },
                                              child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width,
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Constant.bgButton
                                                ),
                                                child: const Center(child: Text('Verify OTP', style: TextStyle(color: Colors.white,
                                                    fontSize: 18, fontFamily: 'Product Sans'),)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),)

                              );
                            }
                            return SizedBox();
                          },):SizedBox(),

                          /*const SizedBox(height: 20,),
                // Phone
                Form(
                  key: _formKeySendOtp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: TextFormField(
                      // initialValue: name??'',
                      readOnly: phoneReadonly,
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10), // Limit input to 6 characters
                        FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      ],
                      decoration: InputDecoration(
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: otpVerify ? const Icon(Icons.check, color: Colors.green,) :
                            SvgPicture.asset('assets/interested/phone.svg'),
                          ),
                          label: const Text('Mobile Number'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                          )
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty || value.length != 10){
                          return 'Enter mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                otpVerify == false ? Visibility(
                  visible: enableResend,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Resend: $runningtime',style: TextStyle(color: Colors.red),),
                      )),): SizedBox(),

                otpVerify == false ?BlocListener<InterestedBloc, InterestedState>(listener: (context, state) {
                  if(state is InterestedLoading){
                    const CircularProgressIndicator();
                  }
                  if(state is InterestedSuccess){
                    if(state.interestedModel.success == 1){
                      if(enableResend == false){
                        print("<<<<>>>><<<");
                        resendOtp();

                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.green,));
                      phoneReadonly = true;
                      setState(() {

                      });
                    }else{
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString()), backgroundColor: Colors.red,));

                    }
                    print('InterestedBloc Success---------');

                  }
                  if(state is InterestedError){
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red,));

                    Center(child: Container(child: Text(state.error.toString()),),);
                  }
                },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: enableResend == true? null : (){
                          if(_formKeySendOtp.currentState!.validate()){
                            if(enableResend == false){
                              BlocProvider.of<InterestedBloc>(context).add(InterestedRefreshEvent('sendOTPOnMobile',
                                  phoneController.text.toString()));
                            }
                            // resendOtp();

                          }
                        },

                        child:
                        Visibility(
                          visible: !otpVerify *//*phoneReadonly == true ? false : true*//*,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: enableResend == true ? Colors.grey : Constant.bgButton ,
                            ),
                            child: const Center(
                                child: Text('Send OTP',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 18, fontFamily: 'Product Sans'),)),
                          ),
                        ),
                      )
                  ),
                ):SizedBox(),

                otpVerify == false ?BlocBuilder<InterestedBloc, InterestedState>(builder: (context, state) {
                  if(state is InterestedLoading){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(state is InterestedSuccess){
                    return Visibility(
                        visible: phoneController.text.isNotEmpty && state.interestedModel.success == 1 ? isVisible = true : isVisible = false,
                        child: BlocListener<InterestedBloc, InterestedState>(listener: (context, state) {
                          if(state is InterestedLoading){
                            const CircularProgressIndicator();
                          }
                          if(state is InterestedSuccess){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.interestedModel.details.toString())));
                          }
                          if(state is InterestedError){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
                            print('error---${state.error.toString()}');
                          }
                        },
                          child: Visibility(
                            visible: enableResend*//*otpVerify == true ? false : true*//*,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller: otpController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6), // Limit input to 6 characters
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                    ],
                                    decoration: InputDecoration(
                                        suffixIconConstraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                        label: const Text('OTP'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),

                                        )
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty || value.length != 6){
                                        return 'Enter OTP';
                                      }
                                      return null;
                                    },
                                  ),
                                  // Text('data')
                                  const SizedBox(height: 20,),
                                  Form(
                                    key: _formKey,
                                    child: InkWell(
                                      onTap: (){
                                        if(_formKey.currentState!.validate()){
                                          API.interestedOtp('verifyOTPNumber',
                                              phoneController.text.toString(), otpController.text).then((value) async {
                                            if(value['success'] == 1){
                                              isVisible = false;
                                              otpVerify = true;
                                              afterverify=true;
                                              timer.cancel();
                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                              pref.setBool('otpVerify', otpVerify);
                                              setState(() {
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));


                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                            }
                                          });
                                          // print(state.interestedModel.details.toString());
                                          // Navigator.pop(context);

                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Constant.bgButton
                                        ),
                                        child: const Center(child: Text('Verify OTP', style: TextStyle(color: Colors.white,
                                            fontSize: 18, fontFamily: 'Product Sans'),)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),)

                    );
                  }
                  return SizedBox();
                },):SizedBox(),*/


                          Visibility(
                            visible: otpVerify,
                            child: Form(
                              key: nameEmailValid,
                              child: Column(
                                children: [
                                  // SizedBox(height: 10,),
                                  TextFormField(
                                    // initialValue: name??'',
                                    readOnly: true/*phoneReadonly*/ /*&& otpVerify*/,
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10), // Limit input to 6 characters
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                                      suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: otpVerify ? const Icon(Icons.check, color: Colors.green,) :
                                        SvgPicture.asset('assets/interested/phone.svg'),
                                      ),
                                      label: const Text('Mobile Number'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty || value.length != 10){
                                        return 'Enter mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10,),
                                  // Name
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: SvgPicture.asset('assets/interested/name.svg'),
                                      ),
                                      label: Text('Name'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter the name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10,),
                                  // Email
                                  TextFormField(
                                    // initialValue: email??'',
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      suffixIconConstraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: SvgPicture.asset('assets/interested/email.svg'),
                                      ),

                                      label: const Text('Email'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if(value == null || value.isEmpty){
                                    //     return 'Enter Email';
                                    //   }
                                    //   return null;
                                    // },
                                    validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",

                                  ),
                                  const SizedBox(height: 10,),
                                  // Message
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      TextFormField(
                                        controller: messageController,
                                        textAlign: TextAlign.start,
                                        textAlignVertical: TextAlignVertical.top,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          labelText: 'Remark',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                          ),
                                        ),
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return 'Enter message';
                                          }
                                          return null;
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10.0),

                                        child: SvgPicture.asset(
                                          'assets/interested/message.svg',
                                          width: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: otpVerify,
                            child: Container(
                              // decoration: const BoxDecoration(
                              //   color: Colors.white,
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.grey,
                              //       blurRadius: 1.5,
                              //     )
                              //   ],
                              // ),
                              child:
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: InkWell(
                                  onTap: () async {
                                    // Trigger the InterestedRefreshEvent
                                    if(nameEmailValid.currentState!.validate()){
                                      // BlocProvider.of<BookNowBloc>(context).add(
                                      //   BookNowRefreshEvent(
                                      //     name ?? nameController.text,
                                      //     email ?? emailController.text,
                                      //     phoneController.text,
                                      //     messageController.text,
                                      //     bdid!,
                                      //   ),
                                      // );

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
                                      API.bookNow(name ?? nameController.text, email ?? emailController.text, phoneController.text, messageController.text, branchId!).then((value) async {
                                        if(value['success'] == 1){
                                          Navigator.pop(context);
                                          // isVisible = false;
                                          // otpVerify = true;

                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          pref.setString('mobile_no', phoneController.text);
                                          pref.setString('name', nameController.text);
                                          pref.setString('email', emailController.text);
                                          // pref.setString('message', messageController.text);
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                          openBottomSheet();

                                          API.login(phoneController.text, phoneController.text,
                                              'imei_no', 'device_id',
                                              'ip_address', 'carrier_name', 'app_version',
                                              'phone_model', 'phone_manufacturer',
                                              'sdk_phone_version').then((value) async {

                                            // String onboarded = value!.tenantOnboarded.toString();
                                            // String onboarded = state.loginModel.tenantOnboarded!;
                                            String tenantId = value!.tenantId.toString();
                                            // String tenantId = state.loginModel.tenantId.toString();
                                            SharedPreferences pref = await SharedPreferences.getInstance();

                                            pref.setString('name', value.name.toString());
                                            pref.setString('mobile_no', value.mobileNo.toString());
                                            pref.setString('email_id', value.emailId.toString());
                                            pref.setString('branch_id', value.branchId.toString());
                                            pref.setString('login_id', value.loginId.toString());
                                            pref.setBool('isLoggedIn', true);
                                            pref.setString('tenantId', tenantId);
                                            print('tenantId-----${tenantId}');
                                            // pref.setString('onboarded', onboarded);
                                          });

                                          /*BlocListener<LoginBloc, LoginState>(listener: (context, state) async {
                          if(state is LoginSuccess){
                            String onboarded = state.loginModel.tenantOnboarded!;
                            String tenantId = state.loginModel.tenantId.toString();
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString('tenantId', tenantId);
                            print('tenantId-----${tenantId}');
                            pref.setString('onboarded', onboarded);
                          }
                        },
                        );*/
                                          // BlocProvider.of<LoginBloc>(context).add(LoginRefreshEvent(phoneController.text, phoneController.text,
                                          //     'imei_no', 'device_id',
                                          //     'ip_address', 'carrier_name', 'app_version',
                                          //     'phone_model', 'phone_manufacturer',
                                          //     'sdk_phone_version'));


                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
                                          // Navigator.pop(context);
                                          // Navigator.pop(context);

                                        }else{
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                        }
                                      });
                                    }


                                    // BlocListener<BookNowBloc, BookNowState>(listener: (context, state) {
                                    //   if(state is BookNowLoading){
                                    //     CircularProgressIndicator();
                                    //   }
                                    //   if(state is BookNowSuccess){
                                    //     if (state is BookNowSuccess && state.bookNowModel.success == 1) {
                                    //       // Show a success AlertDialog
                                    //       showDialog(
                                    //         context: context,
                                    //         builder: (BuildContext context) {
                                    //           return AlertDialog(
                                    //             title: Text('Success'),
                                    //             content: Text('Submission successful'),
                                    //             actions: <Widget>[
                                    //               TextButton(
                                    //                 onPressed: () {
                                    //                   Navigator.of(context).pop(); // Close the AlertDialog
                                    //                   Navigator.of(context).pop(); // Close the current screen
                                    //                 },
                                    //                 child: Text('OK'),
                                    //               ),
                                    //             ],
                                    //           );
                                    //         },
                                    //       );
                                    //     }
                                    //   }
                                    //   if(state is BookNowError){
                                    //     print(state.error);
                                    //   }
                                    // },
                                    // );



                                    // // Wait for the state to be updated
                                    // await Future.delayed(Duration.zero);
                                    //
                                    // // Get the current state
                                    // final state = BlocProvider.of<BookNowBloc>(context).state;
                                    //
                                    // // Check if the state is InterestedSuccess
                                    // if (state is BookNowSuccess && state.bookNowModel.success == 1) {
                                    //   // Show a success AlertDialog
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: Text('Success'),
                                    //         content: Text('Submission successful'),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop(); // Close the AlertDialog
                                    //               Navigator.of(context).pop(); // Close the current screen
                                    //             },
                                    //             child: Text('OK'),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Constant.bgButton,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )



                        ],
                      )

                  ),
                ),
              )
          )
          ]
        )

      ),


        // bottomNavigationBar:
        // Visibility(
        //   visible: otpVerify,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       color: Colors.white,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.grey,
        //           blurRadius: 1.5,
        //         )
        //       ],
        //     ),
        //     child:
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: InkWell(
        //         onTap: () async {
        //           // Trigger the InterestedRefreshEvent
        //           if(_formKey.currentState!.validate()){
        //             // BlocProvider.of<BookNowBloc>(context).add(
        //             //   BookNowRefreshEvent(
        //             //     name ?? nameController.text,
        //             //     email ?? emailController.text,
        //             //     phoneController.text,
        //             //     messageController.text,
        //             //     bdid!,
        //             //   ),
        //             // );
        //             showDialog(context: context, builder: (context) {
        //               process = true;
        //               setState(() {
        //
        //               });
        //               return Visibility(
        //                 visible: process == true ? true : false,
        //                 child: AlertDialog(
        //                   elevation: 0.0,
        //                   backgroundColor:Colors.transparent,
        //                   // shape: RoundedRectangleBorder(
        //                   //     borderRadius: BorderRadius.all(Radius.circular(20))),
        //                   // // contentPadding: EdgeInsets.all(24),
        //                   insetPadding: EdgeInsets.symmetric(horizontal: 155),
        //                   content: Container(
        //                       color: Colors.transparent,
        //                       height: 40,
        //                       width: 40,
        //                       child: const CircularProgressIndicator()),
        //                 ),
        //               );
        //             },);
        //             API.bookNow(name ?? nameController.text, email ?? emailController.text, phoneController.text, messageController.text, branchId!).then((value) async {
        //               if(value['success'] == 1){
        //                 // isVisible = false;
        //                 // otpVerify = true;
        //                 process = false;
        //                 setState(() {
        //                 });
        //                 SharedPreferences pref = await SharedPreferences.getInstance();
        //                 pref.setString('mobile_no', phoneController.text);
        //                 pref.setString('name', nameController.text);
        //                 pref.setString('email', emailController.text);
        //                 // pref.setString('message', messageController.text);
        //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
        //
        //                 API.login(phoneController.text, phoneController.text,
        //                     'imei_no', 'device_id',
        //                     'ip_address', 'carrier_name', 'app_version',
        //                     'phone_model', 'phone_manufacturer',
        //                     'sdk_phone_version').then((value) async {
        //
        //                   // String onboarded = value!.tenantOnboarded.toString();
        //                   // String onboarded = state.loginModel.tenantOnboarded!;
        //                   String tenantId = value!.tenantId.toString();
        //                   // String tenantId = state.loginModel.tenantId.toString();
        //                   SharedPreferences pref = await SharedPreferences.getInstance();
        //                   pref.setString('tenantId', tenantId);
        //                   print('tenantId-----${tenantId}');
        //                   // pref.setString('onboarded', onboarded);
        //                 });
        //
        //                 /*BlocListener<LoginBloc, LoginState>(listener: (context, state) async {
        //                   if(state is LoginSuccess){
        //                     String onboarded = state.loginModel.tenantOnboarded!;
        //                     String tenantId = state.loginModel.tenantId.toString();
        //                     SharedPreferences pref = await SharedPreferences.getInstance();
        //                     pref.setString('tenantId', tenantId);
        //                     print('tenantId-----${tenantId}');
        //                     pref.setString('onboarded', onboarded);
        //                   }
        //                 },
        //                 );*/
        //                 // BlocProvider.of<LoginBloc>(context).add(LoginRefreshEvent(phoneController.text, phoneController.text,
        //                 //     'imei_no', 'device_id',
        //                 //     'ip_address', 'carrier_name', 'app_version',
        //                 //     'phone_model', 'phone_manufacturer',
        //                 //     'sdk_phone_version'));
        //
        //
        //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
        //                 // Navigator.pop(context);
        //                 // Navigator.pop(context);
        //
        //               }else{
        //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
        //               }
        //             });
        //           }
        //
        //
        //           // BlocListener<BookNowBloc, BookNowState>(listener: (context, state) {
        //           //   if(state is BookNowLoading){
        //           //     CircularProgressIndicator();
        //           //   }
        //           //   if(state is BookNowSuccess){
        //           //     if (state is BookNowSuccess && state.bookNowModel.success == 1) {
        //           //       // Show a success AlertDialog
        //           //       showDialog(
        //           //         context: context,
        //           //         builder: (BuildContext context) {
        //           //           return AlertDialog(
        //           //             title: Text('Success'),
        //           //             content: Text('Submission successful'),
        //           //             actions: <Widget>[
        //           //               TextButton(
        //           //                 onPressed: () {
        //           //                   Navigator.of(context).pop(); // Close the AlertDialog
        //           //                   Navigator.of(context).pop(); // Close the current screen
        //           //                 },
        //           //                 child: Text('OK'),
        //           //               ),
        //           //             ],
        //           //           );
        //           //         },
        //           //       );
        //           //     }
        //           //   }
        //           //   if(state is BookNowError){
        //           //     print(state.error);
        //           //   }
        //           // },
        //           // );
        //
        //
        //
        //           // // Wait for the state to be updated
        //           // await Future.delayed(Duration.zero);
        //           //
        //           // // Get the current state
        //           // final state = BlocProvider.of<BookNowBloc>(context).state;
        //           //
        //           // // Check if the state is InterestedSuccess
        //           // if (state is BookNowSuccess && state.bookNowModel.success == 1) {
        //           //   // Show a success AlertDialog
        //           //   showDialog(
        //           //     context: context,
        //           //     builder: (BuildContext context) {
        //           //       return AlertDialog(
        //           //         title: Text('Success'),
        //           //         content: Text('Submission successful'),
        //           //         actions: <Widget>[
        //           //           TextButton(
        //           //             onPressed: () {
        //           //               Navigator.of(context).pop(); // Close the AlertDialog
        //           //               Navigator.of(context).pop(); // Close the current screen
        //           //             },
        //           //             child: Text('OK'),
        //           //           ),
        //           //         ],
        //           //       );
        //           //     },
        //           //   );
        //           // }
        //         },
        //         child: BottomAppBar(
        //           height: 50,
        //           color: Colors.transparent,
        //           padding: EdgeInsets.zero,
        //           surfaceTintColor: Colors.white,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Container(
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(12),
        //                   color: Constant.bgButton,
        //                 ),
        //                 child: const Center(
        //                   child: Text(
        //                     'Submit',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 18,
        //                       fontFamily: 'Poppins',
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // )

    ));

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

