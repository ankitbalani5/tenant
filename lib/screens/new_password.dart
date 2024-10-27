import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomertenant/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  var confirmPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  bool PasswordView = true;
  bool confirmPasswordView = true;
  var _formKey = GlobalKey<FormState>();
  String? tenant_id;

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    tenant_id = pref.getString('tenant_id');
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
                        'Create New Password',
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
                                  child: Text('Your new password must be different from previously used password'),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  obscureText: PasswordView,
                                  // initialValue: email??'',
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    suffixIconConstraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        PasswordView = !PasswordView;
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Icon(PasswordView ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined)/*SvgPicture.asset('assets/interested/email.svg')*/,
                                      ),
                                    ),

                                    label: const Text('New Password'),
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
                                      return 'Enter New Password';
                                    }
                                    return null;
                                  },
                                  // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",

                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  obscureText: confirmPasswordView,
                                  // initialValue: email??'',
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    suffixIconConstraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        confirmPasswordView = !confirmPasswordView;
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Icon(confirmPasswordView ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined)/*SvgPicture.asset('assets/interested/email.svg')*/,
                                      ),
                                    ),

                                    label: const Text('Confirm Password'),
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
                                    if(value == null || value.isEmpty || value != passwordController.text){
                                      return 'Password Mismatch';
                                    }
                                    return null;
                                  },

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
                                        child: const CircularProgressIndicator(color: Constant.bgText)),
                                  );
                                },);

                                API.changePassword(tenant_id.toString(), passwordController.text)
                                    .then((value) {
                                  if (value['success'] == 1) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details'].toString())));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details'].toString())));
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
                                child: Center(child: Text('Submit', style: TextStyle(color: Colors.white)))),
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
