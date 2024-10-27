import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roomertenant/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';
import 'internet_check.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool? isCurrentPassword;
  bool? isNewPassword;
  bool? isConfirmPassword;
  String? loginId;
  var _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // userProfile();
    isCurrentPassword = false;
    isNewPassword = false;
    isConfirmPassword = false;
    super.initState();
    fetchData();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    loginId = pref.getString('login_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Change Password',
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
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
                    child: Column(
                      children: [
                        /*Row(
                          children: [
                            Text('Change Password'),
                            Spacer(),
                          ],
                        ),*/
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //Current Password TextField
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 50,
                              //   child: TextFormField(
                              //     controller: currentPasswordController,
                              //     keyboardType: TextInputType.visiblePassword,
                              //     obscureText: !isCurrentPassword!,
                              //     decoration: InputDecoration(
                              //         fillColor: Colors.grey,
                              //         suffixIcon: IconButton(
                              //           onPressed: () {
                              //             setState(() {
                              //               isCurrentPassword =
                              //               !isCurrentPassword!;
                              //             });
                              //           },
                              //           icon: isCurrentPassword!
                              //               ? const Icon(
                              //             Icons.visibility_outlined,
                              //             color: Colors.grey,
                              //           )
                              //               : const Icon(
                              //             Icons.visibility_off_outlined,
                              //             color: Colors.grey,
                              //           ),
                              //         ),
                              //         labelText: "Current Password",
                              //         labelStyle:
                              //         const TextStyle(color: Colors.grey),
                              //         focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //             BorderRadius.circular(30),
                              //             borderSide: const BorderSide(
                              //                 color: Colors.black, width: 2)),
                              //         enabledBorder: OutlineInputBorder(
                              //             borderRadius:
                              //             BorderRadius.circular(30),
                              //             borderSide: BorderSide(
                              //                 color: Colors.grey.withOpacity(0.5), width: 1))),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              //New Password TextField
                              TextFormField(
                                controller: newPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !isNewPassword!,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isNewPassword = !isNewPassword!;
                                        });
                                      },
                                      icon: isNewPassword!
                                          ? const Icon(
                                        Icons.visibility_outlined,
                                        color: Colors.grey,
                                      )
                                          : const Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    labelText: "New Password",
                                    labelStyle:
                                    const TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.5), width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.5), width: 1))),
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return 'Please enter new Password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //Confirm Password TextField
                              TextFormField(
                                controller: confirmPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !isConfirmPassword!,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isConfirmPassword =
                                          !isConfirmPassword!;
                                        });
                                      },
                                      icon: isConfirmPassword!
                                          ? const Icon(
                                        Icons.visibility_outlined,
                                        color: Colors.grey,
                                      )
                                          : const Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    labelText: "Confirm Password",
                                    labelStyle:
                                    const TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.5), width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.5), width: 1))),
                                validator: (value) {
                                  if(value == null || value.isEmpty || value != newPasswordController.text){
                                    return 'Password Mismatch';
                                  }
                                  return null;
                                },
                              ),

                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                              child: SizedBox(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if(_formKey.currentState!.validate()){
                                        SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        String branch_id = await prefs
                                            .getString("branch_id")
                                            .toString();
                                        String user_id = await prefs
                                            .getString("tenant_id")
                                            .toString();

                                        print("Current Password: " +
                                            currentPasswordController.text);
                                        print("New Password: " +
                                            newPasswordController.text);
                                        print("Confirm Password: " +
                                            confirmPasswordController.text);
                                        /*if (currentPasswordController
                                            .text.isEmpty &&
                                            newPasswordController.text.isEmpty &&
                                            confirmPasswordController
                                                .text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                              "Please type the password to change");
                                        } else if (newPasswordController
                                            .text.isEmpty &&
                                            confirmPasswordController
                                                .text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                              "Please type new and confirm password to change");
                                        } else if (confirmPasswordController.text
                                            .toString() !=
                                            newPasswordController.text
                                                .toString()) {
                                          Fluttertoast.showToast(
                                              msg:
                                              "Confirm password not match with new password");
                                        } else {*/
                                          /*API.changePasswordApi(context, branch_id, user_id, currentPasswordController.text, newPasswordController.text)*/
                                          API.changePassword(loginId.toString(), newPasswordController.text)
                                              .then((value) {
                                            if (value['success'] == 1) {
                                              Fluttertoast.showToast(
                                                  msg: value['details']);
                                              newPasswordController.clear();
                                              confirmPasswordController.clear();
                                              prefs.clear();
                                              setState(() {
                                              });
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                                              // Navigator.pop(context);
                                              // Navigator.pop(context);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: value['details']);
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                      // }

                                    }, child: Text('Submit', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Product Sans'),),
                                    style: ElevatedButton.styleFrom(backgroundColor: Constant.bgTile),
                                  )
                              ),
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     //Submit Button of Change Password
                        //     SizedBox(
                        //       width: 140,
                        //       height: 35,
                        //       child: ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               primary: const Color(0xff001944),
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                   BorderRadius.circular(20))),
                        //           onPressed: () async {
                        //             SharedPreferences prefs =
                        //             await SharedPreferences.getInstance();
                        //             String branch_id = await prefs
                        //                 .getString("branch_id")
                        //                 .toString();
                        //             String user_id = await prefs
                        //                 .getString("id")
                        //                 .toString();
                        //
                        //             print("Current Password: " +
                        //                 currentPasswordController.text);
                        //             print("New Password: " +
                        //                 newPasswordController.text);
                        //             print("Confirm Password: " +
                        //                 confirmPasswordController.text);
                        //             if (currentPasswordController
                        //                 .text.isEmpty &&
                        //                 newPasswordController.text.isEmpty &&
                        //                 confirmPasswordController
                        //                     .text.isEmpty) {
                        //               Fluttertoast.showToast(
                        //                   msg:
                        //                   "Please type the password to change");
                        //             } else if (newPasswordController
                        //                 .text.isEmpty &&
                        //                 confirmPasswordController
                        //                     .text.isEmpty) {
                        //               Fluttertoast.showToast(
                        //                   msg:
                        //                   "Please type new and confirm password to change");
                        //             } else if (confirmPasswordController.text
                        //                 .toString() !=
                        //                 newPasswordController.text
                        //                     .toString()) {
                        //               Fluttertoast.showToast(
                        //                   msg:
                        //                   "Confirm password not match with new password");
                        //             } else {
                        //               API
                        //                   .changePasswordApi(
                        //                   context,
                        //                   branch_id,
                        //                   user_id,
                        //                   currentPasswordController.text,
                        //                   newPasswordController.text)
                        //                   .then((value) {
                        //                 if (value['success'] == '1') {
                        //                   Fluttertoast.showToast(
                        //                       msg: value['details']);
                        //                   Navigator.pop(context);
                        //                   Navigator.pop(context);
                        //                 } else {
                        //                   Fluttertoast.showToast(
                        //                       msg: value['details']);
                        //                 }
                        //               });
                        //             }
                        //           },
                        //           child: const Text(
                        //             "Submit",
                        //             style: TextStyle(color: Colors.white),
                        //           )),
                        //     ),
                        //
                        //     //Cancel Button of Change Password
                        //     SizedBox(
                        //       width: 140,
                        //       height: 35,
                        //       child: ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               primary: const Color(0xff001944),
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                   BorderRadius.circular(20))),
                        //           onPressed: () => Navigator.pop(context),
                        //           child: const Text(
                        //             "Cancel",
                        //             style: TextStyle(color: Colors.white),
                        //           )),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
