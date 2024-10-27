class ForgotPasswordModel {
  int? success;
  String? details;
  Data? data;

  ForgotPasswordModel({this.success, this.details, this.data});

  ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
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
  String? tenantId;

  Data({this.contact, this.tenantId});

  Data.fromJson(Map<String, dynamic> json) {
    contact = json['contact'];
    tenantId = json['tenant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['tenant_id'] = this.tenantId;
    return data;
  }
}
