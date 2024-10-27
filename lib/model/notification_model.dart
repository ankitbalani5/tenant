/*class NotificationModel {
  bool? result;
  String? msg;
  List<Data>? data;
  List<ReadData>? readData;

  NotificationModel({this.result, this.msg, this.data, this.readData});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    if (json['read_data'] != null) {
      readData = <ReadData>[];
      json['read_data'].forEach((v) {
        readData!.add(new ReadData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.readData != null) {
      data['read_data'] = this.readData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? quotationId;
  int? resId;
  int? pgId;
  int? branchId;
  String? notificationType;
  String? title;
  String? discription;
  String? notificationDate;
  String? status;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;
  String? url;
  String? totalPay;
  String? screenShortImg;
  String? push_flag;
  bool readSattus=false;

  Data(
      {this.id,
        this.quotationId,
        this.resId,
        this.pgId,
        this.branchId,
        this.notificationType,
        this.title,
        this.discription,
        this.notificationDate,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.url,
        this.totalPay,
        this.screenShortImg,
        this.push_flag,
        this.readSattus=false

      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    resId = json['res_id'];
    pgId = json['pg_id'];
    branchId = json['branch_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    discription = json['discription'];
    notificationDate = json['notification_date'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    url = json['url'];
    totalPay = json['total_pay'];
    screenShortImg = json['screen_short_img'];
    push_flag = json['push_flag'];
    readSattus = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['res_id'] = this.resId;
    data['pg_id'] = this.pgId;
    data['branch_id'] = this.branchId;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['notification_date'] = this.notificationDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['total_pay'] = this.totalPay;
    data['screen_short_img'] = this.screenShortImg;
    data['push_flag'] = this.push_flag;
    data['read_status'] = this.readSattus;
    return data;
  }
}
class ReadData {
  int? id;
  String? quotationId;
  int? resId;
  int? pgId;
  int? branchId;
  String? notificationType;
  String? title;
  String? discription;
  String? notificationDate;
  String? status;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;
  String? url;
  String? totalPay;
  String? screenShortImg;
  String? pushFlag;
  bool readSattus=false;

  ReadData(
      {this.id,
        this.quotationId,
        this.resId,
        this.pgId,
        this.branchId,
        this.notificationType,
        this.title,
        this.discription,
        this.notificationDate,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.url,
        this.totalPay,
        this.screenShortImg,
        this.pushFlag,
        this.readSattus=false});

  ReadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    resId = json['res_id'];
    pgId = json['pg_id'];
    branchId = json['branch_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    discription = json['discription'];
    notificationDate = json['notification_date'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    url = json['url'];
    totalPay = json['total_pay'];
    screenShortImg = json['screen_short_img'];
    pushFlag = json['push_flag'];
    readSattus = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['res_id'] = this.resId;
    data['pg_id'] = this.pgId;
    data['branch_id'] = this.branchId;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['notification_date'] = this.notificationDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['total_pay'] = this.totalPay;
    data['screen_short_img'] = this.screenShortImg;
    data['push_flag'] = this.pushFlag;
    data['read_status'] = this.readSattus;
    return data;
  }
}*/

class NotificationModel {
  int? success;
  String? details;
  List<NotificationData>? data;

  NotificationModel({this.success, this.details, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
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

class NotificationData {
  String? id;
  Null? quotationId;
  String? resId;
  String? pgId;
  String? branchId;
  String? notificationType;
  String? title;
  String? discription;
  String? notificationDate;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  NotificationData(
      {this.id,
        this.quotationId,
        this.resId,
        this.pgId,
        this.branchId,
        this.notificationType,
        this.title,
        this.discription,
        this.notificationDate,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    resId = json['res_id'];
    pgId = json['pg_id'];
    branchId = json['branch_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    discription = json['discription'];
    notificationDate = json['notification_date'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['res_id'] = this.resId;
    data['pg_id'] = this.pgId;
    data['branch_id'] = this.branchId;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['notification_date'] = this.notificationDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


/*class NotificationModel {
  int? success;
  String? details;
  NotificationData? data;

  NotificationModel({this.success, this.details, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    data = json['data'] != null ? new NotificationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationData {
  List<ReadData>? read;
  List<Unread>? unread;

  NotificationData({this.read, this.unread});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['read'] != null) {
      read = <ReadData>[];
      json['read'].forEach((v) {
        read!.add(new ReadData.fromJson(v));
      });
    }
    if (json['Unread'] != null) {
      unread = <Unread>[];
      json['Unread'].forEach((v) {
        unread!.add(new Unread.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.read != null) {
      data['read'] = this.read!.map((v) => v.toJson()).toList();
    }
    if (this.unread != null) {
      data['Unread'] = this.unread!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReadData {
  String? id;
  Null? quotationId;
  String? resId;
  String? pgId;
  String? branchId;
  String? notificationType;
  String? title;
  String? discription;
  String? notificationDate;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  ReadData(
      {this.id,
        this.quotationId,
        this.resId,
        this.pgId,
        this.branchId,
        this.notificationType,
        this.title,
        this.discription,
        this.notificationDate,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt});

  ReadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    resId = json['res_id'];
    pgId = json['pg_id'];
    branchId = json['branch_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    discription = json['discription'];
    notificationDate = json['notification_date'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['res_id'] = this.resId;
    data['pg_id'] = this.pgId;
    data['branch_id'] = this.branchId;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['notification_date'] = this.notificationDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Unread {
  String? id;
  Null? quotationId;
  String? resId;
  String? pgId;
  String? branchId;
  String? notificationType;
  String? title;
  String? discription;
  String? notificationDate;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  Unread(
      {this.id,
        this.quotationId,
        this.resId,
        this.pgId,
        this.branchId,
        this.notificationType,
        this.title,
        this.discription,
        this.notificationDate,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt});

  Unread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    resId = json['res_id'];
    pgId = json['pg_id'];
    branchId = json['branch_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    discription = json['discription'];
    notificationDate = json['notification_date'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['res_id'] = this.resId;
    data['pg_id'] = this.pgId;
    data['branch_id'] = this.branchId;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['notification_date'] = this.notificationDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}*/
