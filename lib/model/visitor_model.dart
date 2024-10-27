class VisitorModel {
  int? success;
  String? details;
  List<Data>? data;

  VisitorModel({this.success, this.details, this.data});

  VisitorModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? branchId;
  String? resId;
  String? visitorName;
  String? visitDate;
  String? aadharNo;
  String? document;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.branchId,
        this.resId,
        this.visitorName,
        this.visitDate,
        this.aadharNo,
        this.document,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    resId = json['res_id'];
    visitorName = json['visitor_name'];
    visitDate = json['visit_date'];
    aadharNo = json['aadhar_no'];
    document = json['document'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['res_id'] = this.resId;
    data['visitor_name'] = this.visitorName;
    data['visit_date'] = this.visitDate;
    data['aadhar_no'] = this.aadharNo;
    data['document'] = this.document;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


/*
class VisitorModel {
  int? success;
  String? details;
  List<Visitor>? visitor;

  VisitorModel({this.success, this.details, this.visitor});

  VisitorModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      visitor = <Visitor>[];
      json['data'].forEach((v) {
        visitor!.add(new Visitor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    if (this.visitor != null) {
      data['data'] = this.visitor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Visitor {
  int? id;
  int? branchId;
  int? resId;
  String? visitorName;
  String? visitDate;
  String? aadharNo;
  String? document;
  String? status;
  String? createdAt;
  String? updatedAt;

  Visitor(
      {this.id,
        this.branchId,
        this.resId,
        this.visitorName,
        this.visitDate,
        this.aadharNo,
        this.document,
        this.status,
        this.createdAt,
        this.updatedAt});

  Visitor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    resId = json['res_id'];
    visitorName = json['visitor_name'];
    visitDate = json['visit_date'];
    aadharNo = json['aadhar_no'];
    document = json['document'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['res_id'] = this.resId;
    data['visitor_name'] = this.visitorName;
    data['visit_date'] = this.visitDate;
    data['aadhar_no'] = this.aadharNo;
    data['document'] = this.document;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
*/
