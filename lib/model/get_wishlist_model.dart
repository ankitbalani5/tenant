class GetWishlistModel {
  List<GetWishlistProperty>? property;
  int? success;
  String? responseMsg;

  GetWishlistModel({this.property, this.success, this.responseMsg});

  GetWishlistModel.fromJson(Map<String, dynamic> json) {
    if (json['property'] != null) {
      property = <GetWishlistProperty>[];
      json['property'].forEach((v) {
        property!.add(new GetWishlistProperty.fromJson(v));
      });
    }
    success = json['success'];
    responseMsg = json['response_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.property != null) {
      data['property'] = this.property!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['response_msg'] = this.responseMsg;
    return data;
  }
}

class GetWishlistProperty {
  String? rentRange;
  String? branchId;
  String? verifiedStatus;
  String? branchName;
  String? contactNumber;
  String? branchAddress;
  String? cityName;
  String? stateName;
  String? pgOccupancy;
  String? pgType;
  String? pgIdealFor;
  String? isVerified;
  List<GetWishlistPropertyImage>? propertyImage;
  List<PropertyTermsCondition>? propertyTermsCondition;
  List<BranchAmenities>? branchAmenities;

  GetWishlistProperty(
      {this.rentRange,
        this.branchId,
        this.verifiedStatus,
        this.branchName,
        this.contactNumber,
        this.branchAddress,
        this.cityName,
        this.stateName,
        this.pgOccupancy,
        this.pgType,
        this.pgIdealFor,
        this.propertyImage,
        this.propertyTermsCondition,
        this.isVerified,
        this.branchAmenities});

  GetWishlistProperty.fromJson(Map<String, dynamic> json) {
    rentRange = json['rent_range'];
    branchId = json['branch_id'];
    verifiedStatus = json['verified_status'];
    branchName = json['branch_name'];
    contactNumber = json['contact_number'];
    branchAddress = json['branch_address'];
    cityName = json['city_name'];
    stateName = json['state_name'];
    pgOccupancy = json['pg_occupancy'];
    pgType = json['pg_type'];
    pgIdealFor = json['pg_ideal_for'];
    isVerified = json['is_verified'];
    if (json['propertyImage'] != null) {
      propertyImage = <GetWishlistPropertyImage>[];
      json['propertyImage'].forEach((v) {
        propertyImage!.add(new GetWishlistPropertyImage.fromJson(v));
      });
    }
    if (json['propertyTermsCondition'] != null) {
      propertyTermsCondition = <PropertyTermsCondition>[];
      json['propertyTermsCondition'].forEach((v) {
        propertyTermsCondition!.add(new PropertyTermsCondition.fromJson(v));
      });
    }
    if (json['branchAmenities'] != null) {
      branchAmenities = <BranchAmenities>[];
      json['branchAmenities'].forEach((v) {
        branchAmenities!.add(new BranchAmenities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rent_range'] = this.rentRange;
    data['branch_id'] = this.branchId;
    data['verified_status'] = this.verifiedStatus;
    data['branch_name'] = this.branchName;
    data['contact_number'] = this.contactNumber;
    data['branch_address'] = this.branchAddress;
    data['city_name'] = this.cityName;
    data['state_name'] = this.stateName;
    data['pg_occupancy'] = this.pgOccupancy;
    data['pg_type'] = this.pgType;
    data['pg_ideal_for'] = this.pgIdealFor;
    data['is_verified'] = this.isVerified;
    if (this.propertyImage != null) {
      data['propertyImage'] =
          this.propertyImage!.map((v) => v.toJson()).toList();
    }
    if (this.propertyTermsCondition != null) {
      data['propertyTermsCondition'] =
          this.propertyTermsCondition!.map((v) => v.toJson()).toList();
    }
    if (this.branchAmenities != null) {
      data['branchAmenities'] =
          this.branchAmenities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetWishlistPropertyImage {
  String? imagePath;

  GetWishlistPropertyImage({this.imagePath});

  GetWishlistPropertyImage.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class PropertyTermsCondition {
  String? terms;

  PropertyTermsCondition({this.terms});

  PropertyTermsCondition.fromJson(Map<String, dynamic> json) {
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terms'] = this.terms;
    return data;
  }
}

class BranchAmenities {
  String? amenities;

  BranchAmenities({this.amenities});

  BranchAmenities.fromJson(Map<String, dynamic> json) {
    amenities = json['amenities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amenities'] = this.amenities;
    return data;
  }
}
