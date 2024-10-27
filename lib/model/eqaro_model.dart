
import 'dart:convert';

EqaroModel eqaroModelFromJson(String str) => EqaroModel.fromJson(json.decode(str));
String logineqaroModelToJson(EqaroModel data) => json.encode(data.toJson());

class EqaroModel {
  int? success;
  String? details;
  List<Data>? data;

  EqaroModel({this.success, this.details, this.data});

  EqaroModel.fromJson(Map<String, dynamic> json) {
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
  ResidentData? residentData;
  String? landlordId;
  String? productId;

  Data({this.residentData, this.landlordId, this.productId});

  Data.fromJson(Map<String, dynamic> json) {
    residentData = json['resident_data'] != null
        ? new ResidentData.fromJson(json['resident_data'])
        : null;
    landlordId = json['landlord_id'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.residentData != null) {
      data['resident_data'] = this.residentData!.toJson();
    }
    data['landlord_id'] = this.landlordId;
    data['productId'] = this.productId;
    return data;
  }
}

class ResidentData {
  User? user;
  Tokens? tokens;
  Access? access;

  ResidentData({this.user, this.tokens, this.access});

  ResidentData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    tokens =
    json['tokens'] != null ? new Tokens.fromJson(json['tokens']) : null;
    access =
    json['access'] != null ? new Access.fromJson(json['access']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.tokens != null) {
      data['tokens'] = this.tokens!.toJson();
    }
    if (this.access != null) {
      data['access'] = this.access!.toJson();
    }
    return data;
  }
}

class User {
  String? userType;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  EmploymentDetails? employmentDetails;
  BusinessDetails? businessDetails;
  String? type;
  bool? consent;
  int? lastCompletedStep;
  int? completedPerc;
  bool? isNewProductOpted;
  String? crmId;
  String? signupCity;
  String? email;
  List<Docs>? docs;
  String? createdAt;
  String? profileId;
  String? avatar;
  String? dob;
  String? gender;
  String? name;
  String? phone;
  String? modifiedBy;
  String? id;
  String? residentId;
  String? eqaroFinalVerification;
  String? aadharVerify;
  String? propertyId;

  User(
      {this.userType,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.employmentDetails,
        this.businessDetails,
        this.type,
        this.consent,
        this.lastCompletedStep,
        this.completedPerc,
        this.isNewProductOpted,
        this.crmId,
        this.signupCity,
        this.email,
        this.docs,
        this.createdAt,
        this.profileId,
        this.avatar,
        this.dob,
        this.gender,
        this.name,
        this.phone,
        this.modifiedBy,
        this.id,
        this.residentId,
        this.eqaroFinalVerification,
        this.aadharVerify,
        this.propertyId});

  User.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    employmentDetails = json['employmentDetails'] != null
        ? new EmploymentDetails.fromJson(json['employmentDetails'])
        : null;
    businessDetails = json['businessDetails'] != null
        ? new BusinessDetails.fromJson(json['businessDetails'])
        : null;
    type = json['type'];
    consent = json['consent'];
    lastCompletedStep = json['lastCompletedStep'];
    completedPerc = json['completedPerc'];
    isNewProductOpted = json['isNewProductOpted'];
    crmId = json['crmId'];
    signupCity = json['signupCity'];
    email = json['email'];
    if (json['docs'] != null) {
      docs = <Docs>[];
      json['docs'].forEach((v) {
        docs!.add(new Docs.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    profileId = json['profileId'];
    avatar = json['avatar'];
    dob = json['dob'];
    gender = json['gender'];
    name = json['name'];
    phone = json['phone'];
    modifiedBy = json['modifiedBy'];
    id = json['id'];
    residentId = json['resident_id'];
    eqaroFinalVerification = json['eqaro_final_verification'];
    aadharVerify = json['aadhar_verify'];
    propertyId = json['property_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isPhoneVerified'] = this.isPhoneVerified;
    if (this.employmentDetails != null) {
      data['employmentDetails'] = this.employmentDetails!.toJson();
    }
    if (this.businessDetails != null) {
      data['businessDetails'] = this.businessDetails!.toJson();
    }
    data['type'] = this.type;
    data['consent'] = this.consent;
    data['lastCompletedStep'] = this.lastCompletedStep;
    data['completedPerc'] = this.completedPerc;
    data['isNewProductOpted'] = this.isNewProductOpted;
    data['crmId'] = this.crmId;
    data['signupCity'] = this.signupCity;
    data['email'] = this.email;
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['profileId'] = this.profileId;
    data['avatar'] = this.avatar;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['modifiedBy'] = this.modifiedBy;
    data['id'] = this.id;
    data['resident_id'] = this.residentId;
    data['eqaro_final_verification'] = this.eqaroFinalVerification;
    data['aadhar_verify'] = this.aadharVerify;
    data['property_id'] = this.propertyId;
    return data;
  }
}

class EmploymentDetails {
  String? employment;
  int? monthlyIncome;
  String? modeVerify;
  String? industry;
  String? designation;
  String? workingExperience;
  int? additionalMonthlyIncome;
  String? additionalIncomeRelation;
  bool? isWorkEmailVerified;
  List<OfficeAddress>? officeAddresses;
  String? workEmail;

  EmploymentDetails(
      {this.employment,
        this.monthlyIncome,
        this.modeVerify,
        this.industry,
        this.designation,
        this.workingExperience,
        this.additionalMonthlyIncome,
        this.additionalIncomeRelation,
        this.isWorkEmailVerified,
        this.officeAddresses,
        this.workEmail});

  EmploymentDetails.fromJson(Map<String, dynamic> json) {
    employment = json['employment'];
    monthlyIncome = json['monthlyIncome'];
    modeVerify = json['modeVerify'];
    industry = json['industry'];
    designation = json['designation'];
    workingExperience = json['workingExperience'];
    additionalMonthlyIncome = json['additionalMonthlyIncome'];
    additionalIncomeRelation = json['additionalIncomeRelation'];
    isWorkEmailVerified = json['isWorkEmailVerified'];
    if (json['officeAddresses'] != null) {
      officeAddresses = <OfficeAddress>[];
      json['officeAddresses'].forEach((v) {
        officeAddresses!.add(OfficeAddress.fromJson(v));
      });
    }
    workEmail = json['workEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employment'] = this.employment;
    data['monthlyIncome'] = this.monthlyIncome;
    data['modeVerify'] = this.modeVerify;
    data['industry'] = this.industry;
    data['designation'] = this.designation;
    data['workingExperience'] = this.workingExperience;
    data['additionalMonthlyIncome'] = this.additionalMonthlyIncome;
    data['additionalIncomeRelation'] = this.additionalIncomeRelation;
    data['isWorkEmailVerified'] = this.isWorkEmailVerified;
        if (officeAddresses != null) {
      data['officeAddresses'] = officeAddresses!.map((v) => v.toJson()).toList();
    }
    data['workEmail'] = this.workEmail;
    return data;
  }
}

class OfficeAddress {
  // Define properties and methods as needed
  OfficeAddress.fromJson(Map<String, dynamic> json) {
    // Parse properties from JSON
  }

  Map<String, dynamic> toJson() {
    // Convert to JSON
    return {};
  }
}


class BusinessDetails {
  List<Partner>? partners;
  List<Director>? directors;
  List<Document>? docs;

  BusinessDetails({this.partners, this.directors, this.docs});

  BusinessDetails.fromJson(Map<String, dynamic> json) {
    if (json['partners'] != null) {
      partners = <Partner>[];
      json['partners'].forEach((v) {
        partners!.add(Partner.fromJson(v));
      });
    }
    if (json['directors'] != null) {
      directors = <Director>[];
      json['directors'].forEach((v) {
        directors!.add(Director.fromJson(v));
      });
    }
    if (json['docs'] != null) {
      docs = <Document>[];
      json['docs'].forEach((v) {
        docs!.add(Document.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (partners != null) {
      data['partners'] = partners!.map((v) => v.toJson()).toList();
    }
    if (directors != null) {
      data['directors'] = directors!.map((v) => v.toJson()).toList();
    }
    if (docs != null) {
      data['docs'] = docs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Placeholder classes for the missing types
class Partner {
  // Add properties and methods as needed
  Partner.fromJson(Map<String, dynamic> json) {
    // Parse properties from JSON
  }

  Map<String, dynamic> toJson() {
    // Convert to JSON
    return {};
  }
}

class Director {
  // Add properties and methods as needed
  Director.fromJson(Map<String, dynamic> json) {
    // Parse properties from JSON
  }

  Map<String, dynamic> toJson() {
    // Convert to JSON
    return {};
  }
}

class Document {
  // Add properties and methods as needed
  Document.fromJson(Map<String, dynamic> json) {
    // Parse properties from JSON
  }

  Map<String, dynamic> toJson() {
    // Convert to JSON
    return {};
  }
}

class Docs {
  String? docType;
  bool? isVerified;
  String? docId;
  String? metadata;

  Docs({this.docType, this.isVerified, this.docId, this.metadata});

  Docs.fromJson(Map<String, dynamic> json) {
    docType = json['docType'];
    isVerified = json['isVerified'];
    docId = json['docId'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docType'] = this.docType;
    data['isVerified'] = this.isVerified;
    data['docId'] = this.docId;
    data['metadata'] = this.metadata;
    return data;
  }
}

class Tokens {
  Access? access;
  Access? refresh;

  Tokens({this.access, this.refresh});

  Tokens.fromJson(Map<String, dynamic> json) {
    access =
    json['access'] != null ? new Access.fromJson(json['access']) : null;
    refresh =
    json['refresh'] != null ? new Access.fromJson(json['refresh']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.access != null) {
      data['access'] = this.access!.toJson();
    }
    if (this.refresh != null) {
      data['refresh'] = this.refresh!.toJson();
    }
    return data;
  }
}

class Access {
  String? token;
  String? expires;

  Access({this.token, this.expires});

  Access.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expires'] = this.expires;
    return data;
  }
}


// class EqaroModel {
//   int? success;
//   String? details;
//   List<Data>? data;
//
//   EqaroModel({this.success, this.details, this.data});
//
//   EqaroModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     details = json['details'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['success'] = this.success;
//     data['details'] = this.details;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   ResidentData? residentData;
//   String? landlordId;
//
//   Data({this.residentData, this.landlordId});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     residentData = json['resident_data'] != null
//         ? ResidentData.fromJson(json['resident_data'])
//         : null;
//     landlordId = json['landlord_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (residentData != null) {
//       data['resident_data'] = residentData!.toJson();
//     }
//     data['landlord_id'] = landlordId;
//     return data;
//   }
// }
//
// class ResidentData {
//   Access? access;
//   User? user;
//
//   ResidentData({this.access, this.user});
//
//   ResidentData.fromJson(Map<String, dynamic> json) {
//     access = json['access'] != null ? Access.fromJson(json['access']) : null;
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (access != null) {
//       data['access'] = access!.toJson();
//     }
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     return data;
//   }
// }
//
// class Access {
//   String? token;
//   String? expires;
//
//   Access({this.token, this.expires});
//
//   Access.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//     expires = json['expires'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['token'] = token;
//     data['expires'] = expires;
//     return data;
//   }
// }
//
// class User {
//   String? userType;
//   bool? isEmailVerified;
//   bool? isPhoneVerified;
//   EmploymentDetails? employmentDetails;
//   BusinessDetails? businessDetails;
//   String? type;
//   bool? consent;
//   int? lastCompletedStep;
//   int? completedPerc;
//   bool? isNewProductOpted;
//   String? crmId;
//   String? signupCity;
//   String? email;
//   List<String>? docs;
//   String? createdAt;
//   String? profileId;
//   String? id;
//   String? residentId;
//   String? aadharVerify;
//   String? dob;
//   String? gender;
//
//   User(
//       {this.userType,
//         this.isEmailVerified,
//         this.isPhoneVerified,
//         this.employmentDetails,
//         this.businessDetails,
//         this.type,
//         this.consent,
//         this.lastCompletedStep,
//         this.completedPerc,
//         this.isNewProductOpted,
//         this.crmId,
//         this.signupCity,
//         this.email,
//         this.docs,
//         this.createdAt,
//         this.profileId,
//         this.id,
//         this.residentId,
//         this.aadharVerify,
//         this.dob,
//         this.gender});
//
//   User.fromJson(Map<String, dynamic> json) {
//     userType = json['userType'];
//     isEmailVerified = json['isEmailVerified'];
//     isPhoneVerified = json['isPhoneVerified'];
//     employmentDetails = json['employmentDetails'] != null
//         ? EmploymentDetails.fromJson(json['employmentDetails'])
//         : null;
//     businessDetails = json['businessDetails'] != null
//         ? BusinessDetails.fromJson(json['businessDetails'])
//         : null;
//     type = json['type'];
//     consent = json['consent'];
//     lastCompletedStep = json['lastCompletedStep'];
//     completedPerc = json['completedPerc'];
//     isNewProductOpted = json['isNewProductOpted'];
//     crmId = json['crmId'];
//     signupCity = json['signupCity'];
//     email = json['email'];
//     /*if (json['docs'] != null) {
//       docs = <Null>[];
//       json['docs'].forEach((v) {
//         docs!.add(Null.fromJson(v));
//       });
//     }*/
//     docs = json['docs'] != null ? List<String>.from(json['docs']) : null; // Adjustments made here
//
//     createdAt = json['createdAt'];
//     profileId = json['profileId'];
//     id = json['id'];
//     residentId = json['resident_id'];
//     aadharVerify = json['aadhar_verify'];
//     dob = json['dob'];
//     gender = json['gender'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['userType'] = userType;
//     data['isEmailVerified'] = isEmailVerified;
//     data['isPhoneVerified'] = isPhoneVerified;
//     if (employmentDetails != null) {
//       data['employmentDetails'] = employmentDetails!.toJson();
//     }
//     if (businessDetails != null) {
//       data['businessDetails'] = businessDetails!.toJson();
//     }
//     data['type'] = type;
//     data['consent'] = consent;
//     data['lastCompletedStep'] = lastCompletedStep;
//     data['completedPerc'] = completedPerc;
//     data['isNewProductOpted'] = isNewProductOpted;
//     data['crmId'] = crmId;
//     data['signupCity'] = signupCity;
//     data['email'] = email;
//     /*if (docs != null) {
//       data['docs'] = docs!.map((v) => v.toJson()).toList();
//     }*/
//     data['docs'] = docs; // Adjustments made here
//
//     data['createdAt'] = createdAt;
//     data['profileId'] = profileId;
//     data['id'] = id;
//     data['resident_id'] = residentId;
//     data['aadhar_verify'] = this.aadharVerify;
//     data['dob'] = this.dob;
//     data['gender'] = this.gender;
//     return data;
//   }
// }
//
// class EmploymentDetails {
//   String? employment;
//   int? monthlyIncome;
//   String? modeVerify;
//   String? industry;
//   String? designation;
//   String? workingExperience;
//   int? additionalMonthlyIncome;
//   String? additionalIncomeRelation;
//   bool? isWorkEmailVerified;
//   List<OfficeAddress>? officeAddresses;
//
//   EmploymentDetails(
//       {this.employment,
//         this.monthlyIncome,
//         this.modeVerify,
//         this.industry,
//         this.designation,
//         this.workingExperience,
//         this.additionalMonthlyIncome,
//         this.additionalIncomeRelation,
//         this.isWorkEmailVerified,
//         this.officeAddresses});
//
//   EmploymentDetails.fromJson(Map<String, dynamic> json) {
//     employment = json['employment'];
//     monthlyIncome = json['monthlyIncome'];
//     modeVerify = json['modeVerify'];
//     industry = json['industry'];
//     designation = json['designation'];
//     workingExperience = json['workingExperience'];
//     additionalMonthlyIncome = json['additionalMonthlyIncome'];
//     additionalIncomeRelation = json['additionalIncomeRelation'];
//     isWorkEmailVerified = json['isWorkEmailVerified'];
//     if (json['officeAddresses'] != null) {
//       officeAddresses = <OfficeAddress>[];
//       json['officeAddresses'].forEach((v) {
//         officeAddresses!.add(OfficeAddress.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['employment'] = employment;
//     data['monthlyIncome'] = monthlyIncome;
//     data['modeVerify'] = modeVerify;
//     data['industry'] = industry;
//     data['designation'] = designation;
//     data['workingExperience'] = workingExperience;
//     data['additionalMonthlyIncome'] = additionalMonthlyIncome;
//     data['additionalIncomeRelation'] = additionalIncomeRelation;
//     data['isWorkEmailVerified'] = isWorkEmailVerified;
//     if (officeAddresses != null) {
//       data['officeAddresses'] = officeAddresses!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OfficeAddress {
//   // Define properties and methods as needed
//   OfficeAddress.fromJson(Map<String, dynamic> json) {
//     // Parse properties from JSON
//   }
//
//   Map<String, dynamic> toJson() {
//     // Convert to JSON
//     return {};
//   }
// }
//
// class BusinessDetails {
//   List<Partner>? partners;
//   List<Director>? directors;
//   List<Document>? docs;
//
//   BusinessDetails({this.partners, this.directors, this.docs});
//
//   BusinessDetails.fromJson(Map<String, dynamic> json) {
//     if (json['partners'] != null) {
//       partners = <Partner>[];
//       json['partners'].forEach((v) {
//         partners!.add(Partner.fromJson(v));
//       });
//     }
//     if (json['directors'] != null) {
//       directors = <Director>[];
//       json['directors'].forEach((v) {
//         directors!.add(Director.fromJson(v));
//       });
//     }
//     if (json['docs'] != null) {
//       docs = <Document>[];
//       json['docs'].forEach((v) {
//         docs!.add(Document.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (partners != null) {
//       data['partners'] = partners!.map((v) => v.toJson()).toList();
//     }
//     if (directors != null) {
//       data['directors'] = directors!.map((v) => v.toJson()).toList();
//     }
//     if (docs != null) {
//       data['docs'] = docs!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// // Placeholder classes for the missing types
// class Partner {
//   // Add properties and methods as needed
//   Partner.fromJson(Map<String, dynamic> json) {
//     // Parse properties from JSON
//   }
//
//   Map<String, dynamic> toJson() {
//     // Convert to JSON
//     return {};
//   }
// }
//
// class Director {
//   // Add properties and methods as needed
//   Director.fromJson(Map<String, dynamic> json) {
//     // Parse properties from JSON
//   }
//
//   Map<String, dynamic> toJson() {
//     // Convert to JSON
//     return {};
//   }
// }
//
// class Document {
//   // Add properties and methods as needed
//   Document.fromJson(Map<String, dynamic> json) {
//     // Parse properties from JSON
//   }
//
//   Map<String, dynamic> toJson() {
//     // Convert to JSON
//     return {};
//   }
// }

