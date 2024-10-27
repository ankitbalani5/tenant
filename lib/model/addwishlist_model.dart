class AddWishlistModel {
  int? success;
  String? details;

  AddWishlistModel({this.success, this.details});

  AddWishlistModel.fromJson(Map<String, dynamic> json) {
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
