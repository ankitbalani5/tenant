import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:roomertenant/screens/eqaro.dart';
import 'package:roomertenant/screens/eqaro_bond.dart';
import 'package:roomertenant/screens/eqarobondpdf.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class EligibilityForm extends StatefulWidget {
  const EligibilityForm({super.key});

  @override
  State<EligibilityForm> createState() => _EligibilityFormState();
}

enum GenderValue {
  Male,
  Female,
}

GenderValue _gv = GenderValue.Male; // Initial selected value
String dropdownGenderValue = _gv.toString().split(".")[1];

class _EligibilityFormState extends State<EligibilityForm> {
  var dobController = TextEditingController();
  String? name;
  String occupation = 'Student';
  String? dob;
  String? gender ="male";
  Map<String, dynamic>? aadhaar_data;
  bool? consent= true;
  bool agree = false;
  bool otpScreen = false;
  bool havePan = true;
  bool emailVerified = false;
  bool termsDialog = true;
  bool ispanvalid = false;
  bool isadharvalid = false;
  bool ispannotedit = false;
  bool islodingvalid = false;
  bool islodingfinalsubmitvalid = false;
  String? studentgmail;
  String? eq_id;
  String? pan_no;
  String? adhaar_no;
  String? avatar;
  String? aadhar_metadata;
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var panController = TextEditingController();
  var adharController = TextEditingController();
  var incomeController = TextEditingController();
  var educationController = TextEditingController();
  var otpCode = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var emailKey = GlobalKey<FormState>();
  String? token /*= "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjBiZjUwOWZhNzE5ZDAwMjdlY2EyZTEiLCJpYXQiOjE3MTIyOTQyNTQsImV4cCI6MTcxMjQ2NzA1NCwidHlwZSI6ImFjY2VzcyJ9.pF8ArIRtJw9u4oY4VYfe-gutKGun__vDXs4ukeHYQ_o"*/;
  bool isExpanded = false;
  int regcount=1;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    checkoccupation();
  }

  void checkoccupation()async{
if(!emailVerified){
  if(occupation == 'Student' ||occupation == 'Self Employed' ){
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? studentEmailId = pref.getString('email_id');
    emailController.text = studentEmailId.toString();

  }
  else{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? studentEmailId = pref.getString('email_id');
    if(studentEmailId != null && studentEmailId.contains('@gmail.com')){
      emailController.text = "";
    }

  }
}


  }


  void fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('name');
    phoneController.text = pref.getString('mobile_no').toString();
    token = pref.getString('access_token').toString();
    var dobdata = pref.getString('dob').toString();
    if(dobdata!=null){
      DateTime inputDate = DateTime.parse(dobdata);
      dob = DateFormat('dd/MM/yyyy').format(inputDate);
    }


    gender = pref.getString('gender').toString();
    eq_id = pref.getString('id').toString();
    //pan_no = pref.getString('pan_no').toString();
    adhaar_no = pref.getString('adhaar_no').toString();
    avatar = pref.getString('avatar').toString();
    aadhar_metadata = pref.getString('aadhar_metadata').toString();

    aadhaar_data = jsonDecode(aadhar_metadata!);

    setState((){});
    print('name ----- ${name}');
    print('dob ----- ${dob}');
    print('gender ----- ${gender}');
    print('pan_no ----- ${pan_no}');
    print('aadhar_metadata ----- ${aadhar_metadata}');
    print('aadhar_name ----- ${aadhaar_data!['name']}');


    if(pan_no != null  && pan_no!= 'null' && pan_no!.isNotEmpty ){
      panController.text=pan_no.toString();
      ispanvalid=true;
      ispannotedit=true;
    }


    if(adhaar_no !=null && adhaar_no!= 'null' &&adhaar_no!.isNotEmpty){
      adharController.text=adhaar_no.toString();
      isadharvalid=true;
    }
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
                      'Check Eligibility',
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
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),

                  child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20,),
                                  Text('Hi, ${name}', style: const TextStyle(fontSize: 20, color: Constant.bgLight),),
                                  const SizedBox(height: 20,),
                                  const Text('We are almost there. Tell us about'),
                                  const SizedBox(height: 20,),
                                  Text('Your Occupation', style: TextStyle(color: Colors.grey.withOpacity(0.5)),),
                                  Column(
                                    children: [
                                      SizedBox(height: 8,),

                                      isadharvalid ?GestureDetector(
                                        onTap: (){
                                          print(':::::::::::::::::::::');

                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  child: AlertDialog(
                                                    surfaceTintColor: Colors.white,
                                                    insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                    title: const Center(
                                                        child: Text(
                                                          'Aadhaar Details',
                                                          style: TextStyle(/*fontWeight: FontWeight.bold*/fontSize: 20),
                                                        )),
                                                    content: Builder(builder: (context) {
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                         /* CircleAvatar(
                                                            radius: 50,
                                                            backgroundImage: NetworkImage(avatar.toString(),), // Add the user's photo here
                                                          ),*/
                                                          Container(
                                                            width: 80,
                                                            height: 100,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade200
                                                            ),
                                                            child: Image.network(avatar.toString(),fit: BoxFit.cover,),
                                                          ),
                                                          SizedBox(height: 20),
                                                         Column(
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: [
                                                             Text(
                                                               "UID :",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                             ),
                                                             Text(
                                                               "${aadhaar_data!['uid']}",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                                             ),
                                                             SizedBox(height: 10),
                                                             Text(
                                                               "Name :",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                             ),
                                                             Text(
                                                               "${aadhaar_data!['name']}",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                                             ),
                                                             Text(
                                                               "Address :",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                             ),
                                                             Text(
                                                      "${aadhaar_data!['address']}",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                                             ),
                                                             SizedBox(height: 10),


                                                             Text(
                                                               "DOB :",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                             ),
                                                             Text(
                                                            "${aadhaar_data!['dob']}",
                                                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                                             ),
                                                             SizedBox(height: 10),

                                                           ],
                                                         )
                                                        ],
                                                      );

                                                    }),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Constant.bgLight.withOpacity(0.5), width: 1)
                                          ),
                                          child:  Row(
                                            children: [
                                              Icon(Icons.verified, color: Colors.green),
                                              SizedBox(width: 10,),
                                              Text('your Aadhaar is Verifyed: ${adhaar_no.toString()}',style: TextStyle(color: Colors.green),)
                                            ],
                                          ),
                                        ),
                                      ):SizedBox(),
                                      SizedBox(height: 10,),

                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              occupation = 'Student';
                                              checkoccupation();
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: occupation == 'Student' ? Colors.green : Colors.black),
                                                  color: occupation == 'Student' ? Colors.green : Colors.white
                                              ),
                                              child: Center(child: Text('Student', style: TextStyle(color: occupation == 'Student'? Colors.white : Colors.black),)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              occupation = 'Salaried';
                                              checkoccupation();
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: occupation == 'Salaried' ? Colors.green : Colors.black),
                                                  color: occupation == 'Salaried' ? Colors.green : Colors.white
                                              ),
                                              child: Center(child: Text('Salaried', style: TextStyle(color: occupation == 'Salaried'? Colors.white : Colors.black),)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              occupation = 'Salaried-Yet to join';
                                              checkoccupation();


                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: occupation == 'Salaried-Yet to join' ? Colors.green : Colors.black),
                                                  color: occupation == 'Salaried-Yet to join' ? Colors.green : Colors.white
                                              ),
                                              child: Center(child: Text('Salaried-Yet to join', style: TextStyle(color: occupation == 'Salaried-Yet to join'? Colors.white : Colors.black),)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              occupation = 'Self Employed';
                                              checkoccupation();

                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: occupation == 'Self Employed' ? Colors.green : Colors.black),
                                                color: occupation == 'Self Employed' ? Colors.green : Colors.white
                                              ),
                                              child: Center(child: Text('Self Employed', style: TextStyle(color: occupation == 'Self Employed'? Colors.white : Colors.black),)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  // const Text('Phone(Linked with PAN)'),
                                  TextFormField(
                                    controller: phoneController,
                                    style: const TextStyle(color: Colors.grey),
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      label: Text('Phone(Linked with PAN)'),
                                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                      filled: true,
                                      suffixIcon: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle, size: 16, color: Colors.green,),
                                          SizedBox(width: 8,),
                                          Icon(Icons.phone, size: 16),
                                          SizedBox(width: 8,),
                                        ],
                                      )
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Form(
                                    key: emailKey,
                                    child: TextFormField(
                                      readOnly: emailVerified? true: false,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                                        filled: emailVerified? true: false,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            // Add your verification logic here
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                onPressed: (){
                                                  if(emailKey.currentState!.validate()){
                                                    otpScreen = true;
                                                    setState(() {

                                                    });
                                                    API.otpGenerationMail(token.toString()/*'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjBhNGU5OWNhMzBhZDAwMjgyMTc5ZDAiLCJpYXQiOjE3MTE5NjQwNjAsImV4cCI6MTcxMjEzNjg2MCwidHlwZSI6ImFjY2VzcyJ9.9qbFc545NtlB15iB5rUL9VE0ICvaJuaXD3CoKWtnH_Y'*/,
                                                        emailController.text.toString()).then((value) {
                                                      print('token-----${token}');
                                                      print('status-----${value.status.toString()}');
                                                    });
                                                  }

                                                },
                                                child: emailVerified == true ? const Icon(Icons.check_circle, size: 16, color: Colors.green,) : const Text(
                                                  'Verify',
                                                  style: TextStyle(color: Colors.green),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.email_outlined/*, color: Colors.blue*/, size: 16),
                                              const SizedBox(width: 8,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",

                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  // date of birth


                                  // Text("Gender"),
                                  //gender

                                 /* Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                              activeColor: Color(0xff001944),
                                              value: GenderValue.Male,
                                              groupValue: _gv,
                                              onChanged: (GenderValue? value) {
                                                setState(() {
                                                  *//*_gv = value;
                                                  dropdownGenderValue = value.toString().split(".")[1];*//*
                                                });
                                              }),
                                          const Text("Male"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              activeColor: Color(0xff001944),
                                              value: GenderValue.Female,
                                              groupValue: _gv,
                                              onChanged: (GenderValue? value) {
                                                setState(() {
                                                *//*  _gv = value;
                                                  dropdownGenderValue = value.toString().split(".")[1];*//*
                                                });
                                              }),
                                          const Text("Female"),
                                        ],
                                      )
                                    ],
                                  ),*/
                                  const SizedBox(height: 8,),
                                  otpScreen ? Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            // border: Border.all(),
                                            // borderRadius: BorderRadius.circular(12)
                                          ),
                                          child: TextFormField(
                                            controller: otpCode,
                                            maxLength: 4,


                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            decoration:  InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              hintText: 'Enter Otp',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey, width: 1.0), // Border color and width
                                                borderRadius: BorderRadius.circular(8.0), // Border radius
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      InkWell(
                                        onTap: (){
                                          API.emailVerifyApi(token.toString()/*'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjBhNGU5OWNhMzBhZDAwMjgyMTc5ZDAiLCJpYXQiOjE3MTE5NjQwNjAsImV4cCI6MTcxMjEzNjg2MCwidHlwZSI6ImFjY2VzcyJ9.9qbFc545NtlB15iB5rUL9VE0ICvaJuaXD3CoKWtnH_Y'*/,
                                              emailController.text.toString(), otpCode.text.toString()).then((value) {
                                                if(value.status == 'approved'){
                                                  emailVerified = true;
                                                  otpCode.clear();
                                                  print('email verified-----');
                                                  setState(() {

                                                  });
                                                }else{
                                                  otpCode.clear();
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email is not verified'), backgroundColor: Colors.red,));
                                                }
                                          });
                                          otpScreen = false;
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Constant.bgLight,
                                            borderRadius: BorderRadius.circular(12),
                                            // border: Border.all(color: Colors.black)
                                          ),
                                          child: const Center(child: Text('OK', style: TextStyle(color: Colors.white),)),
                                        ),
                                      )
                                    ],
                                  ) : const SizedBox(),

                                  //const SizedBox(height:10,),

                                  /*occupation == 'Student' ? Column(
                                    children: [
                                      const SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: havePan,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            onChanged: (value) {
                                              havePan = !havePan;
                                              setState(() {

                                              });
                                            },),
                                          const Text('I have a PAN')
                                        ],
                                      ),
                                      // const SizedBox(height: 8,),
                                    ],
                                  ) : const SizedBox.shrink(),
                                  !havePan
                                      ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Please Enter Details of your guardian', style: TextStyle(fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          label: Text('Email')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Name')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Phone')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('DOB')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Relation')
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      const Text('Document', style: TextStyle(fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Doc Type')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Doc Id')
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      const Text('Employment Details', style: TextStyle(fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Company Name')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Work Email')
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            label: Text('Monthly Income')
                                        ),
                                      ),

                                    ],
                                  ) : const SizedBox.shrink(),*/



                                  // isadharvalid ?GestureDetector(
                                  //   onTap: (){
                                  //     print(':::::::::::::::::::::');
                                  //
                                  //     showDialog<String>(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return Padding(
                                  //             padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //             child: AlertDialog(
                                  //               surfaceTintColor: Colors.white,
                                  //               insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  //               title: const Center(
                                  //                   child: Text(
                                  //                     'Aadhaar Details',
                                  //                     style: TextStyle(/*fontWeight: FontWeight.bold*/fontSize: 20),
                                  //                   )),
                                  //               content: Builder(builder: (context) {
                                  //                 return SingleChildScrollView(
                                  //                   child: SizedBox(
                                  //                       width: MediaQuery.of(context).size.width,
                                  //                       child: const Column(
                                  //                           mainAxisSize: MainAxisSize.min,
                                  //                           children: [
                                  //                             CircularProgressIndicator(), // Loading indicator
                                  //                             SizedBox(height: 20),
                                  //                             Text('Loading...'),
                                  //                           ]
                                  //                       )),
                                  //                 );
                                  //               }),
                                  //             ),
                                  //           );
                                  //         });
                                  //   },
                                  //     child: ListTile(
                                  //
                                  //       title: Text('Aadhaar ID',style: TextStyle(fontSize: 14),),
                                  //       subtitle: Text(adhaar_no.toString()),
                                  //       trailing: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.end,
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           Icon(Icons.check_circle, size: 16, color: Colors.green,),
                                  //           SizedBox(width: 8,),
                                  //           Icon(Icons.file_open_outlined, size: 16),
                                  //           SizedBox(width: 8,),
                                  //         ],
                                  //       ),
                                  //
                                  //     /*TextFormField(
                                  //         controller: adharController,
                                  //         style: TextStyle(color:Colors.grey),
                                  //
                                  //         readOnly: true,
                                  //         textCapitalization: TextCapitalization.characters,
                                  //         maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  //         // maxLengthEnforcement: true,
                                  //         autovalidateMode:AutovalidateMode.onUserInteraction,
                                  //
                                  //         decoration:  const InputDecoration(
                                  //             filled: true,
                                  //             label: Text('Aadhaar ID'),
                                  //             labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                  //             counterText: '',
                                  //             suffixIcon: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.end,
                                  //               mainAxisSize: MainAxisSize.min,
                                  //               children: [
                                  //                  Icon(Icons.check_circle, size: 16, color: Colors.green,),
                                  //                 SizedBox(width: 8,),
                                  //                 Icon(Icons.file_open_outlined, size: 16),
                                  //                 SizedBox(width: 8,),
                                  //               ],
                                  //             )
                                  //         ),
                                  //
                                  //     ),*/
                                  //   ),
                                  // ):SizedBox(),
                                   //const SizedBox(height: 8,),
                                  TextFormField(
                                    controller: panController,
                                    style: TextStyle(color: ispannotedit?Colors.grey:Colors.black,),
                                    maxLength: 10,
                                    readOnly: ispanvalid?true:false,
                                    textCapitalization: TextCapitalization.characters,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    // maxLengthEnforcement: true,
                                    autovalidateMode:AutovalidateMode.onUserInteraction,

                                    decoration:  InputDecoration(
                                      filled: ispanvalid?true:false,

                                        label: Text('PAN'),
                                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                      counterText: '',
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          // Add your verification logic here
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ispanvalid == true ? const Icon(Icons.check_circle, size: 16, color: Colors.green,) :TextButton(
                                              onPressed: (){
                                                if(PanNumberValidator.isValidPanNumber(panController.text)){
                                                  print(":::::::::::::Pan card api:::::::::::");
                                                  API.panvalidate(token.toString(), panController.text).then((value) {
                                                    if(value['status']=='Pan card valid'){

                                                      Fluttertoast.showToast(
                                                        msg: "${value['status']}",
                                                        toastLength: Toast.LENGTH_LONG,
                                                        timeInSecForIosWeb: 8,
                                                        backgroundColor: Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 13.0,
                                                      );
                                                      ispanvalid=true;
                                                      setState(() {

                                                      });


                                                    }else{
                                                      Fluttertoast.showToast(
                                                        msg: "${value['status']}",
                                                        toastLength: Toast.LENGTH_LONG,
                                                        timeInSecForIosWeb: 8,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 13.0,
                                                      );
                                                      ispanvalid=false;
                                                      setState(() {

                                                      });
                                                    }
                                                  });
                                                }else{
                                                  Fluttertoast.showToast(
                                                    msg: "Pan card is not valid!",
                                                    toastLength: Toast.LENGTH_LONG,
                                                    timeInSecForIosWeb: 8,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 13.0,
                                                  );
                                                }


                                              },
                                              child:  const Text(
                                                'Verify',
                                                style: TextStyle(color: Colors.green),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.document_scanner_outlined, color: Colors.blue, size: 16),
                                            const SizedBox(width: 8,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if(occupation == 'Student' && value!.isEmpty){
                                        return null;
                                      }else{
                                        if (value!.isEmpty) {
                                          return 'Please enter PAN number';
                                        } else if (!PanNumberValidator.isValidPanNumber(value)) {
                                          return 'Invalid PAN number';
                                        }
                                        /*else if(PanNumberValidator.isValidPanNumber(value)){

                                          API.panvalidate(token.toString(), value.toString()).then((value) {
                                            if(value['status']=='Pan card not valid'){

                                              Fluttertoast.showToast(
                                                msg: "${value['status']}",
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 8,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 13.0,
                                              );
                                              return 'Pan card not valid';
                                            }else{
                                              Fluttertoast.showToast(
                                                msg: "Pan card valid",
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 8,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 13.0,
                                              );
                                              return null ;
                                            }
                                          });
                                        }*/
                                        return null;
                                      };
                                      }

                                  ),
                                  ( gender ==null ||gender!.isEmpty  ) ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height:10,),

                                      const Text("Gender",style: TextStyle(fontSize: 12),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  activeColor: Color(0xff001944),
                                                  value: GenderValue.Male,
                                                  groupValue: _gv,
                                                  onChanged: (GenderValue? value) {
                                                    setState(() {
                                                      _gv = value!;
                                                      dropdownGenderValue = value.toString().split(".")[1];
                                                    });
                                                  }),
                                              const Text("Male"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  activeColor: Color(0xff001944),
                                                  value: GenderValue.Female,
                                                  groupValue: _gv,
                                                  onChanged: (GenderValue? value) {
                                                    setState(() {
                                                      _gv = value!;
                                                      dropdownGenderValue = value.toString().split(".")[1];
                                                    });
                                                  }),
                                              const Text("Female"),
                                            ],
                                          )
                                          ]
                                      ),
                                    ],
                                  )
                                      :SizedBox(),


                                  ( dob ==null ||dob!.isEmpty ) ?TextFormField(
                                    controller: dobController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      suffixIcon: Image.asset("assets/eqaro/calendar_month.png"),
                                      label: Text('Date Of Birth'),
                                      labelStyle: const TextStyle(
                                        color: Color(0xff6F7894),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900), // Adjust according to your application's requirements
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                                      }
                                    },
                                  )
                                      :SizedBox(),
                                  const SizedBox(height: 8,),



                                  occupation == 'Student'
                                  ? TextFormField(
                                    controller: educationController,
                                    textCapitalization: TextCapitalization.words,
                                    decoration: const InputDecoration(
                                      label: Text('University or Educational Institute Name'),
                                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                      suffixIcon: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.school_outlined, size: 16),
                                          SizedBox(width: 8,),
                                        ],
                                      )
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter University or Educational Institute Name';
                                      }
                                      return null;
                                    },
                                  ) :
                                  TextFormField(
                                    controller: incomeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        label: Text('Monthly Gross Income'),
                                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter Income';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: agree,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (value) {
                                        agree = !agree;
                                        setState(() {
                                          
                                        });
                                      },),

                                       Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child:
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: isExpanded?const  Text(
                                                      'I hereby declare that all the information given by me above'
                                                          ' is true to the best of my knowledge. I agree to immediately indemnify'
                                                          ' Eqaro for any claims or amounts paid out by Eqaro to my landlord as the'
                                                          ' result of a claim on the Rental Guarantee issued on my behalf. '
                                                          ' Eqaro reserves the right to report to credit bureaus of any default on my part towards'
                                                          ' the indemnity.',
                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    ):const Text(
                                                      'I hereby declare that all the information given by me above'
                                                          ' is true to the best...',

                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    )
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isExpanded = !isExpanded;
                                                      });
                                                    },
                                                    child: Text(
                                                      isExpanded ? 'Show Less' : 'Read More',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),


                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20,),

                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: (){
                                        print(":::::::::");
                                        if(agree){
                                          if(occupation != 'Student'  && ispanvalid == false){
                                            Fluttertoast.showToast(
                                              msg: "verify your PAN No.",
                                              toastLength: Toast.LENGTH_LONG,
                                              timeInSecForIosWeb: 8,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 13.0,
                                            );
                                          }
                                          // if(ispanvalid != true){
                                          //   Fluttertoast.showToast(
                                          //     msg: "verify your PAN No.",
                                          //     toastLength: Toast.LENGTH_LONG,
                                          //     timeInSecForIosWeb: 8,
                                          //     backgroundColor: Colors.red,
                                          //     textColor: Colors.white,
                                          //     fontSize: 13.0,
                                          //   );
                                          // }
                                          if(emailVerified != true){
                                            Fluttertoast.showToast(
                                              msg: "verify your email Id. ",
                                              toastLength: Toast.LENGTH_LONG,
                                              timeInSecForIosWeb: 8,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 13.0,
                                            );
                                          }
                                          if(_formKey.currentState!.validate() && emailKey.currentState!.validate() && emailVerified == true && ispanvalid == true){
                                            print('Validate');
                                            islodingvalid=true;
                                            setState((){

                                            });
                                            API.docuplodeeqro(token.toString(),panController.text.toString() ).then((value) {
                                              islodingvalid=false;
                                              setState((){

                                              });
                                              showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (context,setState) {
                                                          return AlertDialog(
                                                            surfaceTintColor: Colors.white,
                                                            insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                            title: const Center(
                                                                child: Text(
                                                                  'Disclamer',
                                                                  style: TextStyle(fontWeight:FontWeight.bold),
                                                                )),
                                                            content: Builder(builder: (context) {
                                                              return SingleChildScrollView(
                                                                child: SizedBox(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    child:  Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text('I ${name.toString()} hereby declare and certify that all the information and details provided in this Application are true, correct and complete and that no material facts have been mis-stated or omitted. I agree that if the information and details provided in this application changes between the date of this application and the date that Eqaro Surety Private Limited (Eqaro) issues a Rental Guarantee on my behalf, I will, in order for the information to remain accurate, immediately notify Eqaro of such changes, if any. Eqaro may choose to withdraw or modify any quotation or renewal quotation, before the binding of the Rental Guarantee. I agree that the information and details provided in this Application shall form the basis of the Rental Guarantee being issued on my behalf and that the Rental Guarantee will come into force only upon receipt of the full Guarantee Fee by Eqaro. In case any of the above information is found to be false or untrue or misleading or misrepresenting, I am aware that I may be held liable for it. I authorise Eqaro & its employees, directors, shareholders, associates partners and entities, organization and person acting on its behalf (collectively referred to as Eqaro Representatives and Partners) to verify information and details provided in this Application and to obtain or provide information from or to any source, including but not limited to obtaining credit information/reports, track record of previous lease arrangements/Rental Guarantee (wherever applicable) or other relevant data/information, for the processing of this application for a Rental Guarantee, or claims thereunder, if any. I further agree that the issuance of a Rental Guarantee or any renewal thereof shall be at Eqaro’s sole discretion. I confirm that I am a citizen of India. I hereby confirm that no insolvency proceedings have been instituted against me nor have I ever been adjudicated bankrupt. I also confirm that no demand or litigation has been filed or is pending against me for recovery of any amount from me'
                                                                            ' by any bank, financial institution, Non-Banking Financial Corporation or any other entity. '
                                                                            'I hereby agree and give consent for the disclosure by Eqaro of all or any information and / or data'
                                                                            ' relating to me; the information and default, if any, committed by me in the discharge of my obligations,'
                                                                            ' as Eqaro may deem appropriate and/or required to report to any statutory or regulatory body/entity, '
                                                                            'in terms of the applicable laws, I have perused Eqaro’s general terms & conditions and the Privacy Policy '
                                                                            'available in the website www.eqaroguarantees.com and hereby confirm the acceptance and continual adherence thereof. '
                                                                            'I agree to provide Eqaro such further documents as may be required by them from time to time to comply with the Know Your'
                                                                            'Customer (KYC) requirements. My KYC details may be shared with the Central KYC Registry. I hereby consent to receiving information from Central KYC Registry or such other statutory/regulatory bodies through SMS / Email on the above registered number / email address. I hereby provide'
                                                                            'my consent for validating my Aadhaar number from the concerned authorities. Additionally, I hereby release BTRoomer Services LLP from any liability that may or may not result from Eqaro disclosing users'
                                                                            'information to any person, entity, statutory authority, or other representative of Eqaro. Through the application, BTRoomer Services LLP offers Eqaro to Service Providers, PG Owners, Operators, and Tenants as "an optional" service; any agreements or transactions between these users are entirely their own responsibility. '
                                                                            'Any disagreement, liability, or financial loss will only affect Eqaro & its users and BTRoomer LLP will not be held accountable.'
                                                                          ,),
                                                                        Text("BTRoomer Services LLP and Eqaro are separate legal entities. While they may collaborate or interact in certain capacities, "
                                                                            "each entity operates independently. BTRoomer Services LLP and Eqaro hereby disclaim any responsibility or accountability for the actions, policies, data security, or recovery processes of the other entity. Any issues or concerns arising from the activities of either BTRoomer Services LLP or Eqaro should be addressed directly to the respective entity involved. "
                                                                            "This disclaimer extends to all interactions, transactions, and engagements involving BTRoomer Services LLP and Eqaro.")

                                                                      ],
                                                                    )),
                                                              );
                                                            }),
                                                            actions: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 8),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [
                                                                        Checkbox(
                                                                          value: termsDialog,
                                                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                          onChanged: (value) {
                                                                            termsDialog = !termsDialog;
                                                                            print(termsDialog);
                                                                            setState(() {

                                                                            });
                                                                          },),
                                                                        const Text('I accept all the terms and conditions', style: TextStyle(fontSize: 10),),
                                                                        const SizedBox(width: 10,),

                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 80,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(),
                                                                                borderRadius: BorderRadius.circular(12)
                                                                            ),
                                                                            child: Center(child: Text('Cancel')),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 10,),
                                                                        InkWell(
                                                                          onTap: () async{
                                                                            if(termsDialog){


                                                                              showDialog<String>(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                      child: AlertDialog(
                                                                                        surfaceTintColor: Colors.white,
                                                                                        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                                                        title: const Center(
                                                                                            child: Text(
                                                                                              'Loading..',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),
                                                                                            )),
                                                                                        content: Builder(builder: (context) {
                                                                                          return SingleChildScrollView(
                                                                                            child: SizedBox(
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                child: const Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                    CircularProgressIndicator(), // Loading indicator
                                                                                                SizedBox(height: 20),
                                                                                                Text('Loading...'),
                                                                                              ]
                                                                                                )),
                                                                                          );
                                                                                        }),
                                                                                      ),
                                                                                    );
                                                                                  });



                                                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                                                               eq_id = pref.getString('id').toString();
                                                                              setState((){

                                                                              });
                                                                              print('id----${eq_id}');
                                                                               if(occupation == 'Student'){

                                                                                }else {

                                                                               }
                                                                              //print(dobController.text);

                                                                              API.updateUser(token.toString(), name!.toString(), phoneController.text,
                                                                                  dob.toString(), gender.toString(), occupation, incomeController.text.isNotEmpty ? double.parse(incomeController.text) : 0, occupation != 'Student'?emailController.text:"", eq_id.toString()).then((value) {

                                                                                    if(value == "200"){
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                                                                        return Eqaro();
                                                                                      }));
                                                                                    }else if(value=="403"){
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                                                                        return Eqaro();
                                                                                      }));
                                                                                    }else{

                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                    }

                                                                              });
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 80,
                                                                            decoration: BoxDecoration(
                                                                                color:termsDialog? Constant.bgLight : Colors.grey,
                                                                                borderRadius: BorderRadius.circular(12)
                                                                            ),
                                                                            child: Center(child: Text('Accept', style: TextStyle(color: Colors.white),)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                    );
                                                  });
                                            });

                                          }else{
                                            print('Invalidate');

                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        color: agree ? Constant.bgLight : Colors.grey,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Center(child: Text('CHECK ELIGIBILITY', style: TextStyle(color: Colors.white),)),
                                            SizedBox(width:10),
                                            islodingvalid?Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: CircularProgressIndicator(color: Colors.white,),
                                            ):SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,)
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );

  }
}
class PanNumberValidator {
  static final RegExp _panRegex =
  RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  static bool isValidPanNumber(String value) {
    return _panRegex.hasMatch(value);
  }
}