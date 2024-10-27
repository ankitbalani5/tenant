class NoticePeriodHistoryModel {
  NoticePeriodHistoryModel({
      this.success, 
      this.details, 
      this.data,});

  NoticePeriodHistoryModel.fromJson(dynamic json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? success;
  String? details;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['details'] = details;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      this.residentId, 
      this.residentName, 
      this.residentContatct, 
      this.status, 
      this.approvedStatus, 
      this.noticeSdate, 
      this.noticeEdate, 
      this.noticeId,});

  Data.fromJson(dynamic json) {
    residentId = json['resident_id'];
    residentName = json['resident_name'];
    residentContatct = json['resident_contatct'];
    status = json['status'];
    approvedStatus = json['approved_status'];
    noticeSdate = json['notice_sdate'];
    noticeEdate = json['notice_edate'];
    noticeId = json['notice_id'];
  }
  String? residentId;
  String? residentName;
  String? residentContatct;
  String? status;
  String? approvedStatus;
  String? noticeSdate;
  String? noticeEdate;
  String? noticeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['resident_id'] = residentId;
    map['resident_name'] = residentName;
    map['resident_contatct'] = residentContatct;
    map['status'] = status;
    map['approved_status'] = approvedStatus;
    map['notice_sdate'] = noticeSdate;
    map['notice_edate'] = noticeEdate;
    map['notice_id'] = noticeId;
    return map;
  }

}