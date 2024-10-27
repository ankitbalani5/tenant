import 'dart:convert';

/// residents : [{"tenant_id":2796,"resident_name":"Rmchandra","dob":"08-Jul-2015","rent":"3000","branch_id":550,"total_due":"0","total_advance":"0","room_id":2801,"bed_id":4942,"due_date":"24-Jan-2023","registration_date":"21-Jan-2023","f_name":"Bishan Lal","pg":"KISHAN PG ","image":"","due_amount":"0","bed_name":"Bed 2","room_name":"Room 2","accommodation":[{"branch":"KISHAN PG ","bed_id":4942,"from_date":"2023-01-23","to_date":"","rent":3000,"bed":"Bed 2","room":"Room 2"},{"branch":"KISHAN PG ","bed_id":4964,"from_date":"2023-01-21","to_date":"2023-01-21","rent":5000,"bed":"window-01","room":"Room-08"}]}]
/// amenities : [{"amenity_name":"Hygenic Food"},{"amenity_name":"Daily Newspaper"},{"amenity_name":"Power Backup"},{"amenity_name":"Wi-fi"},{"amenity_name":"Fully Furnished"},{"amenity_name":"R.O. Water"},{"amenity_name":"Cold Water"},{"amenity_name":"Parking"},{"amenity_name":"CCTV"},{"amenity_name":"Attach Let-bath"},{"amenity_name":"A.C."},{"amenity_name":"Geyser"},{"amenity_name":"Balcony"},{"amenity_name":"Gas/Induction"},{"amenity_name":"Fridge"},{"amenity_name":"Washing Machine"},{"amenity_name":"TV"},{"amenity_name":"Almira"},{"amenity_name":"Kitchen Amenities"},{"amenity_name":"Library"},{"amenity_name":"Cleaning"}]
/// accommodation : [{"branch":"KISHAN PG ","bed_id":4942,"from_date":"2023-01-23","to_date":"","rent":3000,"bed":"Bed 2","room":"Room 2"},{"branch":"KISHAN PG ","bed_id":4964,"from_date":"2023-01-21","to_date":"2023-01-21","rent":5000,"bed":"window-01","room":"Room-08"}]
/// pg_detail : {"pg_name":"KISHAN PG ","upi_register_name":"","upi_id":"","qr_code":"https://testdashboard.btroomer.com/"}
/// current_date : "27-Jan-24"
/// app_version : "1.0"
/// success : "1"
/// details : "Data Fetched Successfully"

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());


class UserModel {
  List<Residents>? residents;
  List<Amenities>? amenities;
  int? tenantRating;
  PgDetails? pgDetails;
  List<Accommodation>? accommodation;
  String? currentDate;
  String? appVersion;
  int? success;
  double? version;
  String? details;

  UserModel(
      {this.residents,
        this.amenities,
        this.tenantRating,
        this.pgDetails,
        this.accommodation,
        this.currentDate,
        this.appVersion,
        this.success,
        this.version,
        this.details});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['residents'] != null) {
      residents = <Residents>[];
      json['residents'].forEach((v) {
        residents!.add(new Residents.fromJson(v));
      });
    }
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(new Amenities.fromJson(v));
      });
    }
    tenantRating = json['tenant_rating'];
    pgDetails = json['pg_details'] != null
        ? new PgDetails.fromJson(json['pg_details'])
        : null;
    if (json['accommodation'] != null) {
      accommodation = <Accommodation>[];
      json['accommodation'].forEach((v) {
        accommodation!.add(new Accommodation.fromJson(v));
      });
    }
    currentDate = json['current_date'];
    appVersion = json['app_version'];
    success = json['success'];
    version = json['version'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.residents != null) {
      data['residents'] = this.residents!.map((v) => v.toJson()).toList();
    }
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
    }
    data['tenant_rating'] = this.tenantRating;
    if (this.pgDetails != null) {
      data['pg_details'] = this.pgDetails!.toJson();
    }
    if (this.accommodation != null) {
      data['accommodation'] =
          this.accommodation!.map((v) => v.toJson()).toList();
    }
    data['current_date'] = this.currentDate;
    data['app_version'] = this.appVersion;
    data['success'] = this.success;
    data['version'] = this.version;
    data['details'] = this.details;
    return data;
  }
}

class Residents {
  String? tenantId;
  String? residentName;
  String? dob;
  List<String>? iamgesPath;
  String? branchName;
  String? rent;
  String? branchId;
  String? totalDue;
  String? totalAdvance;
  String? roomId;
  String? bedId;
  String? dueDate;
  String? registrationDate;
  String? fName;
  String? eqaroRegister;
  String? eqaroFinalVerification;
  String? email;
  String? pg;
  String? pgId;
  String? image;
  String? dueAmount;
  String? roomName;
  String? bedName;
  List<Accommodation>? accommodation;
  int? rating;
  String? description;
  String? noticeStartDate;

  Residents(
      {this.tenantId,
        this.residentName,
        this.dob,
        this.iamgesPath,
        this.branchName,
        this.rent,
        this.branchId,
        this.totalDue,
        this.totalAdvance,
        this.roomId,
        this.bedId,
        this.dueDate,
        this.registrationDate,
        this.fName,
        this.eqaroRegister,
        this.eqaroFinalVerification,
        this.email,
        this.pg,
        this.pgId,
        this.image,
        this.dueAmount,
        this.roomName,
        this.bedName,
        this.accommodation,
        this.rating,
        this.description,
        this.noticeStartDate});

  Residents.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenant_id'];
    residentName = json['resident_name'];
    dob = json['dob'];
    iamgesPath = json['iamges_path'].cast<String>();
    branchName = json['branch_name'];
    rent = json['rent'];
    branchId = json['branch_id'];
    totalDue = json['total_due'];
    totalAdvance = json['total_advance'];
    roomId = json['room_id'];
    bedId = json['bed_id'];
    dueDate = json['due_date'];
    registrationDate = json['registration_date'];
    fName = json['f_name'];
    eqaroRegister = json['eqaro_register'];
    eqaroFinalVerification = json['eqaro_final_verification'];
    email = json['email'];
    pg = json['pg'];
    pgId = json['pg_id'];
    image = json['image'];
    dueAmount = json['due_amount'];
    roomName = json['room_name'];
    bedName = json['bed_name'];
    if (json['accommodation'] != null) {
      accommodation = <Accommodation>[];
      json['accommodation'].forEach((v) {
        accommodation!.add(new Accommodation.fromJson(v));
      });
    }
    rating = json['rating'];
    description = json['description'];
    noticeStartDate = json['notice_start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenant_id'] = this.tenantId;
    data['resident_name'] = this.residentName;
    data['dob'] = this.dob;
    data['iamges_path'] = this.iamgesPath;
    data['branch_name'] = this.branchName;
    data['rent'] = this.rent;
    data['branch_id'] = this.branchId;
    data['total_due'] = this.totalDue;
    data['total_advance'] = this.totalAdvance;
    data['room_id'] = this.roomId;
    data['bed_id'] = this.bedId;
    data['due_date'] = this.dueDate;
    data['registration_date'] = this.registrationDate;
    data['f_name'] = this.fName;
    data['eqaro_register'] = this.eqaroRegister;
    data['eqaro_final_verification'] = this.eqaroFinalVerification;
    data['email'] = this.email;
    data['pg'] = this.pg;
    data['pg_id'] = this.pgId;
    data['image'] = this.image;
    data['due_amount'] = this.dueAmount;
    data['room_name'] = this.roomName;
    data['bed_name'] = this.bedName;
    if (this.accommodation != null) {
      data['accommodation'] =
          this.accommodation!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['notice_start_date'] = this.noticeStartDate;
    return data;
  }
}

class Accommodation {
  String? fromDate;
  String? toDate;
  String? branch;
  String? bedId;
  String? bed;
  String? room;
  String? rent;

  Accommodation(
      {this.fromDate,
        this.toDate,
        this.branch,
        this.bedId,
        this.bed,
        this.room,
        this.rent});

  Accommodation.fromJson(Map<String, dynamic> json) {
    fromDate = json['from_date'];
    toDate = json['to_date'];
    branch = json['branch'];
    bedId = json['bed_id'];
    bed = json['bed'];
    room = json['room'];
    rent = json['rent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['branch'] = this.branch;
    data['bed_id'] = this.bedId;
    data['bed'] = this.bed;
    data['room'] = this.room;
    data['rent'] = this.rent;
    return data;
  }
}

class Amenities {
  String? amenityName;

  Amenities({this.amenityName});

  Amenities.fromJson(Map<String, dynamic> json) {
    amenityName = json['amenity_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amenity_name'] = this.amenityName;
    return data;
  }
}

class PgDetails {
  String? pgName;
  String? upiRegisterName;
  String? upiId;
  String? eqaro;
  String? pgProfile;
  String? contact;
  String? qrCode;

  PgDetails(
      {this.pgName,
        this.upiRegisterName,
        this.upiId,
        this.eqaro,
        this.pgProfile,
        this.contact,
        this.qrCode});

  PgDetails.fromJson(Map<String, dynamic> json) {
    pgName = json['pg_name'];
    upiRegisterName = json['upi_register_name'];
    upiId = json['upi_id'];
    eqaro = json['eqaro'];
    pgProfile = json['pg_profile'];
    contact = json['contact'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pg_name'] = this.pgName;
    data['upi_register_name'] = this.upiRegisterName;
    data['upi_id'] = this.upiId;
    data['eqaro'] = this.eqaro;
    data['pg_profile'] = this.pgProfile;
    data['contact'] = this.contact;
    data['qr_code'] = this.qrCode;
    return data;
  }
}




// class UserModel {
//   List<Residents>? residents;
//   List<Amenities>? amenities;
//   String? tenantRating;
//   PgDetails? pgDetails;
//   List<Accommodation>? accommodation;
//   String? currentDate;
//   String? appVersion;
//   String? success;
//   String? details;
//
//   UserModel(
//       {this.residents,
//         this.amenities,
//         this.tenantRating,
//         this.pgDetails,
//         this.accommodation,
//         this.currentDate,
//         this.appVersion,
//         this.success,
//         this.details});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     if (json['residents'] != null) {
//       residents = <Residents>[];
//       json['residents'].forEach((v) {
//         residents!.add(new Residents.fromJson(v));
//       });
//     }
//     if (json['amenities'] != null) {
//       amenities = <Amenities>[];
//       json['amenities'].forEach((v) {
//         amenities!.add(new Amenities.fromJson(v));
//       });
//     }
//     tenantRating = json['tenant_rating'].toString();
//     pgDetails = json['pg_details'] != null
//         ? new PgDetails.fromJson(json['pg_details'])
//         : null;
//     if (json['accommodation'] != null) {
//       accommodation = <Accommodation>[];
//       json['accommodation'].forEach((v) {
//         accommodation!.add(new Accommodation.fromJson(v));
//       });
//     }
//     currentDate = json['current_date'].toString();
//     appVersion = json['app_version'].toString();
//     success = json['success'].toString();
//     details = json['details'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.residents != null) {
//       data['residents'] = this.residents!.map((v) => v.toJson()).toList();
//     }
//     if (this.amenities != null) {
//       data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
//     }
//     data['tenant_rating'] = this.tenantRating.toString();
//     if (this.pgDetails != null) {
//       data['pg_details'] = this.pgDetails!.toJson();
//     }
//     if (this.accommodation != null) {
//       data['accommodation'] =
//           this.accommodation!.map((v) => v.toJson()).toList();
//     }
//     data['current_date'] = this.currentDate;
//     data['app_version'] = this.appVersion;
//     data['success'] = this.success;
//     data['details'] = this.details;
//     return data;
//   }
// }
//
// class Residents {
//   String? tenantId;
//   String? residentName;
//   String? dob;
//   List<String>? iamgesPath;
//   String? branchName;
//   String? rent;
//   String? branchId;
//   String? totalDue;
//   String? totalAdvance;
//   String? roomId;
//   String? bedId;
//   String? dueDate;
//   String? registrationDate;
//   String? fName;
//   String? eqaroRegister;
//   String? email;
//   String? pg;
//   String? pgId;
//   String? image;
//   String? dueAmount;
//   String? roomName;
//   String? bedName;
//   List<Accommodation>? accommodation;
//   int? rating;
//   String? description;
//   String? noticeStartDate;
//
//   Residents(
//       {this.tenantId,
//         this.residentName,
//         this.dob,
//         this.iamgesPath,
//         this.branchName,
//         this.rent,
//         this.branchId,
//         this.totalDue,
//         this.totalAdvance,
//         this.roomId,
//         this.bedId,
//         this.dueDate,
//         this.registrationDate,
//         this.fName,
//         this.eqaroRegister,
//         this.email,
//         this.pg,
//         this.pgId,
//         this.image,
//         this.dueAmount,
//         this.roomName,
//         this.bedName,
//         this.accommodation,
//         this.rating,
//         this.description,
//         this.noticeStartDate});
//
//   Residents.fromJson(Map<String, dynamic> json) {
//     tenantId = json['tenant_id'].toString();
//     residentName = json['resident_name'].toString();
//     dob = json['dob'].toString();
//     iamgesPath = json['iamges_path'].cast<String>();
//     branchName = json['branch_name'];
//     rent = json['rent'].toString();
//     branchId = json['branch_id'].toString();
//     totalDue = json['total_due'].toString();
//     totalAdvance = json['total_advance'].toString();
//     roomId = json['room_id'].toString();
//     bedId = json['bed_id'].toString();
//     dueDate = json['due_date'].toString();
//     registrationDate = json['registration_date'].toString();
//     fName = json['f_name'].toString();
//     eqaroRegister = json['eqaro_register'];
//     email = json['email'];
//     pg = json['pg'].toString();
//     pgId = json['pg_id'].toString();
//     image = json['image'].toString();
//     dueAmount = json['due_amount'].toString();
//     roomName = json['room_name'].toString();
//     bedName = json['bed_name'].toString();
//     rating = json['rating'];
//     description = json['description'];
//     noticeStartDate = json['notice_start_date'];
//     if (json['accommodation'] != null) {
//       accommodation = <Accommodation>[];
//       json['accommodation'].forEach((v) {
//         accommodation!.add(new Accommodation.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['tenant_id'] = this.tenantId;
//     data['resident_name'] = this.residentName;
//     data['dob'] = this.dob;
//     data['iamges_path'] = this.iamgesPath;
//     data['branch_name'] = this.branchName;
//     data['rent'] = this.rent;
//     data['branch_id'] = this.branchId;
//     data['total_due'] = this.totalDue;
//     data['total_advance'] = this.totalAdvance;
//     data['room_id'] = this.roomId;
//     data['bed_id'] = this.bedId;
//     data['due_date'] = this.dueDate;
//     data['registration_date'] = this.registrationDate;
//     data['f_name'] = this.fName;
//     data['eqaro_register'] = this.eqaroRegister;
//     data['email'] = this.email;
//     data['pg'] = this.pg;
//     data['pg_id'] = this.pgId;
//     data['image'] = this.image;
//     data['due_amount'] = this.dueAmount;
//     data['room_name'] = this.roomName;
//     data['bed_name'] = this.bedName;
//     data['rating'] = this.rating;
//     data['description'] = this.description;
//     data['notice_start_date'] = this.noticeStartDate;
//     if (this.accommodation != null) {
//       data['accommodation'] =
//           this.accommodation!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Accommodation {
//   String? fromDate;
//   String? toDate;
//   String? branch;
//   String? bedId;
//   String? bed;
//   String? room;
//   String? rent;
//
//   Accommodation(
//       {this.fromDate,
//         this.toDate,
//         this.branch,
//         this.bedId,
//         this.bed,
//         this.room,
//         this.rent});
//
//   Accommodation.fromJson(Map<String, dynamic> json) {
//     fromDate = json['from_date'].toString();
//     toDate = json['to_date'].toString();
//     branch = json['branch'].toString();
//     bedId = json['bed_id'].toString();
//     bed = json['bed'].toString();
//     room = json['room'].toString();
//     rent = json['rent'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['from_date'] = this.fromDate;
//     data['to_date'] = this.toDate;
//     data['branch'] = this.branch;
//     data['bed_id'] = this.bedId;
//     data['bed'] = this.bed;
//     data['room'] = this.room;
//     data['rent'] = this.rent;
//     return data;
//   }
// }
//
// class Amenities {
//   String? amenityName;
//
//   Amenities({this.amenityName});
//
//   Amenities.fromJson(Map<String, dynamic> json) {
//     amenityName = json['amenity_name'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['amenity_name'] = this.amenityName;
//     return data;
//   }
// }
//
// class PgDetails {
//   String? pgName;
//   String? upiRegisterName;
//   String? upiId;
//   String? pgProfile;
//   String? contact;
//   String? qrCode;
//
//   PgDetails(
//       {this.pgName,
//         this.upiRegisterName,
//         this.upiId,
//         this.pgProfile,
//         this.contact,
//         this.qrCode});
//
//   PgDetails.fromJson(Map<String, dynamic> json) {
//     pgName = json['pg_name'].toString();
//     upiRegisterName = json['upi_register_name'].toString();
//     upiId = json['upi_id'].toString();
//     pgProfile = json['pg_profile'];
//     contact = json['contact'];
//     qrCode = json['qr_code'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pg_name'] = this.pgName;
//     data['upi_register_name'] = this.upiRegisterName;
//     data['upi_id'] = this.upiId;
//     data['pg_profile'] = this.pgProfile;
//     data['contact'] = this.contact;
//     data['qr_code'] = this.qrCode;
//     return data;
//   }
// }

