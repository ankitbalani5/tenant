
import 'dart:convert';

LogoutOtpTenantModel logoutOtpTenantModelFromJson(String str) => LogoutOtpTenantModel.fromJson(json.decode(str));
String logoutOtpTenantModelToJson(LogoutOtpTenantModel data) => json.encode(data.toJson());

class LogoutOtpTenantModel {
  LogoutOtpTenantModel({
      this.success, 
      this.details,});

  LogoutOtpTenantModel.fromJson(dynamic json) {
    success = json['success'];
    details = json['details'];
  }
  int? success;
  String? details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['details'] = details;
    return map;
  }

}