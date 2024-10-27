import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/notification_model.dart';
import 'package:roomertenant/notificationservice/local_notification_service.dart';
import 'package:roomertenant/screens/accomodationscreen.dart';
import 'package:roomertenant/screens/bill_bloc/bill_bloc.dart';
import 'package:roomertenant/screens/complain_bloc/complain_bloc.dart';
import 'package:roomertenant/screens/home_bloc/home_bloc.dart';
import 'package:roomertenant/screens/next_due_date.dart';
import 'package:roomertenant/screens/notifcation.dart';
import 'package:roomertenant/screens/update_receipt_payment/update_receipt_payment_bloc.dart';
import 'package:roomertenant/screens/update_receipts_payment.dart';
import 'package:roomertenant/screens/userprofile.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/screens/bill.dart';

import 'package:roomertenant/widgets/appbartitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../utils/common.dart';
import 'clearNotificationBloc/clear_notification_bloc.dart';
import 'eqaro.dart';
import 'internet_check.dart';
import 'notificationList/notification_list_bloc.dart';
import 'tenant_complain.dart';
import 'package:badges/badges.dart' as badges;


class NewHomeApp extends StatefulWidget {
  const NewHomeApp({Key? key}) : super(key: key);
  static const String id = 'NewHomeApp';
  static dynamic userValues;
  static dynamic userId;
  static dynamic userBills;
  static dynamic userComplains;
  static dynamic complainHead;
  static dynamic userImage;
  static String? finalusernumber;

  static getValidationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? obtainEmail = prefs.getString('email');

    finalusernumber = obtainEmail!;
    return finalusernumber;
  }

  @override
  _NewHomeAppState createState() => _NewHomeAppState();
}

class _NewHomeAppState extends State<NewHomeApp> {
  bool process = false;
  var _identifier="";
  // String? receiptNo;
  TextEditingController receiptNo = TextEditingController();
  TextEditingController pending = TextEditingController();
  String? paymentId;
  TextEditingController dateinput = TextEditingController();
  TextEditingController receivedAmtController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  List<bool>? statusList = [];
  var selectMode = 'Cash';
  bool? isSuccess;
  String? name;
  String? email;
  String? mobile_no;
  // DateTime? mindueDate;

  getData() async{

    BlocListener<NotificationListBloc, NotificationListState>(listener: (context, state) {
      if(state is NotificationListSuccess){

        List<NotificationData>? list = state.notificationModel.data;

        if (list != null) {
          for (var item in list) {
            if (item.status == 'Read') {
              statusList?.add(true);
            } else {
              statusList?.add(false);
            }
          }
        }
      }
    },);
    setState(() {

    });
  }

  fetchPgId(String pgId) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('pg_id', pgId);
  }

  getDateInformate(String date) {
    var value = date.split('-');
    String formatedDate = '${value[0]} ${value[1]} ${value[2].substring(2, 4)}';
    return formatedDate;
  }

  List<String> paymentMode = ['Cash', 'Paytm', 'PhonePe', 'Google Pay', 'Online/IMPS', 'UPI', 'Cheque', 'Wallet'];
  String selectedPayMode="Cash";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _showOtpSheet = false;


  // If some error occur during payment this will trigger
  void onError(CFErrorResponse errorResponse, String orderId) {
    // printing the error message so that we can show
    // it to user or checkourselves for testing
    isSuccess = false;
    setState(() {});
    print(errorResponse.getMessage());
    print("Error while making payment");
    Fluttertoast.showToast(
        msg: errorResponse.getMessage().toString(),
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14.0,
        timeInSecForIosWeb:12,
        backgroundColor: Colors.red
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min size to wrap content
              children: [
                Icon(Icons.cancel_rounded, color: Colors.red, size: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text(
                    errorResponse.getMessage().toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6151FF),
                    padding: EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void verifyPayment(String orderId) async{
    // Here we will only print the statement
    // to check payment is done or not
    isSuccess = true;
    setState(() {});
    print("Verify Payment $orderId");
    Map<String, String> headers = {
      'accept': 'application/json',
      'x-api-version': '2023-08-01',
      'x-client-id': 'TEST10209706acea64e1b0e2d441ac2f60790201',
      'x-client-secret': 'cfsk_ma_test_03c3bdfa45cbb73b69594106f1ec61d2_82d77b20'
    };
    final result = await http.get(Uri.parse('https://sandbox.cashfree.com/pg/orders/${orderId}'),
        headers: headers);
    if(result.statusCode == 200){
      final responseResult = jsonDecode(result.body);
      print('responseResult---${responseResult}');
      return responseResult;
    }else{

    }

    Fluttertoast.showToast(
        msg: orderId,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14.0,
        timeInSecForIosWeb:12,
        backgroundColor: Colors.green
    );
  }

  @override
  void initState() {
    String nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateinput.text = nowDate;
    notificationPayment();
    // Attach events when payment is success and when error occured
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    _storedImage;
    _storedImage1;
    // TODO: implement initState
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method


    // receivedAmtController.addListener(() {
    //   setState(() {
    //     if (receivedAmtController.text.toString() != "") {
    //       if (double.parse(receivedAmtController.text.toString()) > 99) {
    //         receivedAmtController.text = "";
    //       }
    //     }
    //     });
    //
    // });


    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) async {
            // _showModalBottomSheet();
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final residentId = prefs.getString('tenant_id').toString();
        NotificationModel paymentPending = await API.notificationList(residentId.toString());
        setState(() {
          notificationData = paymentPending.data;
          // unreadnotificationList = paymentPending.data!.unread;
          // readnotificationList = paymentPending.data!.read;
        });

        BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(residentId));
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }

      },
    );

    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'otp') {
        _showOtpBottomSheet();
      } else if (message.data['type'] == 'confirm') {
        _closeOtpBottomSheet();
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   callAllApi().then((value) => setState(() {}));
  // }

  Future callAllApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final residentId = prefs.getString('tenant_id');
    final userId = prefs.getString('id');
    String branch_id = await prefs.getString("branch_id").toString();
    String mobile_no = await prefs.getString("mobile_no").toString();
    String tenant_id = await prefs.getString("tenant_id").toString();
    BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent(prefs.getString('mobile_no').toString(),branch_id));
    BlocProvider.of<BillBloc>(context).add(BillRefreshEvent('gatResidentPaymentData', branch_id.toString(), tenant_id.toString(), '2023-01-01', dateinput.text.toString()));

    NotificationModel paymentPending = await API.notificationList(residentId.toString());
    setState(() {
      notificationData = paymentPending.data;
    });


    // BlocProvider.of<BillBloc>(context).add(BillRefreshEvent(userId.toString()));
    BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(tenant_id.toString()));
    // //first api
    // NewHomeApp.userBills = await API.bill(userId);
    NewHomeApp.userValues = await API.user(mobile_no,branch_id);
    // // second api
    // NewHomeApp.userComplains = await API.complains(tenant_id);
    // // third api
    // NewHomeApp.userComplains = await API.complains(tenant_id);
    setState(() {

    });
  }

  void _showOtpBottomSheet() {
    setState(() {
      _showOtpSheet = true;
    });
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 300,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Enter OTP'),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'OTP',
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

  void _closeOtpBottomSheet() {
    if (_showOtpSheet) {
      Navigator.pop(context);
      setState(() {
        _showOtpSheet = false;
      });
    }
  }



  void editFunction()async{
    setState(() {
      NewHomeApp.userValues = null;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email');
    String branch_id = await prefs.getString("branch_id").toString();
    String mobile_no = await prefs.getString("mobile_no").toString();
    final userId = prefs.getString('id');
    print('mobile-------${mobile_no}');
    print('branch-------${branch_id}');

    // NewHomeApp.userBills = await API.bill(userId);
    NewHomeApp.userValues = await API.user(mobile_no,branch_id);


    // notificationPayment();
    setState(() {
      print("Homebranch_id${branch_id}");
    });
  }


  // List<Unread>? unreadnotificationList;
  // List<ReadData>? readnotificationList;
  List<NotificationData>? notificationData;
  notificationPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final residentId = prefs.getString('tenant_id');

    pending.text = prefs.getString('pending')??'';
    print('pending amount--------${pending.text.toString()}');


    print('residentId......................${residentId}');
    String branch_id = await prefs.getString("branch_id").toString();
    mobile_no = await prefs.getString("mobile_no").toString();
    name = await prefs.getString("name").toString();
    email = await prefs.getString("email_id").toString();

    String tenant_id = await prefs.getString("tenant_id").toString();

    print('branch_id------${branch_id}');

    final userId = prefs.getString('id');
    print('userId..............${userId}');
    NewHomeApp.userValues = await API.user(mobile_no.toString(),branch_id);
    // if (!(prefs.getString('email') == null)) {
    //   NewHomeApp.userValues =
    //   await API.user(prefs.getString('email').toString(), branch_id);
    // }
    BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent(prefs.getString('mobile_no').toString(),branch_id));
    BlocProvider.of<BillBloc>(context).add(BillRefreshEvent('gatResidentPaymentData', branch_id.toString(), tenant_id.toString(), '2023-01-01', dateinput.text.toString()));

    // BlocProvider.of<BillBloc>(context).add(BillRefreshEvent(userId.toString()));
    BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(tenant_id.toString()));

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // var tenant_id = pref.getString('tenant_id').toString();
    BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
    NotificationModel paymentPending = await API.notificationList(residentId.toString());
    setState(() {
      notificationData = paymentPending.data;
      getData();
      if (notificationData != null) {
        for (var item in notificationData!) {
          if (item.status == 'Read') {
            statusList?.add(true);
          } else {
            statusList?.add(false);
          }
        }
      }
      // unreadnotificationList = paymentPending.data!.unread;
      // readnotificationList = paymentPending.data!.read;
    });
  }

  Future<void> saveReceiptNumber(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('receiptNo', value);
    prefs.setString('pending', value);
    prefs.setString('paymentId', value);
  }



  saveName(String name, String email_id) async{

    print("::::::::::::::::::::::::::::::::");
    print(email_id);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('name', name);
    pref.setString('email_id', email_id);
    print('student_email_id ${pref.getString('email_id')}');
  }

  void _showModalBottomSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
          enableDrag: true,
          showDragHandle: true,
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24)
              )
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("OTP for payment confirmation",style: TextStyle(color: Color(0xff312F8B),fontWeight: FontWeight.w400,fontSize: 14),),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("2265",
                      style: TextStyle(letterSpacing: 8,color: Color(0xff312F8B),fontWeight: FontWeight.w700,fontSize: 24),),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "2265")).then((value) {
                            Fluttertoast.showToast(msg: "OTP Copyed..");
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                              color: Color(0xff6151FF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xff6151FF))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                color: Color(0xff6151FF),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text('Copy',
                                    style: TextStyle(color: Color(0xff6151FF), fontWeight: FontWeight.w700, fontFamily: 'Product Sans', fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launch(
                              "https://wa.me/?text=Your Otp: 2265 "
                                  "\nComplain Date: 18-5-2024"
                                  "\nRemark: Thank You For Payment"
                          );
                        },
                        child: Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                              color: const Color(0xff6151FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xff6151FF))),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/whatsapp.svg'),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text('WhatsApp',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Product Sans', fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),


                ],
              )
          ),
        );
      },
      );
      });
    }
  CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();

  String orderId = "my_order_id_test${Random().nextInt(100) + 50}";

  Future<CFSession?> createSession(String amount) async {
    try {
      final mySessionIDData = await createSessionID(orderId, amount, name.toString(), email.toString(), mobile_no.toString()); // This will create session id from flutter itself
      // Now we will se some parameter like orderID ,environment,payment sessionID
      // after that we wil create the checkout session
      // which will launch through which user can pay.
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(mySessionIDData["order_id"])
          .setPaymentSessionId(mySessionIDData["payment_session_id"])
          .build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Constant.bgLight, // Color for Android
      // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    return Scaffold(
      body:  NetworkObserverBlock(
        child: RefreshIndicator(
          onRefresh: callAllApi,
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if(state is HomeLoading){
              print('LoadingSuccess');

              return Container(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator()),
                ),
              );
            }
            if(state is HomeSuccess){
              final imageUrl = state.userModel.residents![0].image;
              print('abcd...................');
              saveName(state.userModel.residents![0].residentName!, state.userModel.residents![0].email.toString());
              fetchPgId(state.userModel.residents![0].pgId.toString());

              // print('HomeSuccess');
              return Container(
                // color: Color(0xfff3f2f7),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [

                    // User Name Section
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        // alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.height * 0.38,
                          decoration: const BoxDecoration(
                            color: Constant.bgLight,
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              Apptitle(),
                            ],
                          )
                      ),
                    ),

                    // user icon and notification
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.025,
                      top: MediaQuery.of(context).size.height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          notificationData!=null
                              ?  GestureDetector(
                            onTap: () async {

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => NotificationPage(statusList ),
                                    // settings:RouteSettings(arguments:unreadnotificationList,),
                                  ));
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => NotificationPage(readnotificationList!),
                              //       settings:RouteSettings(arguments:unreadnotificationList,),
                              //     ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 5),
                              child: Stack(
                                children: <Widget>[
                              BlocBuilder<NotificationListBloc, NotificationListState>(
                                    builder: (context, state) {
                                      if(state is NotificationListSuccess){
                                        return badges.Badge(
                                          badgeContent: Text(
                                            state.notificationModel.data!.where((e) => e.status == 'Unread').length.toString(),
                                            // notificationData!.map((e) => e.status == 'Unread').length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                                // color: Color(0xff1F6670),
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          )
                                          /*Text(
                                '$notificationCount',
                                style: TextStyle(color: Colors.white),
                              )*/,
                                          badgeStyle: const badges.BadgeStyle(
                                            badgeColor: Colors.red,
                                          ),
                                          position: badges.BadgePosition.topEnd(top: -5, end: 0),
                                          child: SvgPicture.asset(
                                            "assets/images/bell01.svg",
                                            width: 26,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                  // SvgPicture.asset(
                                  //   "assets/images/bell01.svg",
                                  //   width: 26, color: Colors.white,
                                  // ),
                                  // Positioned(
                                  //   left: 12,
                                  //   bottom: 10,
                                  //   child: Container(
                                  //     padding: EdgeInsets.all(2),
                                  //     decoration: BoxDecoration(
                                  //       color: Color(0xffCBF7ED),
                                  //       borderRadius: BorderRadius.circular(6),
                                  //     ),
                                  //     constraints: const BoxConstraints(
                                  //       minWidth: 14,
                                  //       minHeight: 14,
                                  //     ),
                                  //     child:
                                  //     /*notificationData?.length != 0
                                  //         ?  */
                                  //     BlocBuilder<NotificationListBloc, NotificationListState>(
                                  //     builder: (context, state) {
                                  //       if(state is NotificationListSuccess){
                                  //         return Text(
                                  //           state.notificationModel.data!.where((e) => e.status == 'Unread').length.toString(),
                                  //           // notificationData!.map((e) => e.status == 'Unread').length.toString(),
                                  //           style: const TextStyle(
                                  //               color: Color(0xff1F6670),
                                  //               fontSize: 9,
                                  //               fontWeight: FontWeight.w600),
                                  //           textAlign: TextAlign.center,
                                  //         );
                                  //       }
                                  //       return const SizedBox();
                                  //
                                  //       },
                                  //     )
                                  //         /*: Text("")*/,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          )
                              : SizedBox(),

                          // ClipRRect(
                          //   child: ,
                          // )
                          state.userModel.residents![0].eqaroRegister == 'Yes'
                              ? Padding(
                            padding: const EdgeInsets.only( left: 5, top: 10, ),
                            child: InkWell(
                                onTap: (){
                                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Eqaro()), (route) => false);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Eqaro()));

                                },
                                child: Image.asset(
                                  width: 28,
                                  height: 28,
                                  'assets/images/bond_eq.png',
                                  color: Colors.white,
                                  fit: BoxFit.fill,
                                )),
                              ) : SizedBox.shrink(),
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, UserProfileApp.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0, left: 5, top: 10, ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    // margin: EdgeInsets.all(10),
                                    // padding: EdgeInsets.all(10),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child:
                                    imageUrl != null
                                        ? Image.network(
                                      'https://mydashboard.btroomer.com/${state.userModel.residents![0].image}' ,
                                      // 'https://dashboard.btroomer.com/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image']}' ,
                                      loadingBuilder: (context, child, loadingProgress) =>
                                      (loadingProgress == null) ? child : CircularProgressIndicator(),
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        'assets/images/man.png',
                                        color: Colors.black,
                                        fit: BoxFit.fill,
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                        : Image.asset(
                                      'assets/images/man.png',
                                      color: Colors.black,
                                      fit: BoxFit.fill,
                                    )
                                ),
                              ),
                            ),
                          ),
                          /*IconButton(
                                icon: Icon(Icons.person),
                                iconSize: 35,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, UserProfileApp.id);
                                },
                              ),*/

                        ],
                      ),
                    ),

                    // all details / main content
                    // bottom tiles
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.310,
                      // top: MediaQuery.of(context).size.height * 0.275,
                      width: MediaQuery.of(context).size.width,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // const SizedBox(height: 20,),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                //   child: Container(
                                //     height: 50,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(30),
                                //       border: Border.all(
                                //         color: Constant.bgDark
                                //       )
                                //     ),
                                //     child: TextFormField(
                                //       decoration: const InputDecoration(
                                //         suffixIcon: Icon(Icons.search, color: Constant.bgDark, size: 17,),
                                //         border: InputBorder.none,
                                //         contentPadding: EdgeInsets.all(10),
                                //         hintText: 'Search by Property, Locality or Institute',
                                //         hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 16, fontWeight: FontWeight.w400)
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: 20,),
                                // Payments
                                BlocBuilder<BillBloc, BillState>(builder: (context, state) {
                                  if(state is BillLoading){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  if(state is BillSuccess){

                                    return state.paymentHistoryModel.data!/*.payments!*/.isEmpty
                                        ? SizedBox()
                                        : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Last Due Payment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xff031729),),),
                                              GestureDetector(
                                                // onTap: (){ BottomNavigationBar navigationBar = NavBar.getBottomNavigationBarKey().currentWidget as BottomNavigationBar;
                                                // navigationBar.onTap!(2);
                                                // },
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BillPage(isHomeNavigation: false,)));
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text('View all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,)),
                                                    SizedBox(width: 10,),
                                                    Icon(Icons.arrow_forward_ios_outlined, size: 14,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Column(
                                              children: List.generate(

                                                state.paymentHistoryModel.data!/*billModel.payments!*/.length>=1 ? 1 : state.paymentHistoryModel.data!/*billModel.payments!*/.length,

                                                    (index) {

                                                  receiptNo.text = state.paymentHistoryModel.data![index].receiptNo.toString();
                                                  pending.text = state.paymentHistoryModel.data![index].pendingAmount.toString();
                                                  paymentId = state.paymentHistoryModel.data![index].paymentId.toString();

                                                  var dueDate = state.paymentHistoryModel.data![index].dueDate.toString();
                                                  // DateTime mindueDate = new DateFormat("yyyy-MM-dd").parse(dueDate);

                                                  saveReceiptNumber(receiptNo.text);
                                                  saveReceiptNumber(pending.text);
                                                  saveReceiptNumber(paymentId.toString());
                                                  return Padding(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Container(
                                                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                                                        decoration: BoxDecoration(
                                                            color: Constant.bgTile,
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    state.paymentHistoryModel.data/*billModel.payments*/![index].receiptNo!,
                                                                    // NewHomeApp.userBills['payments'][index]['receipt_no'],
                                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                  ),
                                                                  const SizedBox(height: 5,),
                                                                  // Row(
                                                                  //   children: [
                                                                  //     Text(state.paymentHistoryModel.data/*billModel.payments*/![index].roomId/*roomName*/.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: '{ruduct Sans', color: Color(0xff6F7894)),),
                                                                  //     SizedBox(width: 5,),
                                                                  //
                                                                  //     // Text('•', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, fontFamily: '{ruduct Sans', color: Color(0xff6F7894)),),
                                                                  //     SizedBox(width: 5,),
                                                                  //     Text(
                                                                  //       state.paymentHistoryModel.data/*billModel.payments*/![index].uniqueId!,
                                                                  //       // NewHomeApp.userBills['payments'][index]['unique_id'],
                                                                  //       style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: '{ruduct Sans', color: Color(0xff6F7894)),
                                                                  //     ),
                                                                  //   ],
                                                                  // ),
                                                                  const SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          const Text('Dues'),
                                                                          Text(
                                                                            "₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![index].amount.toString())}",
                                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                      const SizedBox(width: 10,),
                                                                      Column(
                                                                        children: [
                                                                          const Text('Paid'),
                                                                          Text("₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![index].receivedAmount.toString())}",
                                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),),

                                                                        ],
                                                                      ),
                                                                      const SizedBox(width: 10,),
                                                                      Column(
                                                                        children: [
                                                                          const Text('Pending', style: TextStyle(color: Colors.red),),
                                                                          Text("₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![index].pendingAmount.toString())}",
                                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 14),),

                                                                        ],
                                                                      ),
                                                                      const SizedBox(width: 20,),
                                                                      Visibility(
                                                                          visible: double.parse(state.paymentHistoryModel.data![index].pendingAmount.toString()) > 1,
                                                                          child: InkWell(
                                                                              onTap: ()async{
                                                                                SharedPreferences pref = await SharedPreferences.getInstance();

                                                                                String branch_id = await pref.getString('branch_id')??'';
                                                                                String tenant_id = await pref.getString('tenant_id')??'';
                                                                                // UpdateReceiptsPayment();
                                                                                showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  builder: (context) {
                                                                                    receiptNo.text = state.paymentHistoryModel.data![index].receiptNo.toString();
                                                                                    pending.text = state.paymentHistoryModel.data![index].pendingAmount.toString();
                                                                                    return Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      child: /*updateReceiptClass()*/
                                                                                      StatefulBuilder(builder: (context, setState) {
                                                                                        return AlertDialog(
                                                                                          insetPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                                                                                          // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                                          title: const Text('Update Receipt Payment Transaction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                                                          content: SingleChildScrollView(
                                                                                            child: Form(
                                                                                              key: _formKey,
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width-20,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [

                                                                                                    TextFormField(
                                                                                                      readOnly: true,
                                                                                                      controller: receiptNo,
                                                                                                      style: const TextStyle(fontSize: 14),
                                                                                                      decoration: InputDecoration(
                                                                                                          labelStyle: const TextStyle(fontSize: 12,),
                                                                                                          floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                          label: const Text('Receipt No'),
                                                                                                          // floatingLabelStyle: const TextStyle(fontSize: 50),
                                                                                                          // labelStyle: const TextStyle(fontSize: 18),
                                                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                          border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          )
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(height: 10,),

                                                                                                    TextFormField(
                                                                                                      readOnly: true,
                                                                                                      controller: pending,
                                                                                                      style: const TextStyle(fontSize: 14),
                                                                                                      decoration: InputDecoration(
                                                                                                          labelStyle: const TextStyle(fontSize: 12,),
                                                                                                          floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                          label: const Text('Pending Amount'),
                                                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                          border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          )
                                                                                                      ),
                                                                                                    ),

                                                                                                    Row(
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Radio<String>(
                                                                                                              value: 'Cash',
                                                                                                              groupValue: selectMode,
                                                                                                              onChanged: (String? value) {
                                                                                                                selectMode = value.toString();
                                                                                                                print('selectMode: ${selectMode}');
                                                                                                                setState((){});
                                                                                                              },
                                                                                                            ),
                                                                                                            Text('Cash')
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Radio<String>(
                                                                                                              value: 'Online',
                                                                                                              groupValue: selectMode,
                                                                                                              onChanged: (String? value) {
                                                                                                                selectMode = value.toString();
                                                                                                                print('selectMode: ${selectMode}');
                                                                                                                setState((){});
                                                                                                              },
                                                                                                            ),
                                                                                                            Text('Online')
                                                                                                          ],
                                                                                                        )


                                                                                                      ],
                                                                                                    ),

                                                                                                    Visibility(
                                                                                                      visible: selectMode != 'Online' ,
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            const SizedBox(height: 10,),
                                                                                                            TextFormField(
                                                                                                              controller: receivedAmtController,
                                                                                                              style: const TextStyle(fontSize: 14),
                                                                                                              keyboardType: TextInputType.number,
                                                                                                              decoration: InputDecoration(
                                                                                                                  labelStyle: const TextStyle(fontSize: 12,),
                                                                                                                  floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                                  label: const Text('Payment Amount'),
                                                                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                                  border: OutlineInputBorder(
                                                                                                                      borderRadius: BorderRadius.circular(12)
                                                                                                                  )
                                                                                                              ),
                                                                                                              inputFormatters: [
                                                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                                                FilteringTextInputFormatter.singleLineFormatter
                                                                                                              ],
                                                                                                              validator: (value) {
                                                                                                                if(value!=""){
                                                                                                                  if(double.parse(state.paymentHistoryModel.data![index].pendingAmount!) < double.parse(value!)){
                                                                                                                    return 'Payment amount should not bigger than pending';
                                                                                                                  }else if(state.paymentHistoryModel.data![index].pendingAmount! == null || double.parse(state.paymentHistoryModel.data![index].pendingAmount!) < 0 || state.paymentHistoryModel.data![index].pendingAmount.toString().isEmpty){
                                                                                                                    return 'Enter the amount';
                                                                                                                  }

                                                                                                                }else{
                                                                                                                  return 'Enter the amount';
                                                                                                                }
                                                                                                                return null;
                                                                                                              },
                                                                                                            ),
                                                                                                          ],
                                                                                                        )

                                                                                                    ),



                                                                                                    // DropdownButtonFormField<String>(
                                                                                                    //   value: selectedPayMode,
                                                                                                    //   style: const TextStyle(fontSize: 14, color: Colors.black),
                                                                                                    //
                                                                                                    //   decoration: InputDecoration(
                                                                                                    //     labelStyle: const TextStyle(fontSize: 12,),
                                                                                                    //     floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                    //     label: const Text('Payment Mode'),
                                                                                                    //     contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                    //     border: OutlineInputBorder(
                                                                                                    //         borderRadius: BorderRadius.circular(12)
                                                                                                    //     ),
                                                                                                    //     // focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                                                                                                    //     // enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                                                                                                    //   ),
                                                                                                    //   // maxHeight: 300,
                                                                                                    //   // asyncItems: (String? filter) => complainHead.length.toString(),
                                                                                                    //   items: paymentMode.map<DropdownMenuItem<String>>((String value) {
                                                                                                    //     return DropdownMenuItem<String>(
                                                                                                    //       value: value,
                                                                                                    //       child: Text(value),
                                                                                                    //     );
                                                                                                    //   }).toList(),
                                                                                                    //
                                                                                                    //   onChanged: (payment) {
                                                                                                    //
                                                                                                    //     selectedPayMode=payment.toString();
                                                                                                    //     if(selectedPayMode == 'Cash'){
                                                                                                    //       transactionIdController.clear();
                                                                                                    //     }
                                                                                                    //
                                                                                                    //       print('transactionId -- ${transactionIdController.text.toString()}');
                                                                                                    //     setState(() {
                                                                                                    //     });
                                                                                                    //
                                                                                                    //   },
                                                                                                    //   // showSearchBox: true,
                                                                                                    // ),




                                                                                                    const SizedBox(height: 10,),

                                                                                                    TextFormField(
                                                                                                      onTap: () async{
                                                                                                        // _presentDatePicker();
                                                                                                        final now = DateTime.now();
                                                                                                        final firstDate = DateTime(now.year - 1, now.month, now.day);
                                                                                                        DateTime? pickedDate = await showDatePicker(
                                                                                                            context: context,
                                                                                                            initialDate: now,
                                                                                                            firstDate: now/*DateTime(2021)*/, //DateTime.now() - not to allow to choose before today.
                                                                                                            lastDate: now
                                                                                                        );

                                                                                                        if(pickedDate != null ){
                                                                                                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                                                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                                                                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                                                                          //you can implement different kind of Date Format here according to your requirement

                                                                                                          setState(() {
                                                                                                            dateinput.text = formattedDate; //set output date to TextField value.
                                                                                                          });
                                                                                                        }else{
                                                                                                          print("Date is not selected");
                                                                                                        }
                                                                                                      },
                                                                                                      readOnly: true,
                                                                                                      controller: dateinput,
                                                                                                      style: const TextStyle(fontSize: 14),
                                                                                                      decoration: InputDecoration(
                                                                                                          labelStyle: const TextStyle(fontSize: 12,),
                                                                                                          floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                          label: const Text('Payment Date'),
                                                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                          border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          ),
                                                                                                          suffixIcon: Icon(Icons.calendar_today)
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(height: 10,),

                                                                                                    Visibility(
                                                                                                      visible: selectedPayMode != 'Cash',
                                                                                                      child: TextFormField(
                                                                                                        controller: transactionIdController,
                                                                                                        style: const TextStyle(fontSize: 14),
                                                                                                        decoration: InputDecoration(
                                                                                                            labelStyle: const TextStyle(fontSize: 12,),
                                                                                                            floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                            label: const Text('Transaction Id'),
                                                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                            border: OutlineInputBorder(
                                                                                                                borderRadius: BorderRadius.circular(12)
                                                                                                            )
                                                                                                        ),
                                                                                                        validator: (value) {
                                                                                                          if(value == null || value.isEmpty){
                                                                                                            return 'Please enter Transaction Id';
                                                                                                          }
                                                                                                          return null;
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    Visibility(
                                                                                                        visible: selectedPayMode != 'Cash',
                                                                                                        child: const SizedBox(height: 10,)),

                                                                                                    TextFormField(
                                                                                                      controller: remarkController,
                                                                                                      style: const TextStyle(fontSize: 14),
                                                                                                      decoration: InputDecoration(
                                                                                                          labelStyle: const TextStyle(fontSize: 12,),
                                                                                                          floatingLabelStyle: const TextStyle(fontSize: 16),
                                                                                                          label: const Text('Remark'),
                                                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                          border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          )
                                                                                                      ),
                                                                                                    ),
                                                                                                    // const SizedBox(height: 20,),

                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          actions: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: ElevatedButton(
                                                                                                      style: ElevatedButton.styleFrom(
                                                                                                          backgroundColor: Colors.green,
                                                                                                          shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          )
                                                                                                      ),
                                                                                                      onPressed: selectMode == 'Online'
                                                                                                          ? () async{
                                                                                                        try {
                                                                                                          var session = await createSession(state.paymentHistoryModel.data![index].pendingAmount.toString());
                                                                                                          List<CFPaymentModes> components = <CFPaymentModes>[];
                                                                                                          // If you want to set paument mode to be shown to customer
                                                                                                          var paymentComponent =
                                                                                                          CFPaymentComponentBuilder().setComponents(components).build();
                                                                                                          // We will set theme of checkout session page like fonts, color
                                                                                                          var theme = CFThemeBuilder()
                                                                                                              .setNavigationBarBackgroundColorColor("#6F6FE4")
                                                                                                              // .setPrimaryFont("Menlo")
                                                                                                              // .setSecondaryFont("Futura")
                                                                                                              .build();
                                                                                                          // Create checkout with all the settings we have set earlier
                                                                                                          var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
                                                                                                              .setSession(session!)
                                                                                                              .setPaymentComponent(paymentComponent)
                                                                                                              .setTheme(theme)
                                                                                                              .build();
                                                                                                          // Launching the payment page

                                                                                                          cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
                                                                                                        } on CFException catch (e) {
                                                                                                          print(e.message);
                                                                                                        }
                                                                                                      }
                                                                                                          : (){
                                                                                                        if(_formKey.currentState!.validate()){
                                                                                                          process = true;
                                                                                                          setState(() {

                                                                                                          });

                                                                                                          showDialog(context: context, builder: (context) {
                                                                                                            return Visibility(
                                                                                                              visible: process == true ? true : false,
                                                                                                              child: AlertDialog(
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
                                                                                                                    child: CircularProgressIndicator()),
                                                                                                              ),
                                                                                                            );
                                                                                                          },);
                                                                                                          API.updatepaymentreceipts('insertPaymentTransactionTenant',
                                                                                                              branch_id.toString(), tenant_id.toString(), receivedAmtController.text, selectedPayMode,
                                                                                                              dateinput.text, transactionIdController.text, remarkController.text.toString(), paymentId.toString()).then((value) {
                                                                                                            if(value['success'] == 1){
                                                                                                              // isVisible = false;
                                                                                                              // otpVerify = true;
                                                                                                              process = false;
                                                                                                              receivedAmtController.clear();
                                                                                                              setState(() {
                                                                                                              });
                                                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                                                                                              Navigator.pop(context);
                                                                                                              Navigator.pop(context);


                                                                                                            }else{
                                                                                                              receivedAmtController.clear();
                                                                                                              setState(() {
                                                                                                              });
                                                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                                                                                              Navigator.pop(context);
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                          });


                                                                                                          // BlocProvider.of<UpdateReceiptPaymentBloc>(context).add(UpdateReceiptPaymentRefreshEvent();
                                                                                                        }
                                                                                                      },
                                                                                                      child: Text(selectMode == 'Online' ? 'Pay' : 'Submit', style: TextStyle(color: Colors.white),)),
                                                                                                ),
                                                                                                const SizedBox(width: 10,),
                                                                                                Expanded(
                                                                                                  child: ElevatedButton(
                                                                                                      style: ElevatedButton.styleFrom(
                                                                                                          backgroundColor: Constant.bgButton,
                                                                                                          shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(12)
                                                                                                          )
                                                                                                      ),
                                                                                                      onPressed: (){
                                                                                                        receivedAmtController.clear();
                                                                                                        Navigator.pop(context);
                                                                                                      }, child: const Text('Close', style: TextStyle(color: Colors.white),)),
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      },

                                                                                      ),
                                                                                    );
                                                                                  },);
                                                                              },
                                                                              child: const Icon(Icons.receipt_long))),
                                                                      // Padding(
                                                                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      //   child: InkWell(
                                                                      //       onTap: (){
                                                                      //         Navigator.push(context, MaterialPageRoute(builder: (context) => CashFreePayment()));
                                                                      //       },
                                                                      //       child: Icon(Icons.payment)),
                                                                      // )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    state.paymentHistoryModel.data/*billModel.payments*/![index].receiptDate!,
                                                                    // NewHomeApp.userBills['payments'][index]['receipt_date'],
                                                                    style: const TextStyle(color: Colors.black/*Color(0xffABAFB8)*/, fontSize: 12, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed: () async {
                                                                        launchUrl(Uri.parse(state.paymentHistoryModel.data![index].receiptUrl.toString()));

                                                                        // showDialog<String>(
                                                                        //   context: context,
                                                                        //   barrierDismissible: false,
                                                                        //   barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                                        //   builder: (BuildContext
                                                                        //   context) =>
                                                                        //       WillPopScope(
                                                                        //         onWillPop: () async => false,
                                                                        //         child: AlertDialog(
                                                                        //           elevation: 0,
                                                                        //           backgroundColor: Colors.transparent,
                                                                        //           content: Container(
                                                                        //             child: Image.asset(
                                                                        //                 'assets/images/loading_anim.gif'),
                                                                        //             height: 100,
                                                                        //           ),
                                                                        //         ),
                                                                        //       ),
                                                                        // );
                                                                        // print(state.paymentHistoryModel.data/*billModel.payments*/![index].receiptUrl.toString());
                                                                        // // print(NewHomeApp.userBills['payments'][index]['url'].toString());
                                                                        // print(state.paymentHistoryModel.data/*billModel.payments*/![index].receiptDate);
                                                                        // // print(NewHomeApp.userBills['payments'][index]['receipt_date']);
                                                                        // await openFile(
                                                                        //   url: state.paymentHistoryModel.data/*billModel.payments*/![index].receiptUrl.toString(),
                                                                        //   fileName:
                                                                        //   "${state.paymentHistoryModel.data/*billModel.payments*/![index].receiptNo}-${state.paymentHistoryModel.data/*billModel.payments*/![index].receiptDate}.pdf",
                                                                        //   // "${NewHomeApp.userBills['payments'][index]['receipt_no']}-${NewHomeApp.userBills['payments'][index]['receipt_date']}.pdf",
                                                                        //
                                                                        // );
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                      icon: SvgPicture.asset('assets/home/download.svg', height: 40, width: 40,)/*const Icon(Icons.file_download_outlined, size: 30,),*/
                                                                    //color: Colors.red,
                                                                  ),

                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  );

                                                },
                                              )),
                                        )
                                      ],
                                    );
                                  }
                                  if(state is BillError){
                                    return Center(child: Text(state.error, style: const TextStyle(color: Colors.black),),);
                                  }
                                  return const SizedBox();
                                },),

                                // const SizedBox(height: 14,),

                                // Accommodation
                                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                                  if(state is HomeLoading){
                                    return Container();
                                  }
                                  if(state is HomeSuccess){
                                    return state.userModel.accommodation == null /*&& state.userModel.accommodation!.isEmpty*/ /*|| state.userModel.accommodation == null */? SizedBox() : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Accommodation', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xff031729),),),
                                              GestureDetector(
                                                onTap: (){

                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccommodationScreen()));
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileApp()));
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text('View all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,)),
                                                    SizedBox(width: 10,),
                                                    Icon(Icons.arrow_forward_ios_outlined, size: 14,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: BlocBuilder<HomeBloc, HomeState>(
                                              builder: (BuildContext context, state) {

                                                if(state is HomeLoading){
                                                  return Container();
                                                }
                                                if(state is HomeSuccess){
                                                  return Padding(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Constant.bgTile
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 10, vertical: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  state.userModel.residents![0].accommodation!.last.room.toString(),
                                                                  style: const TextStyle(
                                                                      fontWeight: FontWeight.w700, fontSize: 14),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset('assets/explore/bed.svg'),
                                                                    // Icon(Icons.bed),
                                                                    const SizedBox(width: 4,),
                                                                    Text(
                                                                      state.userModel.residents![0].accommodation!.last.bed.toString(),
                                                                      // "${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['bed'].toString()}",
                                                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 10,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    // Text("Branch", style: TextStyle(
                                                                    //     color: Color(0xffABAFB8)),),
                                                                    SizedBox(
                                                                      // width: 200,
                                                                      child: Text(
                                                                        state.userModel.residents![0].accommodation!.last.branch.toString(),
                                                                        // NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['branch']
                                                                        style: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff6F7894)),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    // Text("Date", style: TextStyle(color: Color(0xffABAFB8))),
                                                                    Text(
                                                                        '${state.userModel.residents![0].accommodation!.last.fromDate.toString()} ${state.userModel.residents![0].accommodation!.last.toDate.toString()}',
                                                                        // '${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['from_date'].toString()} ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['to_date'].toString()}',
                                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black/*Color(0xff6F7894)*/,)
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            // SizedBox(height: 4,),
                                                            // index < 1 ? Divider(thickness: 1, color: Color(0xffD9E2FF),
                                                            // ) : SizedBox()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  /*Column(
                                                      children: List.generate(
                                                        state.userModel.residents![0].accommodation!.length,
                                                            (index) {
                                                          return Padding(
                                                            padding: const EdgeInsets.all(0.0),
                                                            child: Container(
                                                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  color: Constant.bgTile
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10, vertical: 10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          state.userModel.residents![0].accommodation![index].room.toString(),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w700, fontSize: 14),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset('assets/explore/bed.svg'),
                                                                            // Icon(Icons.bed),
                                                                            const SizedBox(width: 4,),
                                                                            Text(
                                                                              state.userModel.residents![0].accommodation![index].bed.toString(),
                                                                              // "${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['bed'].toString()}",
                                                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            // Text("Branch", style: TextStyle(
                                                                            //     color: Color(0xffABAFB8)),),
                                                                            SizedBox(
                                                                              width: 200,
                                                                              child: Text(
                                                                                state.userModel.residents![0].accommodation![index].branch.toString(),
                                                                                // NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['branch']
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff6F7894)),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            // Text("Date", style: TextStyle(color: Color(0xffABAFB8))),
                                                                            Text(
                                                                                '${state.userModel.residents![0].accommodation![index].fromDate.toString()} ${state.userModel.residents![0].accommodation![index].toDate.toString()}',
                                                                                // '${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['from_date'].toString()} ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['to_date'].toString()}',
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff6F7894),)
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    // SizedBox(height: 4,),
                                                                    // index < 1 ? Divider(thickness: 1, color: Color(0xffD9E2FF),
                                                                    // ) : SizedBox()
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ));*/
                                                }

                                                if(state is HomeError){
                                                  return Center(child: Container(child: Text(state.error),),);
                                                }
                                                return SizedBox();

                                              },)


                                        ),
                                      ],
                                    );
                                  }
                                  if(state is HomeError){
                                    return Center(child: Container(child: Text(state.error, style: TextStyle(color: Colors.black),),),);
                                  }
                                  return SizedBox();
                                },),

                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Complains
                                BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
                                  if(state is ComplainLoading){
                                    return SizedBox();
                                  }
                                  if(state is ComplainSuccess){
                                    return state.complainModel.complain!.isEmpty ? SizedBox() : Column(
                                      children: [
                                        // Padding(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 16, vertical: 8),
                                        //     child:
                                        //     BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
                                        //       if(state is ComplainSuccess){
                                        //         return Row(
                                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //           children: [
                                        //             const Text('Last Complaint', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xff031729),),),
                                        //             GestureDetector(
                                        //               onTap: (){
                                        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => Page2App(isHomeNavigation: false,)));
                                        //               },
                                        //               child: const Row(
                                        //                 children: [
                                        //                   Text('View all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,)),
                                        //                   SizedBox(width: 10,),
                                        //                   Icon(Icons.arrow_forward_ios_outlined, size: 14,)
                                        //                 ],
                                        //               ),
                                        //             )
                                        //           ],
                                        //         );
                                        //       }
                                        //       return SizedBox();
                                        //     },)
                                        //
                                        // ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
                                              if(state is ComplainLoading){
                                                return SizedBox();
                                              }
                                              if(state is ComplainSuccess){
                                                return Column(
                                                    children: List.generate(
                                                      state.complainModel.complain!.length>=1?1:
                                                      state.complainModel.complain!.length,
                                                          (index) {
                                                        return state.complainModel.complain![index].id!.isEmpty ? SizedBox() : Padding(
                                                          padding: const EdgeInsets.all(0.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text('Last Complaint', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xff031729),),),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Page2App(isHomeNavigation: false,)));
                                                                    },
                                                                    child: const Row(
                                                                      children: [
                                                                        Text('View all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,)),
                                                                        SizedBox(width: 10,),
                                                                        Icon(Icons.arrow_forward_ios_outlined, size: 14,)
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 16,),
                                                              Container(
                                                                margin: const EdgeInsets.symmetric(vertical: 5.0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    color: Constant.bgTile
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 10, vertical: 10),
                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "ID-" +
                                                                                    state.complainModel.complain![index].id.toString(),
                                                                                // NewHomeApp.userComplains['complain'][index]['id'].toString(),
                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                              ),
                                                                              Text(state.complainModel.complain![index].headName.toString(),
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff6F7894)),)
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [

                                                                              Text(state.complainModel.complain![index].complainStatus == null || state.complainModel.complain![index].complainStatus == ''? '':
                                                                                state.complainModel.complain![index].complainStatus
                                                                                // NewHomeApp.userComplains['complain'][index]['status']
                                                                                    .toString()
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color:state.complainModel.complain![index].complainStatus
                                                                                // style: TextStyle(color:NewHomeApp.userComplains['complain'][index]['status']
                                                                                    .toString()
                                                                                    .toUpperCase()=="PENDING"? Constant.bgPending:
                                                                                state.complainModel.complain![index].complainStatus
                                                                                // NewHomeApp.userComplains['complain'][index]['status']
                                                                                    .toString()
                                                                                    .toUpperCase()=="IN PROCESS"?
                                                                                Color(0xffFF903F):Colors.green),
                                                                              ),
                                                                              // Icon(Icons.keyboard_arrow_right)
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      // const SizedBox(height: 8,),
                                                                      // index < 2 ? const Divider(thickness: 1, color: Color(0xffD9E2FF),) : SizedBox()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ));
                                              }
                                              if(state is ComplainError){
                                                return Center(child: Container(child: Text(state.error),),);
                                              }
                                              return SizedBox();
                                            },)

                                        ),
                                      ],
                                    );
                                  }
                                  if(state is ComplainError){
                                    return Center(child: Container(child: Text(state.error,style: TextStyle(color: Colors.black),),),);
                                  }
                                  return SizedBox();
                                },),

                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Amenities
                                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                                  if(state is HomeLoading){
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  if(state is HomeSuccess){
                                    return
                                      state.userModel.amenities == null || state.userModel.amenities!.isEmpty ||
                                          state.userModel.amenities!.any((amenity) => amenity.amenityName!.isEmpty)
                                  ? const SizedBox.shrink()
                                      :
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Text('Amenities', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xff031729),),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Color(0xff000000).withOpacity(.1)),
                                                borderRadius: BorderRadius.circular(16)),
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              children: [

                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Constant.bgTile,
                                                  ),
                                                  child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 16, vertical: 8),
                                                          child: Container(
                                                            alignment: AlignmentDirectional.topStart,
                                                            child: Wrap(
                                                              children: List.generate(
                                                                  state.userModel.amenities!.length,
                                                                      (index) => Padding(
                                                                    padding:
                                                                    const EdgeInsets.symmetric(
                                                                        horizontal: 2),
                                                                    child: /*state.userModel.amenities![index].amenityName.toString().isEmpty ? SizedBox() :*/
                                                                    Container(
                                                                        padding: EdgeInsets.all(8),
                                                                        margin: EdgeInsets.all(3),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            color: Colors.white
                                                                        ),
                                                                        child: Text(
                                                                          '${state.userModel.amenities![index].amenityName}',
                                                                          style: const TextStyle(
                                                                              fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Product Sans', color: Constant.bgText),
                                                                        )),
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  if(state is HomeError){
                                    return Center(child: Text(state.error, style: TextStyle(color: Colors.black),));
                                  }
                                  return SizedBox();
                                },),



                                const SizedBox(height: 20,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // uppersection
                    // rent tile
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.14,
                      // left: MediaQuery.of(context).size.width * 0.08,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                            if(state is HomeLoading){
                              print('LoadingSuccess');
                              Container();
                            }
                            else if(state is HomeSuccess){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width-40,
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 120,
                                          // width: 160,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Constant.bgDark
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: SvgPicture.asset('assets/home/money.svg'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                child: GestureDetector(
                                                  child:
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                        children: [
                                                          const TextSpan(text: '₹ ',style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.w700),),
                                                          TextSpan(text: formatRentRange(state.userModel.residents![0].totalDue.toString()) == "" ? "0" : formatRentRange(state.userModel.residents![0].dueAmount.toString()),
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.w700),),
                                                        ],
                                                      ),
                                                      ),
                                                      Text(
                                                        'Total Dues',
                                                        style: TextStyle(
                                                            color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w400),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: (){
                                                    print("DUEAMOUNT : "+state.userModel.residents![0].dueAmount.toString());
                                                    if(state.userModel.residents![0].dueAmount.toString() == "0" || state.userModel.residents![0].dueAmount.toString() == "0.0" || state.userModel.residents![0].dueAmount.toString() == ""){
                                                      final snackbar = const SnackBar(content: Text('There is no Due Rent amount'));
                                                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                                    } else {
                                                      Navigator.pushNamed(context, QrcodePage.id);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      Expanded(
                                        child: Container(
                                          height: 120,
                                          // width: 160,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Constant.bgDark
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: SvgPicture.asset('assets/home/date.svg'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${getDateInformate(state.userModel.residents![0].dueDate.toString())}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    Text(
                                                      'Next Due Date',
                                                      style: TextStyle(
                                                          color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            else if(state is HomeError){
                              return Center(child: Container(child: Text(state.error, style: TextStyle(color: Colors.black),),),);
                            }
                            return const SizedBox();
                          },)

                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
            if(state is HomeError){
              print('ErrorThrow');
              return Center(child: Container(child: Text(state.error, style: TextStyle(color: Colors.black),),),);

            }
            return Center(child: Container(child: Text('')));

          },),
        ),
      ),
    );
  }
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(double.parse(rent));
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
  File? _storedImage;
  String _storedImage1 = "";
  XFile? imageFileFromCamera;

  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFileFromGallery = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFileFromGallery!.path);
      _storedImage1 = _storedImage.toString();
    });
    print('Image path:---- ${_storedImage}');
  }

  Future<void> _dialogCall(BuildContext context,) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog();
        });
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

  void getiOSDeviceIdentifier() async{
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    var data = await deviceInfoPlugin.iosInfo;

    _identifier = data.identifierForVendor!;
  }


}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  File? _storedImage;
  String _storedImage1 = "";
  XFile? imageFileFromCamera;
  TextEditingController remarkController = TextEditingController();

  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFileFromGallery = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFileFromGallery!.path);
      _storedImage1 = _storedImage.toString();
    });
    print('Image path:---- ${_storedImage}');
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      title: Center(
        child: Text("Upload the Screenshot Image",style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w500),),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Document',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _takePictureFromGallery();
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Color(0xff001944)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _storedImage != null
                            ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(
                              _storedImage!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                        )
                            : Column(
                          children: [
                            Image.asset(
                              "assets/images/gallery_01.png",
                              width: 70,
                            ),
                            Text('Gallery',style: TextStyle(fontWeight: FontWeight.w500),)
                          ],
                        ),
                      )),
                ),
                const SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: TextField(
                    controller: remarkController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        label: Text('Remark'),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff001944),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ), // Background color
            ),
            onPressed: () async {
              if(remarkController.text.isNotEmpty){
                final SharedPreferences prefs = await SharedPreferences.getInstance();

                String branch_id = await prefs.getString("branch_id").toString();
                final userId = prefs.getString('id');
                await API.sendScreenShotImg(
                    branch_id, userId.toString(), remarkController.text, _storedImage!,"69",context);
                await Fluttertoast.showToast(
                  msg: "Screenshot Uploaded Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Color(0xff001944),
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
                Navigator.pop(context);
              } else {
                await Fluttertoast.showToast(
                  msg: "Select Image & add remark",
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Color(0xff001944),
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
              }
            }, child: Text("Submit",style: TextStyle(color: Colors.white),))
      ],
    );
  }
}

createSessionID(String orderID, String amount, String name, String email, String phone) async {
  var headers = {
    'Content-Type': 'application/json',
    'x-client-id': "TEST10209706acea64e1b0e2d441ac2f60790201",
    'x-client-secret': "cfsk_ma_test_03c3bdfa45cbb73b69594106f1ec61d2_82d77b20" ,
    'x-api-version': '2023-08-01', // This is latest version for API
    'x-request-id': 'fluterwings'
  };
  print(headers);
  var request =
  http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders'));
  request.body = json.encode({
    "order_amount": 1/*amount*/, // Order Amount in Rupees
    // "order_id": orderID,
    "order_currency": "INR", // Currency of order like INR,USD
    "customer_details": {
      "customer_id": "customer_id", // Customer id
      "customer_name": name/*"customer_name"*/, // Name of customer
      "customer_email": email/*"test114@gmail.com"*/, // Email id of customer
      "customer_phone": "+91${phone}" // Phone Number of customer
    },
    "order_meta": {"notify_url": "https://test.cashfree.com"},
    "order_note": "some order note here" // If you want to store something extra
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // print(response.stream.bytesToString());
    return jsonDecode(await response.stream.bytesToString());
  } else {
    print(await response.stream.bytesToString());
    print(response.reasonPhrase);
  }



}


Future sharePaymentLink(String link_id) async {
  var headers = {
    'Content-Type': 'application/json',
    'x-client-id': 'TEST10209706acea64e1b0e2d441ac2f60790201',
    'x-client-secret': 'cfsk_ma_test_03c3bdfa45cbb73b69594106f1ec61d2_82d77b20',
    'x-api-version': '2023-08-01',
    'x-request-id': 'flutterwings'
  };

  var url = Uri.parse('https://sandbox.cashfree.com/pg/links');

  var body = json.encode({
    "customer_details": {
      "customer_email": "john@cashfree.com",
      "customer_name": "John Doe",
      "customer_phone": "9999999999"
    },
    "link_notify": {
      "send_email": true,
      "send_sms": false
    },
    "link_notes": {
      "key_1": "value_1",
      "key_2": "value_2"
    },
    "link_meta": {
      "notify_url": "https://ee08e626ecd88c61c85f5c69c0418cb5.m.pipedream.net",
      "return_url": "https://b8af79f41056.eu.ngrok.io",
      "upi_intent": false
    },
    "link_amount": 1,
    "link_auto_reminders": true,
    "link_currency": "INR",
    "link_id": link_id,
    "link_partial_payments": false,
    "link_purpose": "Payment for Room Rent"
  });

  var response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print('Response body: $jsonResponse');

    // Handle the response data as needed
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}');
    print('Error message: ${response.reasonPhrase}');
    print('Error body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);

    Fluttertoast.showToast(
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14.0,
        timeInSecForIosWeb:12,
        backgroundColor: Colors.red
    );
    return jsonResponse;
    // Handle error cases here
  }
}