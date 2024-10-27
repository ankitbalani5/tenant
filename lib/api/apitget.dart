import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:roomertenant/model/ExploreModel.dart';
import 'package:roomertenant/model/NoticePeriodHistoryModel.dart';
import 'package:roomertenant/model/TenantRatingModel.dart';
import 'package:roomertenant/model/aadhar_url_model.dart';
import 'package:roomertenant/model/addwishlist_model.dart';
import 'package:roomertenant/model/bill_model.dart';
import 'package:roomertenant/model/complain_model.dart';
import 'package:roomertenant/model/email_model.dart';
import 'package:roomertenant/model/eqaro_model.dart';
import 'package:roomertenant/model/get_wishlist_model.dart';
import 'package:roomertenant/model/login_model.dart';
import 'package:roomertenant/model/logoutOtpTenant.dart';
import 'package:roomertenant/model/notification_model.dart';
import 'package:roomertenant/model/otp_generate_mail_model.dart';
import 'package:roomertenant/model/payment_history_model.dart';
import 'package:roomertenant/model/pdfquote_model.dart';
import 'package:roomertenant/model/requested_pg_model.dart';
import 'package:roomertenant/model/review_model.dart';
import 'package:roomertenant/model/user_model.dart';
import 'package:roomertenant/model/visitor_model.dart';
import 'package:roomertenant/screens/eligibility_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/BookNowModel.dart';
import '../model/InterestedModel.dart';
import '../model/check_eligibility_model.dart';
// import '../model/country_state_list.dart';
import '../model/forgot_password_model.dart';
import '../model/getMessageChatModel.dart';
import '../model/terms_model.dart';
import '../utils/common.dart';

class API {

  static var userdata;
  static var asdf;
  static List<Residents> userdatalist = [];
  static List<String> userbilllist = [];
  static var _identifier="";
  //Main Urlz
  static String BaseUrl = "https://dashboard.btroomer.com/api/";
  // static String BaseUrl1 = "https://dashboard.btroomer.com/API/";
  static String BaseUrl2 = "https://mydashboard.btroomer.com/API/tenant_api/";
  // static String BASEURL = "https://mydashboard.btroomer.com/";
  //Test Url
  //static String BaseUrl = "https://testdashboard.btroomer.com/api/";

  static Future<LoginModel?>login(String phone, String password,
      String imei_no, String device_id, String ip_address,
      String carrier_name, String app_version, String phone_model,
      String phone_manufacturer, String sdk_phone_version
      ) async {
    print('token:----$device_id');
    final response = await http.post(
        Uri.parse('${BaseUrl2}tenantLogin.php'),
        body: {
          "mobile_no": phone,
          "password": password,
          "imei_no": imei_no,
          "device_id": device_id,
          "ip_address": ip_address,
          "carrier_name": carrier_name,
          "app_version": app_version,
          'phone_model': phone_model,
          'phone_manufacturer': phone_manufacturer,
          'sdk_phone_version': sdk_phone_version,
          /*'imei_no': uniqueIdentifier,*/
        });


    // data here
    print(response.body.toString());
    return loginModelFromJson(response.body);
  }


  static user(String phone,String branch_id) async {
      userdatalist = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/getHome.php'),
      //  Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/getHomeTest.php'),
      //   Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/getHomeTest.php'),
        body: {
          "phone": phone,
          "branch_id": branch_id,
        });
    // data here

    print("------**** User Data ******---------"+response.body.toString());
    API.userdata = json.decode(response.body);
    prefs.setString("branch_id", "${userdata['residents'][0]['branch_id']}");
    prefs.setString("user_id", "${userdata['residents'][0]['tenant_id']}");
    prefs.setString("unique_id", "${userdata['residents'][0]['tenant_id']}");
    print(API.userdata['residents'].length);


      print("Login : ${_identifier}");


      // final jsonString = response.body;
      final jsonString = jsonDecode(response.body);



    return UserModel.fromJson(jsonString)/*userModelFromJson(jsonString)*/;
  }

  static Future visitHistory(String branch_id, String tenant_id, String imei_no, String ip_address, String latitude, String longitude, String address) async{
    final response = await http.post(Uri.parse('${BaseUrl2}insertTenantAction.php'),
      body: {
      'action_for': 'Search History',
      'branch_id': branch_id,
      'tenant_id': tenant_id,
      'imei_no': imei_no,
        'ip_address': ip_address,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return jsonString;
    }else {
      throw Exception('Failed to make Search History');
    }
  }

  static Future<AddWishlistModel> addWishlist(String branch_id, String tenant_id, String imei_no, String ip_address, String latitude, String longitude, String address) async{
    final response = await http.post(Uri.parse('${BaseUrl2}insertTenantAction.php'),
        body: {
          'action_for': 'Wishlist',
          'branch_id': branch_id,
          'tenant_id': tenant_id,
          'imei_no': imei_no,
          'ip_address': ip_address,
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
        }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return AddWishlistModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to make Search History');
    }
  }

  static Future<GetWishlistModel> getWishlist(String branch_id, String imei_no, String tenant_id) async{
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/API/tenant_api/getWishlist.php'),
        body: {
          'action_for': 'Wishlist',
          'branch_id': branch_id,
          'imei_no': imei_no,
          'tenant_id': tenant_id,
        }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return GetWishlistModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to show wishlist');
    }
  }

  static Future ratingApi (String rating, String description,
      String branch_id, String res_id, String login_id
  ) async{
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
      body: {
        'type': 'tenantRateBranch',
        'rating': rating,
        'description': description,
        'branch_id': branch_id,
        'res_id': res_id,
        'login_id': login_id

        }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return jsonString;
    }else{
      Exception('Failed to submit');
    }
  }

  static Future<ReviewModel?> reviewApi (String branch_id) async{
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
      body: {
        'type': 'getBranchRatingList',
        'branch_id': branch_id

      }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return ReviewModel.fromJson(jsonString);
    }else{
      Exception('Failed to load review');
    }
  }

  static Future sendMessageChat (String login_id, String branch_id, String msg, String tenant_name) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
        body: {
        'type':'sendChatMsgAndNotifications',
        'login_id': login_id,
        'branch_id': branch_id,
        'msg': msg,
          'tenant_name': tenant_name
        }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return jsonString;
    }else {
      throw Exception('Failed to send message');
    }
  }

  static Future getMessageChat (String login_id, String branch_id) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
        body: {
        'type':'getChatMsgList',
        'login_id': login_id,
        'branch_id': branch_id,
        }
    );
    if(response.statusCode == 200){
      print(response.body);
      final jsonString = json.decode(response.body);
      return GetMessageChatModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to send message');
    }
  }

  static Future<RequestedPgModel?> requestedPg(String mobile_no) async{
    final response = await http.post(
      Uri.parse('${BaseUrl2}requestedPGList.php'),
      body: {
        'mobile_no': mobile_no,
      }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print('jsonString: ${jsonString.toString()}');
      return RequestedPgModel.fromJson(jsonString);
    }
  }

  static Future<OtpGenerateMailModel> otpGenerationMail(String token, String email) async{
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/verify/generateotponmail'),
        headers: {
          'Authorization': 'Bearer $token',
          // HttpHeaders.authorizationHeader: token,
        },
        body: {
          'email': email
        });
    if(response.statusCode == 200){
      print('email verify----${response.body}');
      final jsonString = json.decode(response.body);
      return OtpGenerateMailModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to otp generate user');
    }

  }

  static Future panvalidate(String token, String panNo) async{
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/pan/validate'),
        headers: {
          'Authorization': 'Bearer $token',
          // HttpHeaders.authorizationHeader: token,
        },
        body: {
          'panNo': panNo
        });
    if(response.statusCode == 200){
      //print('panNo verify----${response.body}');
      final jsonString = jsonDecode(response.body);
      // final Map<String, dynamic> reponseresult = json.decode(response.body);
      return jsonString;
      // return reponseresult['status'];
    }else {
      throw Exception('Failed to verify panNo');
    }

  }

  static Future<CheckEligibilityModel> checkEligibility(String token, String id) async{
    print(id);
    final response = await http.get(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/eligibility/check/${id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode == 200){
      print('check eligibility---${response.body}');
      final jsonString = json.decode(response.body);
      return CheckEligibilityModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to check eligibility');
    }
  }


  static Future initiatePayment(String token, String tenantId, String propertyId, int bondAmount, String bondEffectiveDate) async {
    try {
      // Construct the request body as a Map
      Map<String, dynamic> body = {
        'tenantId': tenantId,
        'propertyId': propertyId,
        'bondAmount': bondAmount,
        'type': 'buy_bond',
        'source': 'postpaid',
        'bondEffectiveDate': bondEffectiveDate
      };

      print(json.encode(body));

      final response = await http.post(
        Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/paymentGateway/initiate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',

        },
        // Convert the request body to a JSON string
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('initial Payment---${response.body}');
        final jsonString = json.decode(response.body);
        return jsonString;
      } else {
        print('Failed to initiate payment: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to initiate payment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error initiating payment: $error');
      throw Exception('Failed to initiate payment');
    }
  }

  static Future paymentComplete(String token, String tenantId, String eqaroOrderId, String bondEffectiveDate) async {

    Map<String, dynamic> body = {
      'tenantId': tenantId,
      'eqaroOrderId': eqaroOrderId,
      'bondEffectiveDate': bondEffectiveDate,
    };
    print(json.encode(body));

    try {
      final response = await http.post(
        Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/payment/complete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',

        },
        body: json.encode(body),

      );

      if (response.statusCode == 200) {
        print('Payment complete: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Error in payment: ${response.body}');
        throw Exception('Failed to complete payment'); // Updated error message
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to complete payment: $e'); // Updated error message
    }
  }



/*
  static Future paymentComplete(String token, String tenantId, String eqaroOrderId, String bondEffectiveDate) async{

    // List<Map<String, dynamic>> body = {
    //     'tenantId': tenantId,
    //     'eqaroOrderId': eqaroOrderId,
    //     'bondEffectiveDate': bondEffectiveDate
    //   };

    //print(json.encode(body));
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/payment/complete'),
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',

          // HttpHeaders.authorizationHeader: token,
        },
      body: {
      'tenantId': tenantId,
      'eqaroOrderId': eqaroOrderId,
      'bondEffectiveDate': bondEffectiveDate
      },
    );
    if(response.statusCode == 200){
      print('payment complete---${response.body}');
      final jsonString = json.decode(response.body);
      return jsonString;
    }else {
      print('error payment---${response.body}');
      throw Exception('Failed to login user');
    }
  }
*/

  static Future getBondByTenantId(String token, String id) async{
    print("Bond ID==${id}");
    final response = await http.get(Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/bond/tenant/${id}'),
      headers: {
        'Authorization': 'Bearer $token',
        // HttpHeaders.authorizationHeader: token,
      },
    );
    if(response.statusCode == 200){
      print('get bond by tenant Id---${response.body}');
      final jsonString = json.decode(response.body);
      return jsonString;
    }else {
      throw Exception('error to get bond by tenant Id');
    }
  }

  static Future generateBondPDF(String token, String bondId) async{
    print("bondId====${bondId}");
    final response = await http.get(Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/generate/bond/pdf?bondId=${bondId}'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/pdf"
        // HttpHeaders.authorizationHeader: token,
      },
    );
    if(response.statusCode == 200){
      print('generate bond pdf---${response.body}');
      // final jsonString = json.decode(response.body);
      final jsonString = await json.decode(json.encode(response.body));
      return jsonString;
    }else {
      throw Exception('Failed to generate bond pdf');
    }
  }

  static Future releaseBond(String token, String bondId) async{
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/payment/v1/bond/release'),
        headers: {
          'Authorization': 'Bearer $token',
          // HttpHeaders.authorizationHeader: token,
        },
        body: {
          'bondId': bondId
        }
    );
    if(response.statusCode == 200){
      print('release bond---${response.body}');
      final jsonString = json.decode(response.body);
      return ;
    }else {
      throw Exception('Failed to release Bond ');
    }
  }

  static Future docuplodeeqro(String token, String panNo) async{
    print("::::::::::::::::::::::Uplode Docume run:::::::::::::::::::::::");
    print(token);

    final Map<String, dynamic> uplodedocData = {
      'docs': [
        {
          'docType': 'pan',
          'docId': panNo,
          'docUrl': 'url',
          'isVerified': true
        }

      ]
    };
    print(jsonEncode(uplodedocData));
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/users/upload/docs'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',

          // HttpHeaders.authorizationHeader: token,
        },
        body: jsonEncode(uplodedocData),);
    if(response.statusCode == 200){
      print('panNo uplode docs----${response.body}');
      final jsonString = jsonDecode(response.body);
      return jsonString;
    }else {
      throw Exception('Failed to panNo uplode docs');
    }

  }

  static Future<EqaroModel> eqaro(String branch_id, String res_id, String pg_id) async{
    final response = await http.post(Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/eqaro_fun.php'),
      body: {
        'type': 'residentEqaroData',
        'branch_id': branch_id,
        'res_id': res_id,
        'pg_id': pg_id
      }
    );
    if(response.statusCode == 200){
      print('eqaro---${response.body}');
      final jsonString = jsonDecode(response.body);
      return EqaroModel.fromJson(jsonString);
    }else {
      throw Exception('Something went wrong!');
    }
  }

  static Future<EmailModel> emailVerifyApi(String token, String email, String code) async{
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/verify/verifyotponmail'),
        headers: {
          'Authorization': 'Bearer $token',
          //'Content-Type': 'application/json',

        },
        body: {
          'email': email,
          'code': code,
          'isWorkEmail': true.toString()
        });
    if(response.statusCode == 200){
      print('email verify----${response.body}');
      final jsonString = json.decode(response.body);
      return EmailModel.fromJson(jsonString);
    }else {
      throw Exception('Failed to login user');
    }

  }

  /*static Future aadharVerification(String res_id, String auth_token, String branch_id, String pg_id) async{
    final response = await http.post(Uri.parse(uri),
      body: {
        'type': 'aadharVerification',
        'res_id': res_id,
        'auth_token': auth_token,
        'branch_id': branch_id,
        'pg_id': pg_id
      }
    );

  }*/
  
  static Future updateUser(String token, String name, String phone, String dob, String gender, String occupation,
      double monthlyIncome, String workEmail, String id) async{
    print(":::::::::::::::");


    print(token.toString());
    print(id.toString());
    final Map<String, dynamic> userData  = {
        'name': name,
        'phone': "${phone}",
        'dob': dob,
        'gender': gender.toLowerCase(),
        'employmentDetails': {
          'employment': occupation,
          'monthlyIncome': monthlyIncome,
          'monthlyIncome': monthlyIncome,
          'workEmail': workEmail,
        },
      };

    print("::::::::::::::::Response body Submited:::::::::::::::::::::");
    print(jsonEncode(userData));
    try{
      final response = await http.patch( Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/users/${id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },

      body: jsonEncode(userData),
    );
    if(response.statusCode == 200){
      print('update data---${response.body}');
      Fluttertoast.showToast(
        msg: "Succesfully Done!",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 8,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 13.0,
      );
      final jsonString = json.decode(response.body);
      finalsubmit();
      return response.statusCode.toString();
    }
    else if(response.statusCode == 403){

      print('You are already Verified');

      Fluttertoast.showToast(
        msg: "You are already Verified",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 8,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 13.0,
      );
      return response.statusCode.toString();


    }
    else {
      print('update user Error response---${response.body}');
      final jsonString = json.decode(response.body);

      Fluttertoast.showToast(
        msg: jsonString['message'],
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 8,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0,
      );

      throw Exception('Failed to login user else part');
    }
    }catch (e) {
      print('Error: $e');
      // Handle the error as needed
    }

  }

 static Future finalsubmit()async{
    SharedPreferences pref= await SharedPreferences.getInstance();

    String branch_id = pref.getString('branch_id').toString();
    String res_id = pref.getString('tenant_id').toString();
    String pg_id = pref.getString('pg_id').toString();

     final response = await http.post(
          Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/eqaro_fun.php'),
          body: {
            "type":"residentEqaroFinalVerification",
            "pg_id": pg_id,
            "branch_id": branch_id,
            "res_id": res_id

          });
      if(response.statusCode == 200){
        final jsonStringdata = json.decode(response.body);
        print("full data submited");

        return jsonStringdata;
      }
  }

  static Future getEAadhaar(String token, String requestId, BuildContext context, String branch_id, String tenantId) async{
    final response = await http.post(Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/adhaar/getadhar'),
        headers: {
          'Authorization': 'Bearer $token',
          // HttpHeaders.authorizationHeader: token,
        },
      body: {
        'requestId': requestId
      }
    );
    if(response.statusCode == 200){
      print('get E Aadhaar--- ${response.body}');
      final jsonString = json.decode(response.body);
      print('get E Aadhar response--- ${jsonString}');
      API.aadharVerifiedFlag(branch_id, tenantId).then((value) {

      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EligibilityForm()), (route) => false);

      // return
    }else {
      print('get E Aadhaar--- ${response.body}');
      throw Exception('Failed to login user');
    }
  }

  static Future aadharVerifiedFlag(String branch_id, String tenantId) async{
    final response = await http.post(Uri.parse('https://Mydashboard.btroomer.com/API/tenant_api/eqaro_fun.php'),
        body: {
        'type': 'aadharVerifyEnable',
        'res_id': tenantId,
        'branch_id': branch_id
        }
    );
    if(response.statusCode == 200){
      print('get E Aadhaar--- ${response.body}');
      final jsonString = json.decode(response.body);
      print('get E Aadhar response--- ${jsonString}');

      // return
    }else {
      print('get E Aadhaar--- ${response.body}');
      throw Exception('Failed to login user');
    }
  }

  static Future<AadharUrlModel> verifyAadhar(String token) async{
    final response = await http.post(
        Uri.parse('https://api-staging.eqaroguarantees.com/user/v1/adhaar/generateurl'),
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
          // HttpHeaders.authorizationHeader: token,
        },
        body: {
          'redirect_url': 'https://mydashboard.btroomer.com/API/eqaro.php'
        });
    if(response.statusCode == 200){
      print('aadhar verify response ----- ${response.body}');
      final jsonString = json.decode(response.body);
      return AadharUrlModel.fromJson(jsonString);
      
    }else {
      throw Exception('Failed to redirect_url');
    }
  }
  
  static logoutOtpTenant(String tenant_id) async{
    final response = await http.post(
      Uri.parse('${BaseUrl2}tenantLogout.php'),
      body: {
        'tenant_id': tenant_id,
      }
    );
    if (response.statusCode == 200) {
      final jsonString = json.decode(response.body);
      print("jsonString : ${jsonString.toString()}");
      return LogoutOtpTenantModel.fromJson(jsonString);
    }
  }

  static Future<TenantRatingModel> tenantRating (String tenant_contact) async{
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/API/resident_api.php'),
      body: {
        'type': 'getTenantRatingList',
        'tenant_contact': tenant_contact
        }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print(jsonString);
      return TenantRatingModel.fromJson(jsonString);
    }else{
      throw Exception();
    }
  }

  static changePassword(String tenant_id, String password) async {
    final response = await http.post(
        Uri.parse('${BaseUrl2}passwordChange.php'),
        body: {
          'tenant_id': tenant_id,
          'password': password
        }
    );
    if (response.statusCode == 200) {
      final jsonString = json.decode(response.body);
      print("jsonString : ${jsonString.toString()}");
      return jsonString;
    }
  }

  static Future<ExploreModel> explore(String mobile_no) async{
    final response = await http.post(
      Uri.parse('${BaseUrl2}propertyListing.php'),
      body: {
        'mobile_no': mobile_no,
      }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print("jsonString : ${jsonString.toString()}");
      return ExploreModel.fromJson(jsonString);
    }else {
      throw Exception();
    }
  }


  // static Future shareLinkApi(String branchId, String pgId, String number) async {
  //   print("BranchId : ${branchId} PGID : ${pgId} Number : ${number}");
  //
  //   var response = await http.post(Uri.parse("${BASEURL}includes/function.php"), body: {
  //     "type": "registrationFormLisk",
  //     "branch_id": branchId,
  //     "pg_id": pgId,
  //     "whatsapp_no": number,
  //   });
  //   var dataResponse = jsonDecode(response.body);
  //
  //   print("DataResponse : ${dataResponse.toString()}");
  //
  //   if (response.statusCode == 200) {
  //
  //     return dataResponse;
  //   }
  //   return dataResponse;
  // }

  static Future interested(String type, String phone) async{
    print("Type : ${type} Phone : ${phone}");

    // Map<String, dynamic> body ={
    //   'type': type,
    //   'phone': phone,
    // };
    final response = await http.post(
      Uri.parse('${BaseUrl2}otpVerify.php'),
        body: {
          "type": type,
          "mobile_no": phone,
        });
    print("object${response.body}");
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print("Response: ${jsonString}");
      return InterestedModel.fromJson(jsonString);
    }else {
      throw Exception();
    }
  }

  static Future interestedOtp(String type, String mobile_no, String otp_no) async{
    final response = await http.post(
        Uri.parse('${BaseUrl2}otpVerify.php'),
        body: {
          "type": type,
          "mobile_no": mobile_no,
          "otp_no": otp_no
        });
    print("object${response.body}");
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print("Response: ${jsonString}");
      return jsonString;
    }else {
      throw Exception();
    }
  }

  static noticePeriod(String branch_id, String resident_id, String user_id, String start_date, String end_date) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
      body: {
        'type': 'tenantNoticePeriod',
        'branch_id': branch_id,
        'resident_id': resident_id,
        'user_id': user_id,
        'start_date': start_date,
        'end_date': end_date

      }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print('Response: ${jsonString}');
      return jsonString;
    }else{
      throw Exception();
    }
  }

  static Future<NoticePeriodHistoryModel> noticePeriodHistory(String branch_id, String res_id) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),
        body: {
          'type': 'tenantNoticeData',
          'branch_id': branch_id,
          'res_id': res_id,
        }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print('Response: ${jsonString}');
      return NoticePeriodHistoryModel.fromJson(jsonString);
    }else{
      throw Exception();
    }
  }

  static Future registerTenant(String type, String name, String email, String mobile_no) async{
    final response = await http.post(
        Uri.parse('https://mydashboard.btroomer.com/api.php'),
        body: {
          "type": 'tenant_register',
          "name": name,
          "email": email,
          "mobile_no": mobile_no,
        });
    print("object${response.body}");
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print("Response: ${jsonString}");
      return /*BookNowModel.fromJson(*/jsonString/*)*/;
    }else {
      throw Exception();
    }
  }
  
  static Future<ForgotPasswordModel> forgotPassword(String mobile_no) async{
    final response = await http.post(Uri.parse('${BaseUrl2}forgotPassword.php'),
      body: {
        'mobile_no': mobile_no,
        'type': 'otpSend'
      }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print(jsonString);
      return ForgotPasswordModel.fromJson(jsonString);
    }else{
      throw Exception();
    }
  }

  static Future bookNow(String name, String email, String mobile_no, String message, String bdid) async{
    final response = await http.post(
      Uri.parse('${BaseUrl2}bookNow.php'),
        body: {
          "name": name,
          "email": email,
          "mobile_no": mobile_no,
          "message": message,
          "bdid": bdid,
        });
    print("object${response.body}");
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      print("Response: ${jsonString}");
      return /*BookNowModel.fromJson(*/jsonString/*)*/;
    }else {
      throw Exception();
    }
  }

  static Future updatepaymentreceipts(String type, String branch_id,
      tenant_id, String transaction_amount, String pay_mode,
      String payment_transaction_date, String payment_transation_id,
      String transaction_remark, String payment_id) async{
    // Map<String, dynamic> body = {
    //
    // };
    // print("BodyValue : ${body.toString()}");

    final response = await http.post(
      Uri.parse('https://mydashboard.btroomer.com/API/payment_api.php'),
      body: {
        'type': type,
        'branch_id': branch_id,
        'tenant_id': tenant_id,
        'transaction_amount': transaction_amount,
        'pay_mode': pay_mode,
        'payment_transaction_date': payment_transaction_date,
        'payment_transation_id': payment_transation_id,
        'transaction_remark': transaction_remark,
        'payment_id': payment_id
      }
    );
    if(response.statusCode == 200){
      final jsonString = json.decode(response.body);
      return jsonString;
    }
  }

  
  static paymenthistory(String type, String branch_id,
      String resident_id, String payment_from, String payment_to) async{
    Map<String, dynamic> body = {
      'type': type,
      'branch_id': branch_id,
      'resident_id': resident_id,
      'payment_from': payment_from,
      'payment_to': payment_to
    };
    final response = await http.post(
      Uri.parse('https://mydashboard.btroomer.com/API/payment_api.php'),
      body: body
    );
    if(response.statusCode == 200){
      String? jsonString = response.body;
      return paymentHistoryModelFromJson(jsonString);
    }
  }

  // static bill(userid) async {
  //   final response = await http.post(
  //       Uri.parse('${BaseUrl}tenantPayments'),
  //       body: {
  //         "tenant_id": userid.toString(),
  //       });
  //   if (response.statusCode == 200) {
  //     // print(json.decode(response.body)['payments']);
  //     String? jsonString = response.body;
  //     return billModelFromJson(jsonString);
  //   }else{
  //     // throw Exception(response.reasonPhrase);
  //   }
  //
  // }

  // tenantComplaintsView
  static complains(userid) async {
    final response = await http.post(
        Uri.parse('${BaseUrl2}complaints.php'),
        body: {
          "type": 'tenantComplaintsView',
          "tenant_id": userid.toString(),
        });
    String? jsonString = response.body;
    return complainModelFromJson(jsonString);
  }

  static complainsupload(userid, description, headid) async {
    final response = await http.post(
        Uri.parse('${BaseUrl2}complaints.php'),
        body: {
          "type": 'tenantComplaintsCreate',
          "tenant_id": userid.toString(),
          "description": description.toString(),
          "head_id": headid.toString(),
        });
    asdf = json.decode(response.body);
    // print(asdf);
    return json.decode(response.body);
  }

  static downloadTermsandconditionPdfApi(String branch_id) async {
    final response = await http.post(
        Uri.parse('https://mydashboard.btroomer.com/api.php'),/*${BaseUrl}termspdf*/
        body: {
          "branch_id":branch_id.toString(),
          'type':'termspdf'

        });
     // asdf = json.decode(response.body);
   print(response.body.toString());
   return termsModelFromJson(response.body);
   // return json.decode(response.body);
  }

  static Future complaintsStatusUpdateApi(String branch_id, String user_id,String status,
      String complain_id, String remark, String follow_date ) async {
      final response = await http.post(
        Uri.parse('${BaseUrl}tenantComplaintsUpdateStatus'),
        body: {
          "branch_id":branch_id,
          "user_id":user_id,
          "status":status,
          "complain_id":complain_id,
          "remark":remark,
          "follow_date":follow_date
        });
    // asdf = json.decode(response.body);
    print(response.body.toString());
    return json.decode(response.body);
    // return json.decode(response.body);
  }

  /*static Future logoutTenant(String branch_id, String user_id) async {
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantComplaintsUpdateStatus'),
        body: {
          "branch_id":branch_id,
          "user_id":user_id,

        });
    // asdf = json.decode(response.body);
    print(response.body.toString());
    return json.decode(response.body);
    // return json.decode(response.body);
  }*/


  Future <QuotationModel> quotationList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String branch_id = await prefs.getString("branch_id").toString();
    final residentId = prefs.getString('id');
    final response = await http.post(
        Uri.parse('${BaseUrl}PdfQuoteReciept'),
        body: {
          'resident_id': residentId,
          'branch_id': branch_id,
        });
    if (response.statusCode == 200) {
      print("ResposneEnquiries${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return QuotationModel.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future <VisitorModel> getVisitors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String branch_id = await prefs.getString("branch_id").toString();
    final residentId = prefs.getString('tenant_id');
    final response = await http.post(
        Uri.parse('https://mydashboard.btroomer.com/API/custom_notification_func.php'),
        // Uri.parse('${BaseUrl}getVisitors'),
        body: {
          'type': 'getVisitors',
          'tenant_id': residentId,
          'branch_id': branch_id,
        });
    if (response.statusCode == 200) {
      print("ResposneVisitors${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return VisitorModel.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  static Future sendScreenShotImg(String branch_id, String res_id,String remark,File file,String qtc_id,
      BuildContext context,) async {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding: EdgeInsets.all(24),
          insetPadding: EdgeInsets.symmetric(horizontal: 165),
          content: Container(
            //  color: Colors.transparent,
              height: 35,
              width: 35,
              child: CircularProgressIndicator()),
        ));

    var postUri = Uri.parse('${BaseUrl}rentScreenShortImgData');

    var request = http.MultipartRequest("POST", postUri);
    try {
      request.files.add(await http.MultipartFile.fromPath('screen_shot', file.path));
    } on Exception catch (_) {
      request.fields['screen_shot'] = '';
    }
    request.fields['branch_id'] = branch_id;
    request.fields['res_id'] = res_id;
    request.fields['remark'] = remark;
    request.fields['qtc_id'] = qtc_id;
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("######## UploadScreenshot" + responseData.toString());
    }
    return responseData;
  }
  static Future visitorData(
      String branchId,
      String tenantId,
      String visitorName,
      String visitDate,
      String AadhaaarNumber,
      String discription,
      String file,
      BuildContext context,) async {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding: EdgeInsets.all(24),
          insetPadding: EdgeInsets.symmetric(horizontal: 165),
          content: Container(
            //  color: Colors.transparent,
              height: 35,
              width: 35,
              child: CircularProgressIndicator()),
        ));

    // var postUri = Uri.parse('${BaseUrl}addVisitors');
    var postUri = Uri.parse('https://mydashboard.btroomer.com/API/custom_notification_func.php');

    var request = http.MultipartRequest("POST", postUri);
    try {
      request.files.add(await http.MultipartFile.fromPath('document', file));
    } on Exception catch (_) {
      request.fields['document'] = '';
    }
    request.fields['branch_id'] = branchId;
    request.fields['type'] = 'Addvisitors';
    request.fields['resident_id'] = tenantId;
    request.fields['visitor_name'] = visitorName;
    request.fields['visit_date'] = visitDate;
    request.fields['aadhar_no'] = AadhaaarNumber;
    request.fields['discription'] = discription;
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("VisitorData" + responseData.toString());
    }
    return responseData;
  }


  static Future<NotificationModel> notificationList(String resident_id) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),/*${BaseUrl}notification*/
        body: {
          'type': 'getAllNotificationList',
          'resident_id': resident_id,
        }
    );
    if (response.statusCode == 200) {
      print("Resposnenodification${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return NotificationModel.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future readNotification(String notification_id) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),/*${BaseUrl2}readnotification*/
        body: {
          'type': 'readNotification',
          'notification_id': notification_id,
        }
    );
    if (response.statusCode == 200) {
      print("readnotification${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<NotificationModel> clearNotificationdata(String tenant_id) async {
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),/*${BaseUrl2}readnotification*/
        body: {
          'type': 'clearNotificationdata',
          'tenant_id': tenant_id,
        }
    );
    if (response.statusCode == 200) {
      print("readnotification${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return NotificationModel.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // static Future notificationRead(String notification_id) async {
  //   final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/api.php'),/*${BaseUrl2}readnotification*/
  //       body: {
  //         'type': 'readNotificationdata',
  //         'notification_id': notification_id,
  //       }
  //   );
  //   if (response.statusCode == 200) {
  //     print("readnotification${jsonDecode(response.body)}");
  //     final result = jsonDecode(response.body);
  //     return result;
  //   } else {
  //     throw Exception(response.reasonPhrase);
  //   }
  // }

  static Future removeVisitor(String visitor_id, BuildContext context) async {
    // final response = await http.post(Uri.parse('${BaseUrl}updateVisistorStatus'),
    final response = await http.post(Uri.parse('https://mydashboard.btroomer.com/API/custom_notification_func.php'),
        body: {
          'type': 'updateVisistorStatus',
          'visitor_id': visitor_id,
        }
    );
    if (response.statusCode == 200) {
      print("VisitorRemove${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  // static Future<NotificationModel> approvedList(String resident_id) async {
  //   final response = await http.post(Uri.parse('${BaseUrl}notification'),
  //       body: {
  //         'resident_id': resident_id,
  //       }
  //   );
  //   if (response.statusCode == 200) {
  //     print("Resposnenodification${jsonDecode(response.body)}");
  //     final result = jsonDecode(response.body);
  //     return NotificationModel.fromJson(result);
  //   } else {
  //     throw Exception(response.reasonPhrase);
  //   }
  // }

  // static changePasswordApi(BuildContext context, String branchId, String userId, String cPassword, String nPassword) async{
  //  /* ProgressDialog pd = ProgressDialog(context: context);
  //   pd.show(max: 100, msg: 'Please Wait...');*/
  //   print("branch Id : ${branchId}  User Id : ${userId}");
  //   var response = await http.post(Uri.parse("${BaseUrl}changeTenantPass"),
  //       body: {"branch_id": branchId, "user_id": userId, "old_pass": cPassword, "new_pass": nPassword});
  //   if (response.statusCode == 200) {
  //     print("Response of Change Password: " + response.body);
  //     var responseData = jsonDecode(response.body);
  //     if (responseData['status'].toString() == '1') {
  //       print("Response Data of Change Password: " + responseData.toString());
  //     }
  //   } else {
  //     print("Error Found");
  //   }
  //   return json.decode(response.body);
  // }
}
