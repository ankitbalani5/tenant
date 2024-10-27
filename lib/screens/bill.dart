import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/providerfuction.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/bill_bloc/bill_bloc.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/splash.dart';
import 'package:roomertenant/show_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/apitget.dart';
import '../utils/utils.dart';
import 'internet_check.dart';

class BillPage extends StatefulWidget {
  static const String id = 'billpage';
  bool isHomeNavigation;
  BillPage({Key? key, required bool this.isHomeNavigation,}) : super(key: key);


  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  DateTime? _selected;
  bool process = false;
  String? branch_id;
  String? tenant_id;
  String payment_from = '2023-01-01';
  String? payment_to ;
  TextEditingController receiptNo = TextEditingController();
  TextEditingController pending = TextEditingController();
  String? paymentId;
  TextEditingController dateinput = TextEditingController();
  TextEditingController receivedAmtController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  List<String> paymentMode = ['Cash', 'Paytm', 'PhonePe', 'Google Pay', 'Online/IMPS', 'UPI', 'Cheque', 'Wallet'];
  String selectedPayMode="Cash";
  var selectMode = 'Cash';
  String? name;
  String? email;
  String? mobile_no;
  bool? isSuccess;


  @override
  void initState() {
    String nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateinput.text = nowDate;// Attach events when payment is success and when error occured
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    billBloc();
    fetchData();
    super.initState();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('name');
    email = pref.getString('email_id');
    mobile_no = pref.getString('mobile_no');
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

  // Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(double.parse(rent));
  }

  Future onRefresh () async{
    BlocProvider.of<BillBloc>(context).add(BillRefreshEvent('gatResidentPaymentData',
        branch_id.toString(), tenant_id.toString(), payment_from.toString(), payment_to.toString()));
  }

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

  void verifyPayment(String orderId) {
    // Here we will only print the statement
    // to check payment is done or not
    isSuccess = true;
    setState(() {});
    print("Verify Payment $orderId");
    Fluttertoast.showToast(
        msg: orderId,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14.0,
        timeInSecForIosWeb:12,
        backgroundColor: Colors.green
    );
  }

  billBloc()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    branch_id = pref.getString('branch_id');
    tenant_id = pref.getString('tenant_id');
    paymentId = await pref.getString("paymentId").toString();
    DateTime now = DateTime.now();
    payment_to = now.toString();
    setState(() {

    });
    final userId = pref.getString('id');
    BlocProvider.of<BillBloc>(context).add(BillRefreshEvent('gatResidentPaymentData',
        branch_id.toString(), tenant_id.toString(), payment_from.toString(), payment_to.toString()));
  }

  /*UpdateReceiptsPayment()async{

    print("CallPayment-----------------------------");
    SharedPreferences pref = await SharedPreferences.getInstance();
    // receiptNo.text = pref.getString('receiptNo')??'';
    pending.text = pref.getString('pending')??'';
    String branch_id = await pref.getString("branch_id").toString();
    String tenant_id = await pref.getString("tenant_id").toString();
    String paymentId = await pref.getString("paymentId").toString();
    int pendingInt =int.parse(pending.text);

    showDialog(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
            title: Text('Update Receipt Payment Transaction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Receipt No', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      readOnly: true,
                      controller: receiptNo,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Pending Amount', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      readOnly: true,
                      controller: pending,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Received Amount', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      controller: receivedAmtController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
                          if(pendingInt < int.parse(value!)){
                            return 'Received amount should not bigger than pending';
                          }else if(pendingInt == null || pendingInt < 0 || pending.text.isEmpty){
                            return 'Enter the amount';
                          }

                        }else{
                          return 'Enter value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    const Text('Payment Mode', style: TextStyle(fontSize: 12),),
                    DropdownButtonFormField<String>(
                      value: selectedPayMode,


                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        // focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                        // enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                      ),
                      // maxHeight: 300,
                      // asyncItems: (String? filter) => complainHead.length.toString(),
                      items: paymentMode.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),

                      onChanged: (payment) {

                        selectedPayMode=payment.toString();

                      },
                      // showSearchBox: true,
                    ),
                    const SizedBox(height: 10,),
                    const Text('Payment Date', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      onTap: () async{
                        // _presentDatePicker();
                        String nowDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
                        dateinput.text = nowDate;
                        final now = DateTime.now();
                        final firstDate = DateTime(now.year - 1, now.month, now.day);
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021), //DateTime.now() - not to allow to choose before today.
                            lastDate: now
                        );

                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          suffixIcon: Icon(Icons.calendar_today)
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Transaction Id', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      controller: transactionIdController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Remark', style: TextStyle(fontSize: 12)),
                    TextFormField(
                      controller: remarkController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                )
                            ),
                            onPressed: (){
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
                                    setState(() {
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                    receivedAmtController.clear();
                                    Navigator.pop(context);
                                    Navigator.pop(context);


                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                    receivedAmtController.clear();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                });










                                // BlocProvider.of<UpdateReceiptPaymentBloc>(context).add(UpdateReceiptPaymentRefreshEvent();
                              }
                            }, child: Text('Submit', style: TextStyle(color: Colors.white),)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constant.bgButton,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                )
                            ),
                            onPressed: (){
                              receivedAmtController.clear();
                              Navigator.pop(context);
                            }, child: Text('Close', style: TextStyle(color: Colors.white),)),
                      ],
                    )



                  ],
                ),
              ),
            ),
          ),
        );
      },);

  }*/

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,));
    return Scaffold(
      body: NetworkObserverBlock(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: [

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Stack(
                    children: [
                      Container(
                        height: 120,
                        color: Constant.bgLight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Row(
                                children: [
                                  widget.isHomeNavigation == false
                                      ? IconButton(
                                          onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                          icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 22,),)
                                      : const SizedBox(width: 10,),
                                  const Text(
                                    'Receipts',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialDate: _selected ?? DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime.now(),
                                      builder: (BuildContext context, Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            primaryColor: Color(0xff8787FF), // Adjust the primary color as needed
                                            highlightColor: Color(0xff8787FF),
                                            // backgroundColor: Colors.white,
                                            textTheme: TextTheme(titleMedium: TextStyle(fontSize: 18)),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            colorScheme: ColorScheme.light(primary: Color(0xff8787FF)),
                                            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      }
                                  );

                                  if (selected != null) {
                                    // Set the selected month's first day
                                    DateTime fromDate = DateTime(selected.year, selected.month, 1);

                                    // Set the selected month's last day
                                    DateTime toDate = DateTime(selected.year, selected.month + 1, 0);

                                    // Format the dates for display and API call
                                    String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
                                    String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

                                    setState(() {
                                      _selected = selected;
                                      payment_from = formattedFromDate;
                                      payment_to = formattedToDate;
                                      dateinput.text = formattedFromDate; // Or use formattedToDate if needed
                                    });

                                    // Make the API call
                                    BlocProvider.of<BillBloc>(context).add(
                                      BillRefreshEvent(
                                        'gatResidentPaymentData',
                                        branch_id.toString(),
                                        tenant_id.toString(),
                                        /*'2024-02-01'*/formattedFromDate.toString(),
                                        /*'2024-02-24'*/formattedToDate.toString(),
                                      ),
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                                  child: Icon(Icons.calendar_month, size: 24, color: Colors.white,),
                                ),
                              )

                              /*InkWell(
                                  onTap: () async{
                                    // final localeObj = locale != null ? Locale(locale) : null;
                                    final selected = await showMonthYearPicker(
                                      context: context,
                                      initialDate: _selected ?? DateTime.now(),
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime(2030),
                                      // locale: localeObj,
                                    );
                                    if (selected != null) {
                                      setState(() {
                                        _selected = selected;
                                      });
                                    }
                                  },
                                  child: Icon(Icons.calendar_month))*/
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.09,
              //   decoration: BoxDecoration(
              //     color: Constant.bgLight,
              //     borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
              //   ),
              // ),
              /*Consumer<APIprovider>(
              builder: (context, apiprovider, child) => */
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
                  child: BlocBuilder<BillBloc, BillState>(builder: (context, state) {
                    if(state is BillLoading){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(state is BillSuccess){

                      return state.paymentHistoryModel.data!/*.payments!*/.isEmpty ? const Center(child: Text('No Payments'))
                          : ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.paymentHistoryModel.data!/*billModel.payments!*/.length,
                            // itemCount: NewHomeApp.userBills['payments'].length,
                            itemBuilder: (context, int idx) {

                              // SharedPreferences pref = await SharedPreferences.getInstance();
                              // pref.setString('paymentId', state.paymentHistoryModel.data![idx].paymentId!)
                              return
                                Column(
                                  children: [
                                    // const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(/*horizontal: 16,*/vertical: 0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Constant.bgTile,
                                                borderRadius: BorderRadius.circular(12),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey.withOpacity(0.7),
                                                //     spreadRadius: 1,
                                                //     blurRadius: 1,
                                                //     offset: Offset(1, 1),
                                                //   )
                                                // ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          //  Text('Bill No. :'),
                                                          Text(state.paymentHistoryModel.data![idx].receiptNo.toString(),
                                                          // Text(state.billModel.payments![index].receiptNo!,
                                                          // Text(NewHomeApp.userBills['payments'][index]['receipt_no'],
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold
                                                          ),),
                                                        ],
                                                      ),
                                                      Text(state.paymentHistoryModel.data![idx].receiptDate!,
                                                      // Text(state.billModel.payments![index].receiptDate!,
                                                      // Text(NewHomeApp.userBills['payments'][index]['receipt_date'],
                                                        style: TextStyle(color: Colors.black/*Color(0xffABAFB8)*/ ),),
                                                    ],
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 2,
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Row(
                                                  //       children: [
                                                  //         const Text('Transaction : ',style: TextStyle(color: Color(0xffABAFB8)
                                                  //           ,),),
                                                  //         Text(state.paymentHistoryModel.data![idx].uniqueId!,
                                                  //         // Text(state.billModel.payments![index].uniqueId!,
                                                  //         // Text(NewHomeApp.userBills['payments'][index]['unique_id'],
                                                  //           style: const TextStyle(fontWeight: FontWeight.bold),),
                                                  //
                                                  //       ],
                                                  //     ),
                                                  //
                                                  //   ],
                                                  // ),

                                                  Row(

                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("₹ ${formatRentRange(state.paymentHistoryModel.data![idx].amount.toString())}",
                                                      // Text("₹ ${state.billModel.payments![index].amount}",
                                                      // Text("₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                        style: const TextStyle(color:Color(0xff67BA6C),
                                                          fontSize: 18
                                                      ),),
                                                      IconButton(
                                                        onPressed: () async {

                                                          // showDialog<String>(
                                                          //   context: context,
                                                          //   barrierDismissible: false,
                                                          //   barrierLabel: MaterialLocalizations.of(context)
                                                          //       .modalBarrierDismissLabel,
                                                          //   builder: (BuildContext context) => WillPopScope(
                                                          //     onWillPop: () async => false,
                                                          //     child: AlertDialog(
                                                          //       elevation: 0,
                                                          //       backgroundColor: Colors.transparent,
                                                          //       content: Container(
                                                          //         child: Image.asset(
                                                          //             'assets/images/loading_anim.gif'),
                                                          //         height: 100,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // );
                                                          print('fileUrl -- ${state.paymentHistoryModel.data![idx].receiptNo.toString()} - ${state.paymentHistoryModel.data![idx].receiptUrl.toString()}');

                                                          launchUrl(Uri.parse(state.paymentHistoryModel.data![idx].receiptUrl.toString()));
                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ShowPdf(state.paymentHistoryModel.data![idx].receiptUrl.toString())));
                                                          // await openFile(
                                                          //   url: state.paymentHistoryModel.data![idx].receiptUrl.toString(),
                                                          //   fileName:
                                                          //   "${DateTime.now().toString()+state.paymentHistoryModel.data![idx].receiptNo.toString()}-REC.pdf",
                                                          // );
                                                          // Navigator.of(context).pop();
                                                        },
                                                        icon: const Icon(Icons.file_download_outlined,size: 30,),
                                                        //color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: 5,),

                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const Text('Dues'),
                                                          Text(
                                                            "₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![idx].amount.toString())}",
                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),
                                                          ),

                                                        ],
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        children: [
                                                          const Text('Paid'),
                                                          Text("₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![idx].receivedAmount.toString())}",
                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),),

                                                        ],
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        children: [
                                                          const Text('Pending', style: TextStyle(color: Colors.red),),
                                                          Text("₹ ${formatRentRange(state.paymentHistoryModel.data/*billModel.payments*/![idx].pendingAmount.toString())}",
                                                            // "₹ ${NewHomeApp.userBills['payments'][index]['amount']}",
                                                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 14),),

                                                        ],
                                                      ),
                                                      const SizedBox(width: 20,),
                                                      Visibility(
                                                          visible: double.parse(state.paymentHistoryModel.data![idx].pendingAmount.toString()) > 1,
                                                          child: InkWell(
                                                              onTap: (){
                                                                /*UpdateReceiptsPayment();*/
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (context) {
                                                                    receiptNo.text = state.paymentHistoryModel.data![idx].receiptNo.toString();
                                                                    pending.text = state.paymentHistoryModel.data![idx].pendingAmount.toString();
                                                                    return Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      child: StatefulBuilder(
                                                                        builder: (context, setState) {
                                                                          return AlertDialog(
                                                                            insetPadding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
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
                                                                                            // labelStyle: TextStyle(fontSize: 20),
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
                                                                                      const SizedBox(height: 10,),
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
                                                                                      const SizedBox(height: 10,),
                                                                                      Visibility(
                                                                                        visible: selectMode == 'Cash',
                                                                                        child: TextFormField(
                                                                                          controller: receivedAmtController,
                                                                                          style: const TextStyle(fontSize: 14),
                                                                                          keyboardType: TextInputType.number,
                                                                                          decoration: InputDecoration(
                                                                                              labelStyle: const TextStyle(fontSize: 12,),
                                                                                              floatingLabelStyle: const TextStyle(fontSize: 16,),
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
                                                                                              if(double.parse(state.paymentHistoryModel.data![idx].pendingAmount!) < double.parse(value!)){
                                                                                                return 'Payment amount should not bigger than pending';
                                                                                              }else if(state.paymentHistoryModel.data![idx].pendingAmount! == null || double.parse(state.paymentHistoryModel.data![idx].pendingAmount!) < 0 || state.paymentHistoryModel.data![idx].pendingAmount.toString().isEmpty){
                                                                                                return 'Enter the amount';
                                                                                              }

                                                                                            }else{
                                                                                              return 'Enter the amount';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 10,),

                                                                                      // DropdownButtonFormField<String>(
                                                                                      //   value: selectedPayMode,
                                                                                      //
                                                                                      //   style: const TextStyle(fontSize: 14, color: Colors.black),
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
                                                                                      //     setState((){
                                                                                      //       print('transactionId -- ${transactionIdController.text.toString()}');
                                                                                      //     });
                                                                                      //   },
                                                                                      //   // showSearchBox: true,
                                                                                      // ),
                                                                                      TextFormField(
                                                                                        onTap: () async{
                                                                                          // _presentDatePicker();
                                                                                          final now = DateTime.now();
                                                                                          final firstDate = DateTime(now.year - 1, now.month, now.day);
                                                                                          DateTime? pickedDate = await showDatePicker(
                                                                                              context: context,
                                                                                              initialDate: now/*DateTime.now()*/,
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
                                                                                        onPressed: selectMode != 'Cash'
                                                                                            ? () async{
                                                                                          try {
                                                                                            var session = await createSession(state.paymentHistoryModel.data![idx].pendingAmount.toString());
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
                                                                                        child: Text(selectMode != 'Cash' ? 'Pay' : 'Submit', style: TextStyle(color: Colors.white),)),
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
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(Icons.receipt_long)))
                                                    ],
                                                  ),
                                                  /*const Divider(
                                              thickness: 1,
                                              color: Color(0xffD9E2FF
                                              ),
                                            )*/
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                            },
                                                ),
                                              ),
                          );
                    }
                    if(state is BillError){
                      return Center(child: Container(
                        child: Text(state.error),
                      ),);
                    }
                    return SizedBox();
                  },),
                ),
              )


            /*),*/
            ]
          ),
        ),
      ),
    );
  }

  Future<void> openFile({required String url, required String? fileName}) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final filex = File('${appStorage.path}/$fileName');
    if (await filex.exists()) {
      await filex.delete();
    }
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    print('Path : ${file.path}');

    OpenFilex.open(file.path);
  }

  Future<File?> downloadFile(String url, String? name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    // if (await file.exists()) {
    //   await file.delete();
    // }

    try {

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
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  // Future openFile({required String url, required String? fileName}) async {
  //   final file = await downloadFile(url, fileName);
  //   if (file == null) return;
  //   print('Path : ${file.path}');
  //
  //   OpenFilex.open(file.path);
  // }
  //
  // Future<File?> downloadFile(String url, String? name) async {
  //   final appstorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appstorage.path}/$name');
  //
  //   final response = await Dio().get(
  //     url,
  //     options: Options(
  //       responseType: ResponseType.bytes,
  //       followRedirects: false,
  //       receiveTimeout: 0,
  //     ),
  //   );
  //
  //   final raf = file.openSync(mode: FileMode.write);
  //   raf.writeFromSync(response.data);
  //   await raf.close();
  //
  //   return file;
  // }
}


/*Consumer<APIprovider>(
          builder: (context, apiprovider, child) => Container(
            height: MediaQuery.of(context).size.height,
            child:
            ListView.builder(
              itemCount: NewHomeApp.userBills['payments'].length,
              itemBuilder: (context, index) {
                return
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                            //  Text('Bill No. :'),
                              Text(NewHomeApp.userBills['payments'][index]
                                  ['receipt_no'],style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                          Text(NewHomeApp.userBills['payments'][index]
                              ['receipt_date'],style: TextStyle(color: Color(0xffABAFB8) ),),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('Transaction : ',style: TextStyle(color: Color(0xffABAFB8)
                              ,),),
                              Text(NewHomeApp.userBills['payments'][index]
                              ['unique_id'],style: const TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),

                        ],
                      ),

                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₹ ${NewHomeApp.userBills['payments'][index]
                          ['amount']}",style: const TextStyle(color:Color(0xff67BA6C),
                            fontSize: 18
                          ),),
                          IconButton(
                            onPressed: () async {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                builder: (BuildContext context) => WillPopScope(
                                  onWillPop: () async => false,
                                  child: AlertDialog(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    content: Container(
                                      child: Image.asset(
                                          'assets/images/loading_anim.gif'),
                                      height: 100,
                                    ),
                                  ),
                                ),
                              );
                              print(NewHomeApp.userBills['payments'][index]
                              ['url']
                                  .toString());
                              await openFile(
                                url: NewHomeApp.userBills['payments'][index]
                                ['url']
                                    .toString(),
                                fileName:
                                "${NewHomeApp.userBills['payments'][index]['receipt_no']}-${NewHomeApp.userBills['payments'][index]['receipt_date']}.pdf",
                              );
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.file_download_outlined,size: 30,),
                            //color: Colors.red,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0xffD9E2FF
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )*/