class QuotationModel {
  List<PdfQuote>? pdfQuote;
  String? currentDate;
  String? appVersion;
  String? success;
  String? details;

  QuotationModel(
      {this.pdfQuote,
        this.currentDate,
        this.appVersion,
        this.success,
        this.details});

  QuotationModel.fromJson(Map<String, dynamic> json) {
    if (json['pdfQuote'] != null) {
      pdfQuote = <PdfQuote>[];
      json['pdfQuote'].forEach((v) {
        pdfQuote!.add(new PdfQuote.fromJson(v));
      });
    }
    currentDate = json['current_date'];
    appVersion = json['app_version'];
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pdfQuote != null) {
      data['pdfQuote'] = this.pdfQuote!.map((v) => v.toJson()).toList();
    }
    data['current_date'] = this.currentDate;
    data['app_version'] = this.appVersion;
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}

class PdfQuote {
  int? id;
  String? receiptDate;
  String? resident;
  String? dueAmount;
  String? rentAmt;
  String? advance;
  String? serviceCharge;
  String? electricityCharge;
  String? gasCharge;
  String? waterCharge;
  String? foodCharge;
  String? otherCharge;
  String? discount;
  Null? totalAmt;
  String? remark;
  String? branchId;
  String? roomId;
  String? bedId;
  String? gst;
  String? totalPay;
  Null? quotationNetDueGet;
  Null? quotationNetDueFinal;
  Null? quotationNetAdvance;
  Null? quotationElectricityRate;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? branchName;
  String? residentName;
  String? pgName;
  String? url;
  List<ScreenShortData>? screenShortData;

  PdfQuote(
      {this.id,
        this.receiptDate,
        this.resident,
        this.dueAmount,
        this.rentAmt,
        this.advance,
        this.serviceCharge,
        this.electricityCharge,
        this.gasCharge,
        this.waterCharge,
        this.foodCharge,
        this.otherCharge,
        this.discount,
        this.totalAmt,
        this.remark,
        this.branchId,
        this.roomId,
        this.bedId,
        this.gst,
        this.totalPay,
        this.quotationNetDueGet,
        this.quotationNetDueFinal,
        this.quotationNetAdvance,
        this.quotationElectricityRate,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.branchName,
        this.residentName,
        this.pgName,
        this.url,
        this.screenShortData});

  PdfQuote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptDate = json['receipt_date'];
    resident = json['Resident'];
    dueAmount = json['due_amount'];
    rentAmt = json['rent_amt'];
    advance = json['advance'];
    serviceCharge = json['service_charge'];
    electricityCharge = json['electricity_charge'];
    gasCharge = json['gas_charge'];
    waterCharge = json['water_charge'];
    foodCharge = json['food_charge'];
    otherCharge = json['other_charge'];
    discount = json['discount'];
    totalAmt = json['total_amt'];
    remark = json['remark'];
    branchId = json['branch_id'];
    roomId = json['room_id'];
    bedId = json['bed_id'];
    gst = json['gst'];
    totalPay = json['total_pay'];
    quotationNetDueGet = json['quotation_net_due_get'];
    quotationNetDueFinal = json['quotation_net_due_final'];
    quotationNetAdvance = json['quotation_net_advance'];
    quotationElectricityRate = json['quotation_electricity_rate'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchName = json['branch_name'];
    residentName = json['resident_name'];
    pgName = json['pg_name'];
    url = json['url'];
    if (json['screen_short_data'] != null) {
      screenShortData = <ScreenShortData>[];
      json['screen_short_data'].forEach((v) {
        screenShortData!.add(new ScreenShortData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receipt_date'] = this.receiptDate;
    data['Resident'] = this.resident;
    data['due_amount'] = this.dueAmount;
    data['rent_amt'] = this.rentAmt;
    data['advance'] = this.advance;
    data['service_charge'] = this.serviceCharge;
    data['electricity_charge'] = this.electricityCharge;
    data['gas_charge'] = this.gasCharge;
    data['water_charge'] = this.waterCharge;
    data['food_charge'] = this.foodCharge;
    data['other_charge'] = this.otherCharge;
    data['discount'] = this.discount;
    data['total_amt'] = this.totalAmt;
    data['remark'] = this.remark;
    data['branch_id'] = this.branchId;
    data['room_id'] = this.roomId;
    data['bed_id'] = this.bedId;
    data['gst'] = this.gst;
    data['total_pay'] = this.totalPay;
    data['quotation_net_due_get'] = this.quotationNetDueGet;
    data['quotation_net_due_final'] = this.quotationNetDueFinal;
    data['quotation_net_advance'] = this.quotationNetAdvance;
    data['quotation_electricity_rate'] = this.quotationElectricityRate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['branch_name'] = this.branchName;
    data['resident_name'] = this.residentName;
    data['pg_name'] = this.pgName;
    data['url'] = this.url;
    if (this.screenShortData != null) {
      data['screen_short_data'] =
          this.screenShortData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScreenShortData {
  int? id;
  int? resId;
  int? qtcId;
  int? branchId;
  String? screenShot;
  String? remark;
  int? status;
  String? paymentStatus;
  String? insertedAt;
  String? updatedAt;

  ScreenShortData(
      {this.id,
        this.resId,
        this.qtcId,
        this.branchId,
        this.screenShot,
        this.remark,
        this.status,
        this.paymentStatus,
        this.insertedAt,
        this.updatedAt});

  ScreenShortData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resId = json['res_id'];
    qtcId = json['qtc_id'];
    branchId = json['branch_id'];
    screenShot = json['screen_shot'];
    remark = json['remark'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['res_id'] = this.resId;
    data['qtc_id'] = this.qtcId;
    data['branch_id'] = this.branchId;
    data['screen_shot'] = this.screenShot;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['inserted_at'] = this.insertedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
