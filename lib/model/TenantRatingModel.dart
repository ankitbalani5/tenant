class TenantRatingModel {
  int? success;
  String? details;
  List<Data>? data;

  TenantRatingModel({this.success, this.details, this.data});

  TenantRatingModel.fromJson(Map<String, dynamic> json) {
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
  String? branchName;
  String? rating;
  String? description;
  String? insertedDate;
  String? insertedTime;

  Data(
      {this.branchName,
        this.rating,
        this.description,
        this.insertedDate,
        this.insertedTime});

  Data.fromJson(Map<String, dynamic> json) {
    branchName = json['branch_name'];
    rating = json['rating'];
    description = json['description'];
    insertedDate = json['inserted_date'];
    insertedTime = json['inserted_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_name'] = this.branchName;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['inserted_date'] = this.insertedDate;
    data['inserted_time'] = this.insertedTime;
    return data;
  }
}
