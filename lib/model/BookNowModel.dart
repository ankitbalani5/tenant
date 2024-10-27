import 'dart:convert';

BookNowModel bookNowModelFromJson(String str) => BookNowModel.fromJson(json.decode(str));
String bookNowModelToJson(BookNowModel data) => json.encode(data.toJson());

class BookNowModel {
  int? success;
  String? details;

  BookNowModel({this.success, this.details});

  BookNowModel.fromJson(Map<String, dynamic> json) {
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
