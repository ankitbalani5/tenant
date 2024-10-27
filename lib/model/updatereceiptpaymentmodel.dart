import 'dart:convert';

UpdateReceiptPaymentModel updateReceiptPaymentModelFromJson(String str) => UpdateReceiptPaymentModel.fromJson(json.decode(str));
String updateReceiptPaymentModelToJson(UpdateReceiptPaymentModel data) => json.encode(data.toJson());


class UpdateReceiptPaymentModel {
  int? success;
  String? details;

  UpdateReceiptPaymentModel({this.success, this.details});

  UpdateReceiptPaymentModel.fromJson(Map<String, dynamic> json) {
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

