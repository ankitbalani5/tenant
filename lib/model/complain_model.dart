import 'dart:convert';

/// complain : [{"id":382,"complain_date":"10-Sep-2023","status":"Completed","remark":"water leak","head_name":"Water Leakage","trail":[{"remark":"water leak","status":"Pending","remark_date":"10-Sep-2023","follow_date":""},{"remark":"","status":"Completed","remark_date":"18-Jan-2024","follow_date":"30-Nov--0001"}]},{"id":376,"complain_date":"19-Aug-2023","status":"Rejected","remark":"","head_name":"Water Leakage","trail":[{"remark":"","status":"Pending","remark_date":"19-Aug-2023","follow_date":""},{"remark":"","status":"Rejected","remark_date":"19-Jan-2024","follow_date":"30-Nov--0001"}]},{"id":375,"complain_date":"14-Aug-2023","status":"Pending","remark":"","head_name":"Water Leakage","trail":[{"remark":"","status":"Pending","remark_date":"14-Aug-2023","follow_date":""}]}]
/// complainHead : [{"id":58,"head_name":"Water Leakage","description":"Water Leakage","status":"Active"},{"id":62,"head_name":"Cooking","description":"Cooking","status":"Active"},{"id":63,"head_name":"Electriyti","description":"Low Light","status":"Active"},{"id":64,"head_name":"Clnee","description":"Pg","status":"Active"}]
/// success : "1"
/// details : "All Complain Details Fetch Successfully."
ComplainModel complainModelFromJson(String str) => ComplainModel.fromJson(json.decode(str));

String complainModelToJson(ComplainModel data) => json.encode(data.toJson());


class ComplainModel {
  List<ComplainHead>? complainHead;
  List<Complain>? complain;
  int? success;
  String? details;

  ComplainModel({this.complainHead, this.complain, this.success, this.details});

  ComplainModel.fromJson(Map<String, dynamic> json) {
    if (json['complainHead'] != null) {
      complainHead = <ComplainHead>[];
      json['complainHead'].forEach((v) {
        complainHead!.add(new ComplainHead.fromJson(v));
      });
    }
    if (json['complain'] != null) {
      complain = <Complain>[];
      json['complain'].forEach((v) {
        complain!.add(new Complain.fromJson(v));
      });
    }
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.complainHead != null) {
      data['complainHead'] = this.complainHead!.map((v) => v.toJson()).toList();
    }
    if (this.complain != null) {
      data['complain'] = this.complain!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}

class ComplainHead {
  String? id;
  String? headName;
  String? description;
  String? status;

  ComplainHead({this.id, this.headName, this.description, this.status});

  ComplainHead.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headName = json['head_name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['head_name'] = this.headName;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class Complain {
  String? id;
  String? complainDate;
  String? complainStatus;
  String? remark;
  String? headName;
  List<Trail>? trail;

  Complain(
      {this.id,
        this.complainDate,
        this.complainStatus,
        this.remark,
        this.headName,
        this.trail});

  Complain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complainDate = json['complain_date'];
    complainStatus = json['complain_status'];
    remark = json['remark'];
    headName = json['head_name'];
    if (json['trail'] != null) {
      trail = <Trail>[];
      json['trail'].forEach((v) {
        trail!.add(new Trail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['complain_date'] = this.complainDate;
    data['complain_status'] = this.complainStatus;
    data['remark'] = this.remark;
    data['head_name'] = this.headName;
    if (this.trail != null) {
      data['trail'] = this.trail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trail {
  String? remark;
  String? status;
  String? remarkDate;
  String? followDate;

  Trail({this.remark, this.status, this.remarkDate, this.followDate});

  Trail.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    status = json['status'];
    remarkDate = json['remark_date'];
    followDate = json['follow_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['remark_date'] = this.remarkDate;
    data['follow_date'] = this.followDate;
    return data;
  }
}



/*
class ComplainModel {
  List<ComplainHead>? complainHead;
  List<Complain>? complain;
  int? success;
  String? details;

  ComplainModel({this.complainHead, this.complain, this.success, this.details});

  ComplainModel.fromJson(Map<String, dynamic> json) {
    if (json['complainHead'] != null) {
      complainHead = <ComplainHead>[];
      json['complainHead'].forEach((v) {
        complainHead!.add(new ComplainHead.fromJson(v));
      });
    }
    if (json['complain'] != null) {
      complain = <Complain>[];
      json['complain'].forEach((v) {
        complain!.add(new Complain.fromJson(v));
      });
    }
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.complainHead != null) {
      data['complainHead'] = this.complainHead!.map((v) => v.toJson()).toList();
    }
    if (this.complain != null) {
      data['complain'] = this.complain!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}

class ComplainHead {
  String? id;
  String? headName;
  String? description;
  String? status;

  ComplainHead({this.id, this.headName, this.description, this.status});

  ComplainHead.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headName = json['head_name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['head_name'] = this.headName;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class Complain {
  String? id;
  String? complainDate;
  String? complainStatus;
  Null? remark;
  String? headName;
  List<Trail>? trail;

  Complain(
      {this.id,
        this.complainDate,
        this.complainStatus,
        this.remark,
        this.headName,
        this.trail});

  Complain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complainDate = json['complain_date'];
    complainStatus = json['complain_status'];
    remark = json['remark'];
    headName = json['head_name'];
    if (json['trail'] != null) {
      trail = <Trail>[];
      json['trail'].forEach((v) {
        trail!.add(new Trail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['complain_date'] = this.complainDate;
    data['complain_status'] = this.complainStatus;
    data['remark'] = this.remark;
    data['head_name'] = this.headName;
    if (this.trail != null) {
      data['trail'] = this.trail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trail {
  String? remark;
  String? status;
  String? remarkDate;
  String? followDate;

  Trail({this.remark, this.status, this.remarkDate, this.followDate});

  Trail.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    status = json['status'];
    remarkDate = json['remark_date'];
    followDate = json['follow_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['remark_date'] = this.remarkDate;
    data['follow_date'] = this.followDate;
    return data;
  }
}
*/


// class ComplainModel {
//   ComplainModel({
//       List<Complain>? complain,
//       List<ComplainHead>? complainHead,
//       String? success,
//       String? details,}){
//     _complain = complain;
//     _complainHead = complainHead;
//     _success = success;
//     _details = details;
// }
//
//   ComplainModel.fromJson(dynamic json) {
//     if (json['complain'] != null) {
//       _complain = [];
//       json['complain'].forEach((v) {
//         _complain?.add(Complain.fromJson(v));
//       });
//     }
//     if (json['complainHead'] != null) {
//       _complainHead = [];
//       json['complainHead'].forEach((v) {
//         _complainHead?.add(ComplainHead.fromJson(v));
//       });
//     }
//     _success = json['success'];
//     _details = json['details'];
//   }
//   List<Complain>? _complain;
//   List<ComplainHead>? _complainHead;
//   String? _success;
//   String? _details;
// ComplainModel copyWith({  List<Complain>? complain,
//   List<ComplainHead>? complainHead,
//   String? success,
//   String? details,
// }) => ComplainModel(  complain: complain ?? _complain,
//   complainHead: complainHead ?? _complainHead,
//   success: success ?? _success,
//   details: details ?? _details,
// );
//   List<Complain>? get complain => _complain;
//   List<ComplainHead>? get complainHead => _complainHead;
//   String? get success => _success;
//   String? get details => _details;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_complain != null) {
//       map['complain'] = _complain?.map((v) => v.toJson()).toList();
//     }
//     if (_complainHead != null) {
//       map['complainHead'] = _complainHead?.map((v) => v.toJson()).toList();
//     }
//     map['success'] = _success;
//     map['details'] = _details;
//     return map;
//   }
//
// }
//
// /// id : 58
// /// head_name : "Water Leakage"
// /// description : "Water Leakage"
// /// status : "Active"
//
// class ComplainHead {
//   ComplainHead({
//       num? id,
//       String? headName,
//       String? description,
//       String? status,}){
//     _id = id;
//     _headName = headName;
//     _description = description;
//     _status = status;
// }
//
//
//   @override
//   String toString() {
//     return _headName.toString();
//   }
//
//   ComplainHead.fromJson(dynamic json) {
//     _id = json['id'];
//     _headName = json['head_name'];
//     _description = json['description'];
//     _status = json['status'];
//   }
//   num? _id;
//   String? _headName;
//   String? _description;
//   String? _status;
// ComplainHead copyWith({  num? id,
//   String? headName,
//   String? description,
//   String? status,
// }) => ComplainHead(  id: id ?? _id,
//   headName: headName ?? _headName,
//   description: description ?? _description,
//   status: status ?? _status,
// );
//   num? get id => _id;
//   String? get headName => _headName;
//   String? get description => _description;
//   String? get status => _status;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['head_name'] = _headName;
//     map['description'] = _description;
//     map['status'] = _status;
//     return map;
//   }
//
// }
//
// /// id : 382
// /// complain_date : "10-Sep-2023"
// /// status : "Completed"
// /// remark : "water leak"
// /// head_name : "Water Leakage"
// /// trail : [{"remark":"water leak","status":"Pending","remark_date":"10-Sep-2023","follow_date":""},{"remark":"","status":"Completed","remark_date":"18-Jan-2024","follow_date":"30-Nov--0001"}]
//
// class Complain {
//   Complain({
//       num? id,
//       String? complainDate,
//       String? status,
//       String? remark,
//       String? headName,
//       List<Trail>? trail,}){
//     _id = id;
//     _complainDate = complainDate;
//     _status = status;
//     _remark = remark;
//     _headName = headName;
//     _trail = trail;
// }
//
//   Complain.fromJson(dynamic json) {
//     _id = json['id'];
//     _complainDate = json['complain_date'];
//     _status = json['status'];
//     _remark = json['remark'];
//     _headName = json['head_name'];
//     if (json['trail'] != null) {
//       _trail = [];
//       json['trail'].forEach((v) {
//         _trail?.add(Trail.fromJson(v));
//       });
//     }
//   }
//   num? _id;
//   String? _complainDate;
//   String? _status;
//   String? _remark;
//   String? _headName;
//   List<Trail>? _trail;
// Complain copyWith({  num? id,
//   String? complainDate,
//   String? status,
//   String? remark,
//   String? headName,
//   List<Trail>? trail,
// }) => Complain(  id: id ?? _id,
//   complainDate: complainDate ?? _complainDate,
//   status: status ?? _status,
//   remark: remark ?? _remark,
//   headName: headName ?? _headName,
//   trail: trail ?? _trail,
// );
//   num? get id => _id;
//   String? get complainDate => _complainDate;
//   String? get status => _status;
//   String? get remark => _remark;
//   String? get headName => _headName;
//   List<Trail>? get trail => _trail;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['complain_date'] = _complainDate;
//     map['status'] = _status;
//     map['remark'] = _remark;
//     map['head_name'] = _headName;
//     if (_trail != null) {
//       map['trail'] = _trail?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// /// remark : "water leak"
// /// status : "Pending"
// /// remark_date : "10-Sep-2023"
// /// follow_date : ""
//
// class Trail {
//   Trail({
//       String? remark,
//       String? status,
//       String? remarkDate,
//       String? followDate,}){
//     _remark = remark;
//     _status = status;
//     _remarkDate = remarkDate;
//     _followDate = followDate;
// }
//
//   Trail.fromJson(dynamic json) {
//     _remark = json['remark'];
//     _status = json['status'];
//     _remarkDate = json['remark_date'];
//     _followDate = json['follow_date'];
//   }
//   String? _remark;
//   String? _status;
//   String? _remarkDate;
//   String? _followDate;
// Trail copyWith({  String? remark,
//   String? status,
//   String? remarkDate,
//   String? followDate,
// }) => Trail(  remark: remark ?? _remark,
//   status: status ?? _status,
//   remarkDate: remarkDate ?? _remarkDate,
//   followDate: followDate ?? _followDate,
// );
//   String? get remark => _remark;
//   String? get status => _status;
//   String? get remarkDate => _remarkDate;
//   String? get followDate => _followDate;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['remark'] = _remark;
//     map['status'] = _status;
//     map['remark_date'] = _remarkDate;
//     map['follow_date'] = _followDate;
//     return map;
//   }
//
// }