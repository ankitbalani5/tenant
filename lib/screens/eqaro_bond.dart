import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:roomertenant/utils/common.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/eqarobondpdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';

class EqaroBond extends StatefulWidget {
  const EqaroBond({super.key});

  @override
  State<EqaroBond> createState() => _EqaroBondState();
}

class _EqaroBondState extends State<EqaroBond> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool animationloading = true;
  var _formKey = GlobalKey<FormState>();
  String? token;
  String? id;
  String? bondid_pdf;
  bool? status ;
  String? propertyId;
  String? eqaroOrderId;
  String? bondId;
  String? remainingEligibilityAmount;
  String? maxEligibilityAmount;
  String? message;
  String? aadhar_metadata;
  String? avatar;
  String? adhaar_no;
  String? pan_no;
  String? data_status;
  String? landlord_id;
  String? productId;
  String? branch_id;
  String? res_id;
  String? bondurl;
  String? payment_response;

  Map<String, dynamic>? aadhaar_data;
  late String currentDate;
  var bondAmount = TextEditingController();
  late Future pdfFuture;
  bool isLoading = true;
  String? not_show_pan="false";

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationloading = false;
        });
      }
    });
    _loadAnimation();
    // TODO: implement initState
    super.initState();
    fetchData();
    currentDate = getCurrentDate();


  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }




  // fetchData() async{
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   id = pref.getString('id');
  //   token = pref.getString('access_token');
  //   API.checkEligibility(token.toString(), id.toString()).then((value) {
  //     if(value.status == 'eligible'){
  //       status = true;
  //     }
  //   });
  //   setState(() {
  //
  //   });
  //
  // }

  Future<void> fetchData() async {
    // setState(() {
    //   // Set status to false to indicate that data is being fetched
    //   status = false;
    // });

    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('id');
    token = pref.getString('access_token');
    propertyId = pref.getString('propertyId');
     aadhar_metadata = pref.getString('aadhar_metadata').toString();
    avatar = pref.getString('avatar').toString();
    adhaar_no = pref.getString('adhaar_no').toString();
    pan_no = pref.getString('pan_no').toString();
    not_show_pan = pref.getString('not_show_pan').toString();
    productId = pref.getString('productId').toString();
    landlord_id = pref.getString('landlord_id').toString();
    aadhaar_data = jsonDecode(aadhar_metadata!);
     branch_id = pref.getString('branch_id').toString();
     res_id = pref.getString('tenant_id').toString();
    print( "aadhaar uid: ${aadhaar_data!['uid']}");


    setState(() {

    });
    // String? bondAmount = pref.getString('propertyId');

    // Show circular progress indicator while waiting for API response
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    API.checkEligibility(token.toString(), id.toString()).then((value) {


      if (value.status == 'eligible') {
        data_status=value.status;
        message=value.eligibility!.messageToShow.toString();
        remainingEligibilityAmount = value.eligibility!.remainingEligibilityAmount;
        maxEligibilityAmount=value.eligibility!.maxEligibilityAmount.toString();
       setState(() {
         status = true;

       });
      }else{
        data_status=value.status;
        message=value.eligibility!.messageToShow.toString();

        setState(() {

        });
      }

    }).whenComplete(() {
      // Close the circular progress indicator dialog
      Navigator.of(context).pop();

    });
    setState(() {

    });
  }

  String bond = '';


  void _loadAnimation() {
    _controller.duration = const Duration(milliseconds: 1700); // Adjust duration as needed
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: ()async{
        fetchData();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.pop(context); },
            icon: Icon(Icons.chevron_left_sharp),),
          iconTheme: IconThemeData(color: Colors.white),

            title: const Text("Check Eligibility",style: TextStyle(fontSize: 20,color: Colors.white),),
          //centerTitle: true,
          backgroundColor: Constant.bgLight,
        ),

        body:data_status.toString() == 'ineligible'
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              const Text('Sorry!', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red, fontSize: 30),),
              const SizedBox(height: 10,),
               Text('${message}.', style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 20,),
              const Text('To unlock the potential of our rental bonds, tell us:', style: TextStyle(/*color: Colors.grey*/),),
              const SizedBox(height: 20,),


              const SizedBox(height: 50,),
              InkWell(
                onTap: (){
                  fetchData();
                },
                child: Container(
                  height: 60,
                  color: Constant.bgLight,
                  child: const Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.check_circle, color: Constant.bgDark,),
                      Text('Check Eligibility', style: TextStyle(color: Colors.white),),
                    ],
                  )),
                ),
              )
            ],
          ),
        )
            :data_status.toString() == 'eligible'
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),
                // Load a Lottie file from your assets
                animationloading?Lottie.asset(
                  'assets/images/LottieLogo1.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                    setState(() {

                    });
                  },
                ):SizedBox(),
                const Text('Congratulations!', style: TextStyle(fontWeight: FontWeight.w500, color: Constant.bgLight, fontSize: 30),),
                const SizedBox(height: 10,),
                Text('${message}. Your maximum bond amount limit is ₹${maxEligibilityAmount.toString()}/-', style: TextStyle(color: Colors.grey),),
                const SizedBox(height: 20,),
                const Text('To unlock the potential of Eqaro rental bonds, tell us:', style: TextStyle(/*color: Colors.grey*/),),
                const SizedBox(height: 20,),
                Text('${message}. Remaining  Eligibility Amount: ₹${remainingEligibilityAmount.toString()}', style: TextStyle(color: Colors.grey),),

                SizedBox(height: 10,),

                GestureDetector(
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
                        Text('Your Aadhaar is Verifyed: ${adhaar_no.toString()}',style: TextStyle(color: Colors.green),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                not_show_pan == "true"? SizedBox(): Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constant.bgLight.withOpacity(0.5), width: 1)
                  ),
                  child:  Row(
                    children: [
                      Icon(Icons.verified, color: Colors.green),
                      SizedBox(width: 10,),
                      Text('Your PAN is Verifyed: ${pan_no.toString()}',style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                (int.parse(remainingEligibilityAmount.toString())>0)?
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                surfaceTintColor: Colors.white,
                                insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                title: const Center(
                                    child: Text(
                                      'Add Bond Amount',
                                      style: TextStyle(/*fontWeight: FontWeight.bold*/fontSize: 20),
                                    )),
                                content: Builder(builder: (context) {
                                  return SingleChildScrollView(
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: bondAmount,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                              errorMaxLines: 3,
                                              label: Text('Bond Amount')
                                          ),
                                          validator: (value) {


                                            if (value == null || value.isEmpty) {
                                              return 'Enter the amount';
                                            }
                                            final int enteredAmount = int.tryParse(value) ?? 0;
                                            final int maxEligibilityAmount = int.tryParse(remainingEligibilityAmount.toString()) ?? 0;
                                            if (enteredAmount <= 0) {
                                              return 'Enter a valid amount greater than 0';
                                            } else if (enteredAmount > maxEligibilityAmount) {
                                              return 'Amount should be less than or equal to the remaining Amount.';
                                            }
                                            return null;
                                          },

                                        ),
                                      )
                                  );
                                }),

                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      children: [
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
                                                if(_formKey.currentState!.validate()){
                                                  Common.showDialogLoading(context);

                                                  API.initiatePayment(token.toString(), id.toString(), propertyId.toString(),int.parse(bondAmount.text), currentDate).then((value) {

                                                    if(value['code'].toString() == "400"){
                                                      print("::::::::::::");
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      //bondAmount.clear();
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message']), backgroundColor: Colors.green,));

                                                    }else{

                                                      eqaroOrderId = value['eqaroOrderId'];
                                                      payment_response= value;

                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Initiate Successfully'), backgroundColor: Colors.green,));

                                                      Common.showDialogLoading(context);
                                                      API.paymentComplete(token.toString(), id.toString(), eqaroOrderId.toString(), currentDate).then((value) {
                                                        if(value['code'].toString() == "400"){
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message']),));
                                                        }
                                                        else{
                                                          bondId=value['bondId'];
                                                          Common.showDialogLoading(context);
                                                          /*API.eqarotrails(branch_id.toString(), res_id.toString(), landlord_id.toString(), id.toString(),bondAmount.text, currentDate,value['expiryDate'].toString(),bondId.toString(),payment_response.toString());
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Complete Successfully'), backgroundColor: Colors.green,));*/
                                                        }
                                                      });
                                                    }

                                                  });
                                                }



                                              },
                                              child: Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    color: Constant.bgLight,
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
                            });

                      },
                      child: Container(
                        height: 60,
                        color: Constant.bgLight,
                        child: const Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.check_circle, color: Constant.bgDark,),
                            Text('Initiate Payment', style: TextStyle(color: Colors.white),),
                          ],
                        )),
                      ),
                    ),
                    //const SizedBox(height: 20,),
                    /*InkWell(
                      onTap: (){
                        API.paymentComplete(token.toString(), id.toString(), eqaroOrderId.toString(), currentDate).then((value) {

                          API.eqarotrails(branch_id.toString(), res_id.toString(), landlord_id.toString(), id.toString(),bondAmount.text, currentDate,value['expiryDate'].toString());
                          if(value['code'].toString() == "400"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message']),));
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Complete Successfully'), backgroundColor: Colors.green,));
                          }
                        });
                      },
                      child: Container(
                        height: 60,
                        color: Constant.bgLight,
                        child: const Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.check_circle, color: Constant.bgDark,),
                            Text('Payment Complete', style: TextStyle(color: Colors.white),),
                          ],
                        )),
                      ),
                    ),*/
                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Common.showDialogLoading(context);

                        API.getBondByTenantId(token.toString(), id.toString(),).then((value) {

                          /*bondid_pdf=value['id'];
                          print("bondid_pdf :: ${bondid_pdf}");
                          if(value['status']=="Active"){
                            API.eqarobondpdf(branch_id.toString(), res_id.toString(), bondid_pdf.toString(), token.toString(),id.toString()).then((value) {
                              bondurl=value['data'][0];
                              Navigator.pop(context);
                              if(value['success']==1){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerScreen(filePath: "${value['data'][0]}")));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong!!'), backgroundColor: Colors.red,));
                              }
                            });
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There is No Bond Avilable!!'), backgroundColor: Colors.red,));

                          }*/


                        });
                      },
                      child: Container(
                        height: 60,
                        color: Constant.bgLight,
                        child: const Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.check_circle, color: Constant.bgDark,),
                            Text('Generate Bond PDF', style: TextStyle(color: Colors.white),),
                          ],
                        )),
                      ),
                    ),
                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){

                       /* Common.showDialogLoading(context);
                        API.eqarobondpdf(branch_id.toString(), res_id.toString(), bondid_pdf.toString(), token.toString()).then((value) {
                          Navigator.pop(context);
                          if(value['success']==1){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerScreen(filePath: "${value['data'][0]}")));
                          }else{

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong!!'), backgroundColor: Colors.red,));

                          }

                        });*/
                        print("bondid_pdf-----------  ${bondid_pdf}");
                        if(bondid_pdf!=null){
                          openFile(url: bondurl.toString(), fileName: "${bondid_pdf}");

                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('First you have to generate the Bond..'), backgroundColor: Colors.red,));

                        }



                      },
                      child: Container(
                        height: 60,
                        color: Constant.bgLight,
                        child: const Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.check_circle, color: Constant.bgDark,),
                            Text('View Bond', style: TextStyle(color: Colors.white),),
                            SizedBox(width: 10,),
                            Icon(Icons.download,color: Colors.green,)
                          ],
                        )),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ):Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 20), // Icon to draw attention
                    SizedBox(width: 10), // Spacing between icon and text
                    Expanded(
                      child: Text(
                        'Amount exceeds remaining eligibility. Please enter a valid amount.',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis, // Prevents text from overflowing
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        )
            : data_status.toString() == 'requested'
            ?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              const Text('Requested!', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red, fontSize: 30),),
              const SizedBox(height: 10,),
              Text('${message}.', style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 20,),

              const SizedBox(height: 50,),
              InkWell(
                onTap: (){
                  fetchData();
                },
                child: Container(
                  height: 60,
                  color: Constant.bgLight,
                  child: const Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.check_circle, color: Constant.bgDark,),
                      Text('Check Eligibility', style: TextStyle(color: Colors.white),),
                    ],
                  )),
                ),
              )
            ],
          ),
        )

            : /*const Center(
          child: CircularProgressIndicator(),
        ),
          */SizedBox(),
      ),
    );
  }
  Future openFile({required String url, required String? fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    print('Path : ${file.path}');
    OpenFilex.open(file.path);
  }

  Future<File?> downloadFile(String url, String? name) async {
    final appstorage = await getApplicationDocumentsDirectory();
    final file = File('${appstorage.path}/$name');
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }
}
