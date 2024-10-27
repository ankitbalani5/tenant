import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roomertenant/screens/verify_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var mobileController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool mobileView = true;

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
                        'Forgot Password',
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
                                const SizedBox(height: 20,),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Enter your mobile number to reset your password'),
                                ),
                                const SizedBox(height: 20,),
                                TextFormField(
                                  // initialValue: email??'',
                                  controller: mobileController,
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
                                    // suffixIcon: InkWell(
                                    //   onTap: (){
                                    //     mobileView = !mobileView;
                                    //     setState(() {
                                    //
                                    //     });
                                    //   },
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    //     child: Icon(mobileView ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined)/*SvgPicture.asset('assets/interested/email.svg')*/,
                                    //   ),
                                    // ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    label: const Text('Mobile no.'),
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
                                      return 'Enter Mobile no.';
                                    }
                                    return null;
                                  },
                                  // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",

                                ),

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
                                        child: const CircularProgressIndicator(color: Constant.bgText,)),
                                  );
                                },);

                                API.forgotPassword(mobileController.text).then((value) async {
                                  if(value.success == 1){
                                    Navigator.pop(context);
                                    SharedPreferences pref = await SharedPreferences.getInstance();

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.details.toString()), backgroundColor: Colors.green));
                                    pref.setString('tenant_id', value.data!.tenantId.toString());
                                    pref.setString('mobile_no', value.data!.contact.toString());
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmail()));
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.details.toString()), backgroundColor: Colors.green));
                                  }
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Constant.bgButton,
                              ),
                              // padding: EdgeInsets.all(30),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(child: Text('Submit', style: TextStyle(color: Colors.white),))),
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
