
import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());

// class LoginModel {
//   String? success;
//   String? details;
//
//
//   LoginModel({this.success, this.details});
//
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'].toString();
//     details = json['details'];
//
//   }
//
//   Map<String,dynamic> toJson(){
//    final Map<String,dynamic> data =new Map<String,dynamic>();
//    data['success']=this.success.toString();
//    data['details']=this.details;
//    return data;
//   }
// }

class LoginModel {
  String? loginId;
  String? mobileNo;
  String? name;
  String? emailId;
  String? branchId;
  String? tenantId;
  int? success;
  String? details;

  LoginModel(
      {this.loginId,
        this.mobileNo,
        this.name,
        this.emailId,
        this.branchId,
        this.tenantId,
        this.success,
        this.details});

  LoginModel.fromJson(Map<String, dynamic> json) {
    loginId = json['login_id'];
    mobileNo = json['mobile_no'];
    name = json['name'];
    emailId = json['email_id'];
    branchId = json['branch_id'].toString();
    tenantId = json['tenant_id'].toString();
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_id'] = this.loginId;
    data['mobile_no'] = this.mobileNo;
    data['name'] = this.name;
    data['email_id'] = this.emailId;
    data['branch_id'] = this.branchId;
    data['tenant_id'] = this.tenantId;
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}



/*class LoginModel {
  String? tenantId;
  String? mobileNo;
  String? name;
  String? emailId;
  String? tenantOnboarded;
  int? success;
  String? details;

  LoginModel(
      {this.tenantId,
        this.mobileNo,
        this.name,
        this.emailId,
        this.tenantOnboarded,
        this.success,
        this.details});

  LoginModel.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenant_id'];
    mobileNo = json['mobile_no'];
    name = json['name'];
    emailId = json['email_id'];
    tenantOnboarded = json['tenant_onboarded'];
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenant_id'] = this.tenantId;
    data['mobile_no'] = this.mobileNo;
    data['name'] = this.name;
    data['email_id'] = this.emailId;
    data['tenant_onboarded'] = this.tenantOnboarded;
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}*/




