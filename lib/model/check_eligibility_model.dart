class CheckEligibilityModel {
  List<String>? errors;
  // dynamic status;
  Eligibility? eligibility;

  CheckEligibilityModel({this.errors, this.status, this.eligibility});



  String? status; // Change dynamic to String

  CheckEligibilityModel.fromJson(Map<String, dynamic> json) {
    errors = json['errors'] != null ? List<String>.from(json['errors']) : null;
    status = json['status']; // No type casting needed
    eligibility = json['eligibility'] != null
        ? Eligibility.fromJson(json['eligibility'])
        : null;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errors'] = errors;
    data['status'] = status;
    if (eligibility != null) {
      data['eligibility'] = eligibility!.toJson();
    }
    return data;
  }
}

class Eligibility {
  String? messageToShow;
  String? profileScore;
  List<String>? reasonOfIneligibility; // Assuming reasonOfIneligibility is a list of strings
  String? status;
  bool? isManuallyVerified;
  String? maxEligibilityAmount;
  String? remainingEligibilityAmount;
  String? comments;
  bool? tenantInformed;
  String? userId;
  String? createdAt;
  String? id;

  Eligibility({
    this.messageToShow,
    this.profileScore,
    this.reasonOfIneligibility,
    this.status,
    this.isManuallyVerified,
    this.maxEligibilityAmount,
    this.remainingEligibilityAmount,
    this.comments,
    this.tenantInformed,
    this.userId,
    this.createdAt,
    this.id,
  });

  Eligibility.fromJson(Map<String, dynamic> json) {
    messageToShow = json['messageToShow'];
    profileScore = json['profileScore'].toString();
    reasonOfIneligibility =
        json['reasonOfIneligibility']?.cast<String>(); // Assuming reasonOfIneligibility is a list of strings
    status = json['status'];
    isManuallyVerified = json['isManuallyVerified'];
    maxEligibilityAmount = json['maxEligibilityAmount'].toString();
    remainingEligibilityAmount = json['remainingEligibilityAmount'].toString();
    comments = json['comments'];
    tenantInformed = json['tenantInformed'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageToShow'] = messageToShow;
    data['profileScore'] = profileScore.toString();
    data['reasonOfIneligibility'] = reasonOfIneligibility;
    data['status'] = status;
    data['isManuallyVerified'] = isManuallyVerified.toString();
    data['maxEligibilityAmount'] = maxEligibilityAmount.toString();
    data['remainingEligibilityAmount'] = remainingEligibilityAmount;
    data['comments'] = comments;
    data['tenantInformed'] = tenantInformed;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['id'] = id;
    return data;
  }
}


// class CheckModel {
//   List<Null>? _errors;
//   String? _status;
//   Eligibility? _eligibility;
//
//   CheckModel({List<Null>? errors, String? status, Eligibility? eligibility}) {
//     if (errors != null) {
//       this._errors = errors;
//     }
//     if (status != null) {
//       this._status = status;
//     }
//     if (eligibility != null) {
//       this._eligibility = eligibility;
//     }
//   }
//
//   List<Null>? get errors => _errors;
//   set errors(List<Null>? errors) => _errors = errors;
//   String? get status => _status;
//   set status(String? status) => _status = status;
//   Eligibility? get eligibility => _eligibility;
//   set eligibility(Eligibility? eligibility) => _eligibility = eligibility;
//
//   CheckModel.fromJson(Map<String, dynamic> json) {
//     if (json['errors'] != null) {
//       _errors = <Null>[];
//       json['errors'].forEach((v) {
//         _errors!.add(new Null.fromJson(v));
//       });
//     }
//     _status = json['status'];
//     _eligibility = json['eligibility'] != null
//         ? new Eligibility.fromJson(json['eligibility'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this._errors != null) {
//       data['errors'] = this._errors!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this._status;
//     if (this._eligibility != null) {
//       data['eligibility'] = this._eligibility!.toJson();
//     }
//     return data;
//   }
// }
//
// class Eligibility {
//   String? _messageToShow;
//   String? _profileScore;
//   List<Null>? _reasonOfIneligibility;
//   String? _status;
//   bool? _isManuallyVerified;
//   int? _maxEligibilityAmount;
//   int? _remainingEligibilityAmount;
//   String? _comments;
//   bool? _tenantInformed;
//   String? _userId;
//   String? _createdAt;
//   String? _id;
//
//   Eligibility(
//       {String? messageToShow,
//         String? profileScore,
//         List<Null>? reasonOfIneligibility,
//         String? status,
//         bool? isManuallyVerified,
//         int? maxEligibilityAmount,
//         int? remainingEligibilityAmount,
//         String? comments,
//         bool? tenantInformed,
//         String? userId,
//         String? createdAt,
//         String? id}) {
//     if (messageToShow != null) {
//       this._messageToShow = messageToShow;
//     }
//     if (profileScore != null) {
//       this._profileScore = profileScore;
//     }
//     if (reasonOfIneligibility != null) {
//       this._reasonOfIneligibility = reasonOfIneligibility;
//     }
//     if (status != null) {
//       this._status = status;
//     }
//     if (isManuallyVerified != null) {
//       this._isManuallyVerified = isManuallyVerified;
//     }
//     if (maxEligibilityAmount != null) {
//       this._maxEligibilityAmount = maxEligibilityAmount;
//     }
//     if (remainingEligibilityAmount != null) {
//       this._remainingEligibilityAmount = remainingEligibilityAmount;
//     }
//     if (comments != null) {
//       this._comments = comments;
//     }
//     if (tenantInformed != null) {
//       this._tenantInformed = tenantInformed;
//     }
//     if (userId != null) {
//       this._userId = userId;
//     }
//     if (createdAt != null) {
//       this._createdAt = createdAt;
//     }
//     if (id != null) {
//       this._id = id;
//     }
//   }
//
//   String? get messageToShow => _messageToShow;
//   set messageToShow(String? messageToShow) => _messageToShow = messageToShow;
//   String? get profileScore => _profileScore;
//   set profileScore(String? profileScore) => _profileScore = profileScore;
//   List<Null>? get reasonOfIneligibility => _reasonOfIneligibility;
//   set reasonOfIneligibility(List<Null>? reasonOfIneligibility) =>
//       _reasonOfIneligibility = reasonOfIneligibility;
//   String? get status => _status;
//   set status(String? status) => _status = status;
//   bool? get isManuallyVerified => _isManuallyVerified;
//   set isManuallyVerified(bool? isManuallyVerified) =>
//       _isManuallyVerified = isManuallyVerified;
//   int? get maxEligibilityAmount => _maxEligibilityAmount;
//   set maxEligibilityAmount(int? maxEligibilityAmount) =>
//       _maxEligibilityAmount = maxEligibilityAmount;
//   int? get remainingEligibilityAmount => _remainingEligibilityAmount;
//   set remainingEligibilityAmount(int? remainingEligibilityAmount) =>
//       _remainingEligibilityAmount = remainingEligibilityAmount;
//   String? get comments => _comments;
//   set comments(String? comments) => _comments = comments;
//   bool? get tenantInformed => _tenantInformed;
//   set tenantInformed(bool? tenantInformed) => _tenantInformed = tenantInformed;
//   String? get userId => _userId;
//   set userId(String? userId) => _userId = userId;
//   String? get createdAt => _createdAt;
//   set createdAt(String? createdAt) => _createdAt = createdAt;
//   String? get id => _id;
//   set id(String? id) => _id = id;
//
//   Eligibility.fromJson(Map<String, dynamic> json) {
//     _messageToShow = json['messageToShow'];
//     _profileScore = json['profileScore'];
//     if (json['reasonOfIneligibility'] != null) {
//       _reasonOfIneligibility = <Null>[];
//       json['reasonOfIneligibility'].forEach((v) {
//         _reasonOfIneligibility!.add(new Null.fromJson(v));
//       });
//     }
//     _status = json['status'];
//     _isManuallyVerified = json['isManuallyVerified'];
//     _maxEligibilityAmount = json['maxEligibilityAmount'];
//     _remainingEligibilityAmount = json['remainingEligibilityAmount'];
//     _comments = json['comments'];
//     _tenantInformed = json['tenantInformed'];
//     _userId = json['userId'];
//     _createdAt = json['createdAt'];
//     _id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['messageToShow'] = this._messageToShow;
//     data['profileScore'] = this._profileScore;
//     if (this._reasonOfIneligibility != null) {
//       data['reasonOfIneligibility'] =
//           this._reasonOfIneligibility!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this._status;
//     data['isManuallyVerified'] = this._isManuallyVerified;
//     data['maxEligibilityAmount'] = this._maxEligibilityAmount;
//     data['remainingEligibilityAmount'] = this._remainingEligibilityAmount;
//     data['comments'] = this._comments;
//     data['tenantInformed'] = this._tenantInformed;
//     data['userId'] = this._userId;
//     data['createdAt'] = this._createdAt;
//     data['id'] = this._id;
//     return data;
//   }
// }
