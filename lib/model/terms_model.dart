// To parse this JSON data, do
//
//     final termsModel = termsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TermsModel termsModelFromJson(String str) => TermsModel.fromJson(json.decode(str));

String termsModelToJson(TermsModel data) => json.encode(data.toJson());

class TermsModel {
  int? success;
  String? details;
  List<Datum>? data;

  TermsModel({this.success, this.details, this.data});

  TermsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
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

class Datum {
  String? id;
  String? branchId;
  String? pgId;
  String? isPdf;
  String? term;
  String? tcPdf;

  Datum({this.id, this.branchId, this.pgId, this.isPdf, this.term, this.tcPdf});

  Datum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    pgId = json['pg_id'];
    isPdf = json['is_pdf'];
    term = json['term'];
    tcPdf = json['tc_pdf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['pg_id'] = this.pgId;
    data['is_pdf'] = this.isPdf;
    data['term'] = this.term;
    data['tc_pdf'] = this.tcPdf;
    return data;
  }
}


/*class TermsModel {
  TermsModel({
    required this.success,
    required this.data,
  });

  String success;
  List<Datum> data;

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.branchId,
    required this.pgId,
    required this.term,
    required this.tcPdf,
    required this.isPdf,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  int id;
  int branchId;
  int pgId;
  String term;
  String tcPdf;
  int isPdf;
  int createdBy;
  String createdAt;
  String updatedAt;
  String url;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    branchId: json["branch_id"],
    pgId: json["pg_id"],
    term: json["term"],
    tcPdf: json["tc_pdf"] == null ? "" : json["tc_pdf"],
    isPdf: json["is_pdf"],
    createdBy: json["created_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    url: json["URL"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_id": branchId,
    "pg_id": pgId,
    "term": term,
    "tc_pdf": tcPdf == null ? null : tcPdf,
    "is_pdf": isPdf,
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "URL": url,
  };
}*/
