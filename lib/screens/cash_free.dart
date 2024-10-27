import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';
class CashFreePayment extends StatefulWidget {
  const CashFreePayment({super.key});

  @override
  State<CashFreePayment> createState() => _CashFreePaymentState();
}

class _CashFreePaymentState extends State<CashFreePayment> {
  CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();
  bool? isSuccess;

  @override
  void initState() {
    super.initState();
    // Attach events when payment is success and when error occured
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashfree Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6151FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: (){
                  sharePaymentLink("Mylink_share5").then((value)async{
                    var linkis = value['link_url'];
                    if(value['link_status'] == "ACTIVE"){
                      final result = await Share.share('Complete Your PG Room Payment ${linkis}', subject: 'Complete Your PG Room Payment!');

                    }
                  });
                },
                child: const Text("Share Payment Link",style: TextStyle(color: Colors.white),)),
            SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6151FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: pay,
                child: const Text("Pay",style: TextStyle(color: Colors.white),)),
            Text(
              "Payment Status $isSuccess",
              style: const TextStyle(fontSize: 20),
            )

          ],
        ),
      ),
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
  var intValue = Random().nextInt(10);

  String orderId = "my_order_id_test${Random().nextInt(100) + 50}";

  Future<CFSession?> createSession() async {
    try {
      final mySessionIDData = await createSessionID(orderId); // This will create session id from flutter itself
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


  pay() async {
    try {
      var session = await createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      // If you want to set paument mode to be shown to customer
      var paymentComponent =
      CFPaymentComponentBuilder().setComponents(components).build();
      // We will set theme of checkout session page like fonts, color
      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#6F6FE4")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
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

// webCheckout() async {
// try {
//	 var session = await createSession();
//	 var cfWebCheckout =
//		 CFWebCheckoutPaymentBuilder().setSession(session!).build();
//	 cfPaymentGatewayService.doPayment(cfWebCheckout);
// } on CFException catch (e) {
//	 print(e.message);
// }
// }
}

createSessionID(String orderID) async {
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
    "order_amount": 1, // Order Amount in Rupees
    // "order_id": orderID,
    "order_currency": "INR", // Currency of order like INR,USD
    "customer_details": {
      "customer_id": "customer_id", // Customer id
      "customer_name": "customer_name", // Name of customer
      "customer_email": "test114@gmail.com", // Email id of customer
      "customer_phone": "+914444366393" // Phone Number of customer
    },
    "order_meta": {"notify_url": "https://test.cashfree.com"},
    "order_note": "some order note here" // If you want to store something extra
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
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