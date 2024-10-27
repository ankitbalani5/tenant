import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/logout_otp_tenant_bloc/logout_otp_tenant_bloc.dart';
import 'package:roomertenant/screens/no_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../utils/common.dart';
import 'internet_check.dart';

class OtpLoginProfile extends StatefulWidget {
  const OtpLoginProfile({super.key});

  @override
  State<OtpLoginProfile> createState() => _OtpLoginProfileState();
}

class _OtpLoginProfileState extends State<OtpLoginProfile> {
  var _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? mobile_no;
  String? loginId;
  bool passwordVisible = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    /*nameController.text*/name = pref.getString('name');
    /*emailController.text*/email = pref.getString('email_id')=="null" || pref.getString('email_id')==""? '' : pref.getString('email_id');
    /*mobileController.text*/mobile_no = pref.getString('mobile_no');
    loginId = pref.getString('login_id');
    print('name${name}');
    print('mobile${mobile_no}');
    print('loginId${loginId}');
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Constant.bgLight, // Color for Android
      // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    return Scaffold(
      // backgroundColor: Constant.bgLight,
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
                        'Profile',
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
                  borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child:
                              Image.asset(
                                'assets/images/man.png',
                                color: Colors.black,
                                fit: BoxFit.fill,
                              )
                          ),
                          const SizedBox(height: 5,),
                          Text(/*nameController.text*/name??'', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Product Sans', color: Constant.bgText),),
                          const SizedBox(height: 5,),
                          Text(/*emailController.text*/email??'', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'Product Sans', color: Color(0xff6F7894)),),
                          Text(/*mobileController.text*/mobile_no??'', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'Product Sans', color: Color(0xff6F7894)), ),
                          const SizedBox(height: 20,),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade200),

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Change Password', style: const TextStyle(color: Constant.bgLight, fontWeight: FontWeight.w500),),
                            InkWell(
                                onTap: (){
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: AlertDialog(
                                            surfaceTintColor: Colors.white,
                                            insetPadding: EdgeInsets.symmetric(horizontal: 10),
                                            title: const Center(
                                                child: Text(
                                                  "Edit Password",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      color: Constant.bgLight
                                                  ),
                                                ),),
                                            content: Container(
                                              height: 220,
                                              width: MediaQuery.of(context).size.width * 0.8, // Set your desired width
                                              padding: const EdgeInsets.all(16),
                                              child: Form(
                                                key: _formKey,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(height: 10,),
                                                      TextFormField(
                                                        controller: passwordController,
                                                        decoration: InputDecoration(
                                                            label: Text('New Password'),
                                                            labelStyle: TextStyle(fontSize: 14),
                                                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                                                            suffixIconConstraints: const BoxConstraints(
                                                              minWidth: 40,
                                                              minHeight: 40,
                                                            ),

                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(30),
                                                                borderSide: BorderSide(color: Colors.grey.shade200)

                                                            )
                                                        ),
                                                        validator: (value) {
                                                          if(value == null || value.isEmpty){
                                                            return 'Enter password';
                                                          }
                                                          return null;
                                                        },
                                                      ),

                                                      const SizedBox(height: 20,),

                                                      TextFormField(
                                                        controller: confirmPasswordController,
                                                        decoration: InputDecoration(
                                                            label: Text('Confirm Password'),
                                                            labelStyle: TextStyle(fontSize: 14),
                                                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                                                            suffixIconConstraints: const BoxConstraints(
                                                              minWidth: 40,
                                                              minHeight: 40,
                                                            ),

                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(30),
                                                                borderSide: BorderSide(color: Colors.grey.shade200)
                                                            )
                                                        ),
                                                        validator: (value) {
                                                          if(value == null || value.isEmpty){
                                                            return 'Enter confirm password';
                                                          }else if(value != passwordController.text){
                                                            return "New and Confirm password doesn't match";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      const SizedBox(height: 20,),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            actions: [

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: InkWell(
                                                      onTap: (){
                                                        passwordController.clear();
                                                        confirmPasswordController.clear();
                                                        Navigator.pop(context);
                                                        },
                                                      child: Center(
                                                        child: Container(
                                                          width: 120, // Reduced width for the button
                                                          height: 40, // Reduced height for the button
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(30),
                                                            color: Constant.bgButton,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 10), // Adjust this padding to reduce the height
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          API.changePassword(loginId.toString(), passwordController.text).then((value) {
                                                            if (value['success'] == 1) {
                                                              passwordVisible = false;
                                                              setState(() {});
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(value['details']),
                                                                  backgroundColor: Colors.green,
                                                                ),
                                                              );
                                                              passwordController.clear();
                                                              confirmPasswordController.clear();
                                                              Navigator.pop(context);
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(value['details']),
                                                                  backgroundColor: Colors.red,
                                                                ),
                                                              );
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Center(
                                                        child: Container(
                                                          width: 120, // Reduced width for the button
                                                          height: 40, // Reduced height for the button
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(30),
                                                            color: Constant.bgButton,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Submit',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            /*actions: [
                                              InkWell(
                                                onTap: (){
                                                  if(_formKey.currentState!.validate()){
                                                    API.changePassword(loginId.toString(), passwordController.text).then((value) {
                                                      if(value['success'] == 1){
                                                        passwordVisible = false;
                                                        // isVisible = false;
                                                        // otpVerify = true;
                                                        setState(() {
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                                        passwordController.clear();
                                                        confirmPasswordController.clear();
                                                        Navigator.pop(context);


                                                      }else{
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Center(
                                                  child: Container(
                                                    width: 200,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: Constant.bgButton
                                                    ),
                                                    child: const Center(child: Text('Submit', style: TextStyle(color: Colors.white),)),
                                                  ),
                                                ),
                                              ),
                                            ],*/
                                          ),
                                        );
                                      });
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return AlertDialog(
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(20),
                                  //       ),
                                  //       content: Container(
                                  //         height: 220,
                                  //         width: MediaQuery.of(context).size.width * 0.8, // Set your desired width
                                  //         padding: const EdgeInsets.all(16),
                                  //         child: Form(
                                  //           key: _formKey,
                                  //           child: SingleChildScrollView(
                                  //             child: Column(
                                  //               mainAxisSize: MainAxisSize.min,
                                  //               children: [
                                  //                 Center(
                                  //                   child: Text(
                                  //                     "Edit Password",
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                       fontWeight: FontWeight.w700,
                                  //                       color: Constant.bgLight
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 const SizedBox(height: 30,),
                                  //                 TextFormField(
                                  //                   controller: passwordController,
                                  //                   decoration: InputDecoration(
                                  //                     label: Text('New Password'),
                                  //                       labelStyle: TextStyle(fontSize: 12),
                                  //                       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  //
                                  //                       suffixIconConstraints: const BoxConstraints(
                                  //                         minWidth: 40,
                                  //                         minHeight: 40,
                                  //                       ),
                                  //
                                  //                       border: OutlineInputBorder(
                                  //                         borderRadius: BorderRadius.circular(30),
                                  //                           borderSide: BorderSide(color: Colors.grey.shade200)
                                  //
                                  //                       )
                                  //                   ),
                                  //                   validator: (value) {
                                  //                     if(value == null || value.isEmpty){
                                  //                       return 'Enter password';
                                  //                     }
                                  //                     return null;
                                  //                   },
                                  //                 ),
                                  //
                                  //                 const SizedBox(height: 20,),
                                  //
                                  //                 TextFormField(
                                  //                   controller: confirmPasswordController,
                                  //                   decoration: InputDecoration(
                                  //                     label: Text('Confirm Password'),
                                  //                       labelStyle: TextStyle(fontSize: 12),
                                  //                       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  //
                                  //                       suffixIconConstraints: const BoxConstraints(
                                  //                         minWidth: 40,
                                  //                         minHeight: 40,
                                  //                       ),
                                  //
                                  //                       border: OutlineInputBorder(
                                  //                         borderRadius: BorderRadius.circular(30),
                                  //                         borderSide: BorderSide(color: Colors.grey.shade200)
                                  //                       )
                                  //                   ),
                                  //                   validator: (value) {
                                  //                     if(value == null || value.isEmpty || value != passwordController.text){
                                  //                       return 'Enter confirm password';
                                  //                     }
                                  //                     return null;
                                  //                   },
                                  //                 ),
                                  //                 const SizedBox(height: 20,),
                                  //
                                  //
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       actions: [
                                  //         InkWell(
                                  //           onTap: (){
                                  //             if(_formKey.currentState!.validate()){
                                  //               API.changePassword(loginId.toString(), passwordController.text).then((value) {
                                  //                 if(value['success'] == 1){
                                  //                   passwordVisible = false;
                                  //                   // isVisible = false;
                                  //                   // otpVerify = true;
                                  //                   setState(() {
                                  //                   });
                                  //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                  //                   passwordController.clear();
                                  //                   confirmPasswordController.clear();
                                  //                   Navigator.pop(context);
                                  //
                                  //
                                  //                 }else{
                                  //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                  //                 }
                                  //               });
                                  //             }
                                  //           },
                                  //           child: Center(
                                  //             child: Container(
                                  //               width: 200,
                                  //               height: 50,
                                  //               decoration: BoxDecoration(
                                  //                   borderRadius: BorderRadius.circular(30),
                                  //                   color: Constant.bgButton
                                  //               ),
                                  //               child: const Center(child: Text('Submit', style: TextStyle(color: Colors.white),)),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // );


                                },
                                child: Icon(Icons.edit_note_sharp, color: Constant.bgLight,))
                          ],
                        ),

                      ),


                      const SizedBox(height: 10,),

                      // Theme(
                      //   data: Theme.of(context).copyWith(
                      //     dividerColor: Colors.transparent, // Set divider color to transparent
                      //   ),
                      //   child: ExpansionTile(
                      //     title: const Text('Change Password'),
                      //     children: [
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           const Padding(
                      //             padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                      //             child: Text('password', style: TextStyle(color: Colors.grey),),
                      //           ),
                      //           SizedBox(
                      //             height: 50,
                      //             child: TextFormField(
                      //               controller: passwordController,
                      //               decoration: InputDecoration(
                      //                   suffixIconConstraints: const BoxConstraints(
                      //                     minWidth: 40,
                      //                     minHeight: 40,
                      //                   ),
                      //
                      //                   border: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(12),
                      //
                      //                   )
                      //               ),
                      //               validator: (value) {
                      //                 if(value == null || value.isEmpty){
                      //                   return 'Enter password';
                      //                 }
                      //                 return null;
                      //               },
                      //             ),
                      //           ),
                      //           const SizedBox(height: 10,),
                      //           const Padding(
                      //             padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                      //             child: Text('Confirm Password', style: TextStyle(color: Colors.grey),),
                      //           ),
                      //           SizedBox(
                      //             height: 50,
                      //             child: TextFormField(
                      //               controller: confirmPasswordController,
                      //               decoration: InputDecoration(
                      //                   suffixIconConstraints: const BoxConstraints(
                      //                     minWidth: 40,
                      //                     minHeight: 40,
                      //                   ),
                      //
                      //                   border: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(12),
                      //
                      //                   )
                      //               ),
                      //               validator: (value) {
                      //                 if(value == null || value.isEmpty || value != passwordController.text){
                      //                   return 'Enter confirm password';
                      //                 }
                      //                 return null;
                      //               },
                      //             ),
                      //           ),
                      //           const SizedBox(height: 40,),
                      //           InkWell(
                      //             onTap: (){
                      //               if(_formKey.currentState!.validate()){
                      //                 API.changePassword(loginId.toString(), passwordController.text).then((value) {
                      //                   if(value['success'] == 1){
                      //                     passwordVisible = false;
                      //                     // isVisible = false;
                      //                     // otpVerify = true;
                      //                     setState(() {
                      //                     });
                      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                      //                     passwordController.clear();
                      //                     confirmPasswordController.clear();
                      //                     Navigator.pop(context);
                      //
                      //
                      //                   }else{
                      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                      //                   }
                      //                 });
                      //               }
                      //             },
                      //             child: Center(
                      //               child: Container(
                      //                 width: 200,
                      //                 height: 60,
                      //                 decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.circular(12),
                      //                     color: Constant.bgLight
                      //                 ),
                      //                 child: const Center(child: Text('Change Password', style: TextStyle(color: Colors.white),)),
                      //               ),
                      //             ),
                      //           ),
                      //           // ElevatedButton(onPressed: (){}, child: Text('change Password'))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 40,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: showLogoutDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Constant.bgButton
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: const Center(child: Text('Logout', style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),)
          ],
        ),
      )

    );
  }

  showLogoutDialog(){
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                // insetPadding:
                // const EdgeInsets.symmetric(
                //     horizontal: 10),
                // title: const Text(
                //   "Are you sure ?",
                //   style: TextStyle(
                //       fontWeight: FontWeight.normal, fontSize: 16),
                // ),
                title: Text('Logout!', style: TextStyle(color: Colors.red),),
                content: Text('Are you sure'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("No",
                          style: TextStyle(
                              color: Colors.red))),
                  BlocListener<LogoutOtpTenantBloc, LogoutOtpTenantState>(listener: (context, state) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(state is LogoutOtpTenantLoading){
                      Common.showDialogLoading(context);
                    }
                    if(state is LogoutOtpTenantSuccess){
                      if(state.logoutOtpTenantModel.success == 1) {
                        prefs.clear();
                        setState(() {
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.logoutOtpTenantModel.details.toString()), backgroundColor: Colors.green,));
                        Navigator.pushNamedAndRemoveUntil(context, NoLogin.id, (route) => false);

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.logoutOtpTenantModel.details.toString()), backgroundColor: Colors.red,));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
                    if(state is LogoutOtpTenantError){
                      print("Error "+state.error
                      );
                      Common.toastWarning(context, state.error);
                      Common.hideDialogLoading(context);
                    }
                  },
                    child: TextButton(
                      onPressed: () async {
                        BlocProvider.of<LogoutOtpTenantBloc>(context).add(LogoutOtpTenantRefreshEvent(loginId.toString()));

                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.red),
                      ),
                    ),
                  )

                ],
              );
            }));
  }
}
