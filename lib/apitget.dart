import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:roomertenant/model/notification_model.dart';
import 'package:roomertenant/model/pdfquote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/terms_model.dart';

class API {

  static var userdata;
  static var asdf;
  static List<String> userdatalist = [];
  static List<String> userbilllist = [];

  //Main Url
  static String BaseUrl = "https://dashboard.btroomer.com/api/";

  //Test Url
  // static String BaseUrl = "https://testdashboard.btroomer.com/api/";

  static login(String phone, String password) async {
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantLogin'),
        body: {
          "phone": phone,
          "password": password,
        });
    // data here
    print(response.body.toString());
    return json.decode(response.body);
  }

  static user(String phone,String branch_id) async {
    userdatalist = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantHome'),
        body: {
          "phone": phone,
          "branch_id": branch_id,
        });
    // data here

    print("------**** User Data ******---------"+response.body.toString());
    API.userdata = json.decode(response.body);
    prefs.setString("branch_id", "${userdata['residents'][0]['branch_id']}");
    prefs.setString("user_id", "${userdata['residents'][0]['tenant_id']}");
    print(API.userdata['residents'].length);
    for (int i = 0; i < userdata['residents'].length; i++) {
      API.userdatalist.add(userdata['residents'][i]['resident_name']);
    }
    return json.decode(response.body);
  }

  static bill(userid) async {
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantPayments'),
        body: {
          "tenant_id": userid.toString(),
        });
    // print(json.decode(response.body)['payments']);
    return json.decode(response.body);
  }

  static complains(userid) async {
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantComplaintsView'),
        body: {
          "tenant_id": userid.toString(),
        });

    return json.decode(response.body);
  }

  static complainsupload(userid, description, headid) async {
    final response = await http.post(
        Uri.parse('${BaseUrl}tenantComplaintsCreate'),
        body: {
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
        Uri.parse('${BaseUrl}termspdf'),
        body: {
          "branch_id":branch_id.toString(),
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
  static Future <QuotationModel> quotationList() async {
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
      print("ResposneQuotation${jsonDecode(response.body)}");
      final result = jsonDecode(response.body);
      return QuotationModel.fromJson(result);
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
  static Future<NotificationModel> notificationList(String resident_id) async {
    final response = await http.post(Uri.parse('${BaseUrl}notification'),
        body: {
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
  static Future notificationRead(String notification_id) async {
    print("Step1");
    final response = await http.post(Uri.parse('${BaseUrl}readnotification'),
        body: {
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






}
