import 'dart:convert';

InterestedModel interestedModelFromJson(String str) => InterestedModel.fromJson(json.decode(str));
String interestedModelToJson(InterestedModel data) => json.encode(data.toJson());


class InterestedModel {
  int? success;
  String? details;


  InterestedModel({this.success, this.details});

  InterestedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;

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


