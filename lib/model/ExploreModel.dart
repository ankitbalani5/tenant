import 'dart:convert';


ExploreModel exploreModelFromJson(String str) => ExploreModel.fromJson(json.decode(str));
String exploreModelToJson(ExploreModel data) => json.encode(data.toJson());


class ExploreModel {
  int? tenantOnboarded;
  List<Property>? property;
  int? success;
  String? responseMsg;

  ExploreModel(
      {this.tenantOnboarded, this.property, this.success, this.responseMsg});

  ExploreModel.fromJson(Map<String, dynamic> json) {
    tenantOnboarded = json['tenant_onboarded'];
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property!.add(new Property.fromJson(v));
      });
    }
    success = json['success'];
    responseMsg = json['response_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenant_onboarded'] = this.tenantOnboarded;
    if (this.property != null) {
      data['property'] = this.property!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['response_msg'] = this.responseMsg;
    return data;
  }
}

class Property {
  String? rentRange;
  String? branchId;

  @override
  String toString() {
    return 'Property{branchName: $branchName, latitude: $latitude, wishlist: $wishlist, isVerified: $isVerified}';
  }

  String? verifiedStatus;
  String? branchName;
  String? contactNumber;
  String? branchAddress;
  String? cityName;
  String? stateName;
  String? latitude;
  String? longitude;
  String? pgOccupancy;
  String? pgType;
  String? pgIdealFor;
  List<PropertyImage>? propertyImage;
  List<PropertyTermsCondition>? propertyTermsCondition;
  List<BranchAmenities>? branchAmenities;
  int? interested;
  String? wishlist;
  String? isVerified;
  String? ratingPercentage;
  String? lastWeekViews;
  NearbyLocations? nearbyLocations;
  String? pgProfileImg;

  Property(
      {this.rentRange,
        this.branchId,
        this.verifiedStatus,
        this.branchName,
        this.contactNumber,
        this.branchAddress,
        this.cityName,
        this.stateName,
        this.latitude,
        this.longitude,
        this.pgOccupancy,
        this.pgType,
        this.pgIdealFor,
        this.isVerified,
        this.propertyImage,
        this.propertyTermsCondition,
        this.branchAmenities,
        this.interested,
        this.wishlist,
        this.ratingPercentage,
        this.lastWeekViews,
        this.nearbyLocations,
        this.pgProfileImg
      });

  Property.fromJson(Map<String, dynamic> json) {
    rentRange = json['rent_range'].toString();
    branchId = json['branch_id'].toString();
    verifiedStatus = json['verified_status'].toString();
    branchName = json['branch_name'].toString();
    contactNumber = json['contact_number'].toString();
    branchAddress = json['branch_address'].toString();
    cityName = json['city_name']??'';
    stateName = json['state_name'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    pgOccupancy = json['pg_occupancy'].toString();
    pgType = json['pg_type'].toString();
    pgIdealFor = json['pg_ideal_for'].toString();
    isVerified = json['is_verified'];
    if (json['propertyImage'] != null) {
      propertyImage = <PropertyImage>[];
      json['propertyImage'].forEach((v) {
        propertyImage!.add(new PropertyImage.fromJson(v));
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
    interested = json['interested'];
    wishlist = json['wishlist'];
    ratingPercentage = json['rating_percentage'].toString();
    lastWeekViews = json['last_week_views'];
    nearbyLocations = json['nearby_locations'] != null
        ? new NearbyLocations.fromJson(json['nearby_locations'])
        : null;
    pgProfileImg = json['pg_profile_img'];
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
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
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
    data['interested'] = this.interested;
    data['wishlist'] = this.wishlist;
    data['rating_percentage'] = this.ratingPercentage.toString();
    data['last_week_views'] = this.lastWeekViews;
    if (this.nearbyLocations != null) {
      data['nearby_locations'] = this.nearbyLocations!.toJson();
    }
    data['pg_profile_img'] = this.pgProfileImg;
    return data;
  }
}

class PropertyImage {
  String? imagePath;

  PropertyImage({this.imagePath});

  PropertyImage.fromJson(Map<String, dynamic> json) {
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

class NearbyLocations {
  List<Restaurant>? restaurant;
  List<Hospital>? hospital;
  List<TrainStation>? trainStation;
  List<Supermarket>? supermarket;
  List<MovieTheater>? movieTheater;

  NearbyLocations(
      {this.restaurant,
        this.hospital,
        this.trainStation,
        this.supermarket,
        this.movieTheater});

  NearbyLocations.fromJson(Map<String, dynamic> json) {
    if (json['restaurant'] != null) {
      restaurant = <Restaurant>[];
      json['restaurant'].forEach((v) {
        restaurant!.add(new Restaurant.fromJson(v));
      });
    }
    if (json['hospital'] != null) {
      hospital = <Hospital>[];
      json['hospital'].forEach((v) {
        hospital!.add(new Hospital.fromJson(v));
      });
    }
    if (json['train_station'] != null) {
      trainStation = <TrainStation>[];
      json['train_station'].forEach((v) {
        trainStation!.add(new TrainStation.fromJson(v));
      });
    }
    if (json['supermarket'] != null) {
      supermarket = <Supermarket>[];
      json['supermarket'].forEach((v) {
        supermarket!.add(new Supermarket.fromJson(v));
      });
    }
    if (json['movie_theater'] != null) {
      movieTheater = <MovieTheater>[];
      json['movie_theater'].forEach((v) {
        movieTheater!.add(new MovieTheater.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.map((v) => v.toJson()).toList();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital!.map((v) => v.toJson()).toList();
    }
    if (this.trainStation != null) {
      data['train_station'] =
          this.trainStation!.map((v) => v.toJson()).toList();
    }
    if (this.supermarket != null) {
      data['supermarket'] = this.supermarket!.map((v) => v.toJson()).toList();
    }
    if (this.movieTheater != null) {
      data['movie_theater'] =
          this.movieTheater!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  List<String>? type;

  Restaurant(
      {this.latitude, this.longitude, this.address, this.name, this.type});

  Restaurant.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    name = json['name'];
    type = json['type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Hospital {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  List<String>? type;

  Hospital(
      {this.latitude, this.longitude, this.address, this.name, this.type});

  Hospital.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    name = json['name'];
    type = json['type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class TrainStation {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  List<String>? type;

  TrainStation(
      {this.latitude, this.longitude, this.address, this.name, this.type});

  TrainStation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    name = json['name'];
    type = json['type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Supermarket {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  List<String>? type;

  Supermarket(
      {this.latitude, this.longitude, this.address, this.name, this.type});

  Supermarket.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    name = json['name'];
    type = json['type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class MovieTheater {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  List<String>? type;

  MovieTheater(
      {this.latitude, this.longitude, this.address, this.name, this.type});

  MovieTheater.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    name = json['name'];
    type = json['type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}


/*class ExploreModel {
  List<Property>? property;
  int? success;
  String? responseMsg;

  ExploreModel({this.property, this.success, this.responseMsg});

  ExploreModel.fromJson(Map<String, dynamic> json) {
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property!.add(new Property.fromJson(v));
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

class Property {
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
  List<PropertyImage>? propertyImage;
  List<PropertyTermsCondition>? propertyTermsCondition;
  List<BranchAmenities>? branchAmenities;
  int? interested;

  Property(
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
        this.branchAmenities,
        this.interested});

  Property.fromJson(Map<String, dynamic> json) {
    rentRange = json['rent_range'].toString();
    branchId = json['branch_id'].toString();
    verifiedStatus = json['verified_status'].toString();
    branchName = json['branch_name'].toString();
    contactNumber = json['contact_number'].toString();
    branchAddress = json['branch_address'].toString();
    cityName = json['city_name'] ?? '';
    stateName = json['state_name'].toString();
    pgOccupancy = json['pg_occupancy'].toString();
    pgType = json['pg_type'].toString();
    pgIdealFor = json['pg_ideal_for'].toString();
    if (json['propertyImage'] != null) {
      propertyImage = <PropertyImage>[];
      json['propertyImage'].forEach((v) {
        propertyImage!.add(new PropertyImage.fromJson(v));
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
    interested = json['interested'];
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
    data['interested'] = this.interested;
    return data;
  }
}

class PropertyImage {
  String? imagePath;

  PropertyImage({this.imagePath});

  PropertyImage.fromJson(Map<String, dynamic> json) {
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
}*/


// class ExploreModel {
//   List<Property>? property;
//   int? success;
//   String? responseMsg;
//
//   ExploreModel({this.property, this.success, this.responseMsg});
//
//   ExploreModel.fromJson(Map<String, dynamic> json) {
//     if (json['property'] != null) {
//       property = <Property>[];
//       json['property'].forEach((v) {
//         property!.add(new Property.fromJson(v));
//       });
//     }
//     success = json['success'];
//     responseMsg = json['response_msg'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.property != null) {
//       data['property'] = this.property!.map((v) => v.toJson()).toList();
//     }
//     data['success'] = this.success;
//     data['response_msg'] = this.responseMsg;
//     return data;
//   }
// }
//
// class Property {
//   String? rentRange;
//   String? branchId;
//   String? verifiedStatus;
//   String? branchName;
//   String? contactNumber;
//   String? branchAddress;
//   String? cityName;
//   String? stateName;
//   String? pgOccupancy;
//   String? pgType;
//   String? pgIdealFor;
//   List<PropertyImage>? propertyImage;
//   List<PropertyTermsCondition>? propertyTermsCondition;
//   List<BranchAmenities>? branchAmenities;
//
//   Property(
//       {this.rentRange,
//         this.branchId,
//         this.verifiedStatus,
//         this.branchName,
//         this.contactNumber,
//         this.branchAddress,
//         this.cityName,
//         this.stateName,
//         this.pgOccupancy,
//         this.pgType,
//         this.pgIdealFor,
//         this.propertyImage,
//         this.propertyTermsCondition,
//         this.branchAmenities});
//
//   @override
//   String toString() {
//     return 'Property{rentRange: $rentRange, branchId: $branchId, verifiedStatus: $verifiedStatus, branchName: $branchName, contactNumber: $contactNumber, branchAddress: $branchAddress, cityName: $cityName, stateName: $stateName, pgOccupancy: $pgOccupancy, pgType: $pgType, pgIdealFor: $pgIdealFor, propertyImage: $propertyImage, propertyTermsCondition: $propertyTermsCondition, branchAmenities: $branchAmenities}';
//   }
//
//   Property.fromJson(Map<String, dynamic> json) {
//     rentRange = json['rent_range'].toString();
//     branchId = json['branch_id'].toString();
//     verifiedStatus = json['verified_status'].toString();
//     branchName = json['branch_name'].toString();
//     contactNumber = json['contact_number'].toString();
//     branchAddress = json['branch_address'].toString();
//     cityName = json['city_name']??'';
//     stateName = json['state_name'].toString();
//     pgOccupancy = json['pg_occupancy'].toString();
//     pgType = json['pg_type'].toString();
//     pgIdealFor = json['pg_ideal_for'].toString();
//     if (json['propertyImage'] != null) {
//       propertyImage = <PropertyImage>[];
//       json['propertyImage'].forEach((v) {
//         propertyImage!.add(new PropertyImage.fromJson(v));
//       });
//     }
//     if (json['propertyTermsCondition'] != null) {
//       propertyTermsCondition = <PropertyTermsCondition>[];
//       json['propertyTermsCondition'].forEach((v) {
//         propertyTermsCondition!.add(new PropertyTermsCondition.fromJson(v));
//       });
//     }
//     if (json['branchAmenities'] != null) {
//       branchAmenities = <BranchAmenities>[];
//       json['branchAmenities'].forEach((v) {
//         branchAmenities!.add(new BranchAmenities.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rent_range'] = this.rentRange;
//     data['branch_id'] = this.branchId;
//     data['verified_status'] = this.verifiedStatus;
//     data['branch_name'] = this.branchName;
//     data['contact_number'] = this.contactNumber;
//     data['branch_address'] = this.branchAddress;
//     data['city_name'] = this.cityName='';
//     data['state_name'] = this.stateName;
//     data['pg_occupancy'] = this.pgOccupancy;
//     data['pg_type'] = this.pgType;
//     data['pg_ideal_for'] = this.pgIdealFor;
//     if (this.propertyImage != null) {
//       data['propertyImage'] =
//           this.propertyImage!.map((v) => v.toJson()).toList();
//     }
//     if (this.propertyTermsCondition != null) {
//       data['propertyTermsCondition'] =
//           this.propertyTermsCondition!.map((v) => v.toJson()).toList();
//     }
//     if (this.branchAmenities != null) {
//       data['branchAmenities'] =
//           this.branchAmenities!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class PropertyImage {
//   String? imagePath;
//
//   PropertyImage({this.imagePath});
//
//   PropertyImage.fromJson(Map<String, dynamic> json) {
//     imagePath = json['imagePath'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['imagePath'] = this.imagePath;
//     return data;
//   }
// }
//
// class PropertyTermsCondition {
//   String? terms;
//
//   PropertyTermsCondition({this.terms});
//
//   PropertyTermsCondition.fromJson(Map<String, dynamic> json) {
//     terms = json['terms'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['terms'] = this.terms;
//     return data;
//   }
// }
//
// class BranchAmenities {
//   String? amenities;
//
//   BranchAmenities({this.amenities});
//
//   BranchAmenities.fromJson(Map<String, dynamic> json) {
//     amenities = json['amenities'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['amenities'] = this.amenities;
//     return data;
//   }
// }




