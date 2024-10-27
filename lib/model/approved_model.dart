class ApprovedModel {
  String? s0;
  bool? result;
  List<Details>? details;

  ApprovedModel({this.s0, this.result, this.details});

  ApprovedModel.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    result = json['result'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['result'] = this.result;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  int? id;
  int? resId;
  int? branchId;
  String? screenShot;
  String? remark;
  int? status;
  String? paymentStatus;
  String? insertedAt;
  String? updatedAt;
  String? residentName;

  Details(
      {this.id,
        this.resId,
        this.branchId,
        this.screenShot,
        this.remark,
        this.status,
        this.paymentStatus,
        this.insertedAt,
        this.updatedAt,
        this.residentName});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resId = json['res_id'];
    branchId = json['branch_id'];
    screenShot = json['screen_shot'];
    remark = json['remark'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    residentName = json['resident_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['res_id'] = this.resId;
    data['branch_id'] = this.branchId;
    data['screen_shot'] = this.screenShot;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['inserted_at'] = this.insertedAt;
    data['updated_at'] = this.updatedAt;
    data['resident_name'] = this.residentName;
    return data;
  }
}
