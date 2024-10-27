import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomertenant/api/apitget.dart';

import 'package:flutter/material.dart';
import 'package:roomertenant/model/user_model.dart';
import 'package:roomertenant/screens/login_bloc/login_bloc.dart';
import 'package:roomertenant/screens/no_login.dart';
import 'package:roomertenant/screens/register.dart';
import 'package:roomertenant/utils/common.dart';
import 'package:roomertenant/widgets/navBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:validators/validators.dart';

import '../constant/constant.dart';
import 'forgot_password.dart';
import 'internet_check.dart';
import 'newhome.dart';


class Login extends StatefulWidget {
  static const String id = "login";
  static String mail = "test@test.com";
  static String password = "test1234";
  static bool valid = false;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisibal = false;
  var obscuretext = true;
  String? mobile_no;
  String? branch_id;
  String? loginId;
  PackageInfo? _packageInfo;
  AndroidDeviceInfo? androidInfo;
  NetworkInfo? networkInfo;
  var _identifier="";
  var model;
  var manufacturer;
  var sdkInt;
  var netInfo;
  var wifiIP;
  var carrierInfo;
  String? token;
  String? versionCode;
  // var carrierNameAndroid;
  // var carrierNameIos;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
    _initPackageInfo();
    initUniqueIdentifierState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Ask for permissions before requesting data
    await [
      Permission.locationWhenInUse,
    ].request();

    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   // if (Platform.isAndroid) carrierNameAndroid = await CarrierInfo.getAndroidInfo();
    //   carrierNameAndroid = await CarrierInfo.getAndroidInfo().then((value) {return value!.telephonyInfo[0].carrierName.toString();});
    //   if (carrierNameAndroid != null) {
    //     print("Carrier Name (Android): $carrierNameAndroid");
    //   } else {
    //     print("Unable to retrieve carrier name (Android).");
    //   }
    //   if (Platform.isIOS) carrierNameIos = await CarrierInfo.getIosInfo().then((value) {return value.carrierData[0].carrierName.toString();});
    //   // print('Android carrier: ${carrierNameAndroid['tel']}');
    //   print('Ios carrier: ${carrierNameIos}');
    // } catch (e) {
    //   print(e.toString());
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    // netInfo = await NetworkInfo().getWifiIP();
    // final info = NetworkInfo();
    wifiIP = await Ipify.ipv4();
    print('Ip Address: ${wifiIP}');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      sdkInt = androidInfo.version.sdkInt;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }
    setState(() {
      _packageInfo = info;
      networkInfo = netInfo as NetworkInfo?;
      // version = _packageInfo?.version;
      // versionCode = _packageInfo?.buildNumber;
    });
  }

  String? validateEmailMobile(String value) {
    if (isEmail(value)) {
      return null; // Valid email
    } else if (isNumeric(value) && value.length == 10) {
      return null; // Valid mobile number
    } else {
      return 'Enter a valid email or mobile number';
    }
  }

  // var loginContext;

  String get response => "";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Constant.bgLight, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      /*appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Constant.bgLight,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),*/
          body: NetworkObserverBlock(
            child: Stack(
              children: [
                Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 150,
                          color: Constant.bgLight,
                        ),
                ),
                Positioned(
                          top: 80,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
                    const Text('Into your BTRoomer account:', style: TextStyle(color: Color(0xff6F7894), fontSize: 14),),
                    const SizedBox(height: 40,),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email or Mobile number',
                        hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 16, fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.person_outline_sharp,color: Color(0xFF2D2F79),),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            width: 1,color: Color(0xFF2D2F79),
                          ),
                        ),
                      ),
                      validator: (value) => validateEmailMobile(value!),
                      /*validator: (value) {
                        if( value == null || value.isEmpty ){
                          return 'Enter Email or Mobile no';
                        }
                        return null;
                      },*/
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: obscuretext,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xff6F7894), fontSize: 16, fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.lock_outline_sharp, color: Color(0xFF2D2F79),),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscuretext = !obscuretext;
                              });
                            },
                            child: obscuretext
                                ? const Icon(Icons.visibility_off, color: Color(0xffB9C0D2))
                                : const Icon(Icons.visibility, color: Color(0xffB9C0D2))),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            width: 1,color: Color(0xFF2D2F79),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                            },
                            child: Text('Forgot Password?', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w500),))
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BlocListener<LoginBloc, LoginState>(
                      listener: (ctx, state) async {
                        // loginContext = context;
                        if (state is LoginLoading) {
                          Common.showDialogLoading(context);
                          FocusScope.of(context).unfocus();
                        }
                        if (state is LoginSuccess) {
                          print("Success ");
                          Common.hideDialogLoading(context);
                          if (state.loginModel.details != null && state.loginModel.success == 1) {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('tenant_id', state.loginModel.tenantId.toString());
                            mobile_no = prefs.setString('mobile_no', state.loginModel.mobileNo.toString()).toString();
                            prefs.setString('name', state.loginModel.name.toString());
                            prefs.setString('email_id', state.loginModel.emailId.toString());
                            branch_id = prefs.setString('branch_id', state.loginModel.branchId.toString()).toString();
                            loginId = prefs.setString('login_id', state.loginModel.loginId.toString()).toString();

                            print('tenant_id-----${prefs.getString('tenant_id').toString()}');
                            print('login_id-----${prefs.getString('login_id').toString()}');
                            print('mobile_no-----${prefs.getString('mobile_no').toString()}');
                            print('name-----${prefs.getString('name').toString()}');
                            print('email_id-----${prefs.getString('email_id').toString()}');
                            print('branch_id-----${prefs.getString('branch_id').toString()}');

                            print('mobile-------${mobile_no}');
                            print('branch-------${branch_id}');

                            if(state.loginModel.branchId! == '0'){

                              // UserModel userModel = await API.user(mobile_no.toString(),
                              // branch_id.toString());
                              prefs.setBool('isLoggedIn', true);
                              Navigator.of(context).pushNamedAndRemoveUntil(NoLogin.id, (Route<dynamic> route) => false);
                              Common.toastWarning(context, state.loginModel.details!,
                                  backgroundcolor: Colors.green, textcolor: Colors.white);
                            }else{
                              // API.userdatalist.clear();
                              // UserModel userModel = await API.user(mobile_no.toString(), branch_id.toString());
                              prefs.setBool('isLoggedIn', true);
                              Navigator.of(context).pushNamedAndRemoveUntil(NavBar.id, (Route<dynamic> route) => false);
                              Common.toastWarning(context, state.loginModel.details!,
                                  backgroundcolor: Colors.green, textcolor: Colors.white);
                            }


                            // API.userdatalist.clear();
                            //
                            // prefs.setString("email", _emailController.text.toString());
                            // prefs.setString("username", _emailController.text.toString());
                            // prefs.setString("password", _passwordController.text.toString());
                            // String branch_id = await prefs.getString("branch_id").toString();
                            // // String branch_id = await prefs.getString("branch_id").toString();
                            // print("loginbranch_id : ${branch_id}");
                            // print("email : ${prefs.getString("email").toString()}");
                            // UserModel userModel = await API.user(prefs.getString("email").toString(),branch_id);
                            //
                            // prefs.setString('id', userModel.residents![0].tenantId.toString());
                            // prefs.setBool('isLoggedIn', true);
                            // Navigator.of(context).pushNamedAndRemoveUntil(NavBar.id, (Route<dynamic> route) => false);
                            // Common.toastWarning(context, state.loginModel.details!,
                            //     backgroundcolor: Colors.green, textcolor: Colors.white);
                          } else {
                            Common.toastWarning(context, 'Either Email or password is wrong');
                          }
                        }
                        if (state is LoginError) {
                          print("Error "+state.errorMsg
                          );
                          Common.toastWarning(context, state.errorMsg);
                          Common.hideDialogLoading(context);

                        }
                      },
                      child:  Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.94,
                            height: 50,
                            child: ElevatedButton(style:ElevatedButton.styleFrom(
                              backgroundColor: Constant.bgBtnDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),// Background color
                            ),
                                onPressed: () async {
                              if(_formKey.currentState!.validate()){

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                token = prefs.getString('token').toString();
                                print('token------------------------------------$token');
                                BlocProvider.of<LoginBloc>(context).add(LoginRefreshEvent(
                                    _emailController.text,  _passwordController.text,
                                    /*'imei_no'*/_identifier,
                                    /*prefs.getString('token').toString()*/token.toString(),
                                    wifiIP??'', '',
                                    _packageInfo!.version,
                                    model.toString(),
                                    manufacturer.toString(),
                                    sdkInt.toString()));
                                print('email: $_emailController');
                                print('password: ${_passwordController.text}');
                                print('identifier: $_identifier');
                                print('token: $token');
                                print('wifiIP: $wifiIP');
                                // print('carrierNameAndroid: $carrierNameAndroid');
                                print('version: ${_packageInfo!.version}');
                                print('model: $model');
                                print('manufacturer: $manufacturer');
                                print('sdkInt: $sdkInt');
                              }
                                },
                                // carrier name means airtel, vodafon, jio sim name
                                child:const Text("Login",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 16,fontWeight: FontWeight.w700),))),
                      ),

                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don’t have an account?",
                              style: TextStyle(color: Color(0xffB9C0D2), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(text: '  ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            TextSpan(
                              text: 'Register Now',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Color(0xff312F8B)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                                  // Single tapped.
                                },
                            ),
                          ],
                        ),
                      ),
                    ),



                  ],
                ),
              ),
            ),
                          )),
                Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(child: Text('v.${_packageInfo?.version??''}(${_packageInfo?.buildNumber??''})', style: const TextStyle(
              fontSize: 16, color: Color(0xff6F7894),
              fontWeight: FontWeight.w500),))
                )
              ],
            ),
          ),
        );
  }

  void setUserData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    versionCode = prefs.getString('version');
    String? token = await FirebaseMessaging.instance.getToken();
    prefs.setString('token', token.toString());
    if(prefs.getBool("credentialSave")??false){
      isChecked=true;
      setState(() {

      });
      print("UserData  Email : ${prefs.getString("username").toString()} Password : ${prefs.getString("password").toString()}");
      _emailController.text=prefs.getString("username").toString();
      _passwordController.text=prefs.getString("password").toString();
    }else{
      isChecked=false;

      _emailController.text="";
      _passwordController.text="";
      setState(() {

      });
    }
  }

  void setIsRemember(bool isChecked) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setBool('credentialSave', true);

    } else {
      prefs.setBool('credentialSave', false);
    }
  }



  void getiOSDeviceIdentifier() async{
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    var data = await deviceInfoPlugin.iosInfo;

    _identifier = data.identifierForVendor!;
  }
}
