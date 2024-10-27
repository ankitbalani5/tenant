import 'dart:convert';

InterestedOtpModel interestedOtpModelFromJson(String str) => InterestedOtpModel.fromJson(json.decode(str));
String interestedOtpModelToJson(InterestedOtpModel data) => json.encode(data.toJson());


class InterestedOtpModel {
  int? success;
  String? details;
  Data? data;

  InterestedOtpModel({this.success, this.details, this.data});

  InterestedOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? contact;

  Data({this.contact});

  Data.fromJson(Map<String, dynamic> json) {
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    return data;
  }
}

