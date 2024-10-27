class ReviewModel {
  int? success;
  String? details;
  List<Data>? data;

  ReviewModel({this.success, this.details, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
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
  String? residentName;
  String? rating;
  String? discription;
  String? insertedDate;
  String? insertedTime;

  Data(
      {this.residentName,
        this.rating,
        this.discription,
        this.insertedDate,
        this.insertedTime});

  Data.fromJson(Map<String, dynamic> json) {
    residentName = json['resident_name'];
    rating = json['rating'];
    discription = json['discription'];
    insertedDate = json['inserted_date'];
    insertedTime = json['inserted_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resident_name'] = this.residentName;
    data['rating'] = this.rating;
    data['discription'] = this.discription;
    data['inserted_date'] = this.insertedDate;
    data['inserted_time'] = this.insertedTime;
    return data;
  }
}
