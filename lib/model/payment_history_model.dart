import 'dart:convert';

PaymentHistoryModel paymentHistoryModelFromJson(String str) => PaymentHistoryModel.fromJson(json.decode(str));
String paymentHistoryModelToJson(PaymentHistoryModel data) => json.encode(data.toJson());

class PaymentHistoryModel {
  int? success;
  String? details;
  List<Data>? data;

  PaymentHistoryModel({this.success, this.details, this.data});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'PaymentHistoryModel{success: $success, details: $details, data: $data}';
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
  String? id;
  String? branchId;
  String? roomId;
  String? flatId;
  String? bedId;
  String? receiptNo;
  String? resId;
  String? transactionDate;
  String? receiptDate;
  String? dueDate;
  String? amount;
  String? electricityCharges;
  String? gasCharges;
  String? waterCharges;
  String? gst;
  String? discountAmt;
  String? otherCharges;
  String? dueAmount;
  String? advanceAmount;
  String? netAmount;
  String? paymentDays;
  String? perDayPaymentsum;
  String? paymode;
  String? service;
  String? paymodeTransId;
  String? uniqueId;
  String? remarks;
  String? securityAmount;
  String? collectionAgent;
  String? relaseRemark;
  String? penaltyCharges;
  String? status;
  String? isSettlement;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? registrationDate;
  String? residentName;
  String? residentContatct;
  String? gender;
  String? martialStatus;
  String? address;
  String? mailId;
  String? district;
  String? state;
  String? dob;
  String? foodStatus;
  String? courses;
  String? organization;
  String? rent;
  String? renewalPlan;
  String? registrationDateCheck;
  String? releaseDate;
  String? totalDue;
  String? lastUnit;
  String? totalAdvance;
  String? policeThana;
  String? pinCode;
  String? policeVerificationCode;
  String? source;
  String? govtId;
  String? agreementDate;
  String? remark;
  String? deviceId;
  String? imeiNo;
  String? paymentId;
  String? roomBed;
  String? receivedAmount;
  String? pendingAmount;
  String? receiptStatus;
  String? receiptUrl;

  Data(
      {this.id,
        this.branchId,
        this.roomId,
        this.flatId,
        this.bedId,
        this.receiptNo,
        this.resId,
        this.transactionDate,
        this.receiptDate,
        this.dueDate,
        this.amount,
        this.electricityCharges,
        this.gasCharges,
        this.waterCharges,
        this.gst,
        this.discountAmt,
        this.otherCharges,
        this.dueAmount,
        this.advanceAmount,
        this.netAmount,
        this.paymentDays,
        this.perDayPaymentsum,
        this.paymode,
        this.service,
        this.paymodeTransId,
        this.uniqueId,
        this.remarks,
        this.securityAmount,
        this.collectionAgent,
        this.relaseRemark,
        this.penaltyCharges,
        this.status,
        this.isSettlement,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.registrationDate,
        this.residentName,
        this.residentContatct,
        this.gender,
        this.martialStatus,
        this.address,
        this.mailId,
        this.district,
        this.state,
        this.dob,
        this.foodStatus,
        this.courses,
        this.organization,
        this.rent,
        this.renewalPlan,
        this.registrationDateCheck,
        this.releaseDate,
        this.totalDue,
        this.lastUnit,
        this.totalAdvance,
        this.policeThana,
        this.pinCode,
        this.policeVerificationCode,
        this.source,
        this.govtId,
        this.agreementDate,
        this.remark,
        this.deviceId,
        this.imeiNo,
        this.paymentId,
        this.roomBed,
        this.receivedAmount,
        this.pendingAmount,
        this.receiptStatus,
        this.receiptUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    roomId = json['room_id'];
    flatId = json['flat_id'];
    bedId = json['bed_id'];
    receiptNo = json['receipt_no'];
    resId = json['res_id'];
    transactionDate = json['transaction_date'];
    receiptDate = json['receipt_date'];
    dueDate = json['due_date'];
    amount = json['amount'];
    electricityCharges = json['electricity_charges'];
    gasCharges = json['gas_charges'];
    waterCharges = json['water_charges'];
    gst = json['gst'];
    discountAmt = json['discount_amt'];
    otherCharges = json['other_charges'];
    dueAmount = json['due_amount'];
    advanceAmount = json['advance_amount'];
    netAmount = json['net_amount'];
    paymentDays = json['payment_days'];
    perDayPaymentsum = json['per_day_paymentsum'];
    paymode = json['paymode'];
    service = json['service'];
    paymodeTransId = json['paymode_trans_id'];
    uniqueId = json['unique_id'];
    remarks = json['remarks'];
    securityAmount = json['security_amount'];
    collectionAgent = json['collection_agent'];
    relaseRemark = json['relase_remark'];
    penaltyCharges = json['penalty_charges'];
    status = json['status'];
    isSettlement = json['is_settlement'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    registrationDate = json['registration_date'];
    residentName = json['resident_name'];
    residentContatct = json['resident_contatct'];
    gender = json['gender'];
    martialStatus = json['martial_status'];
    address = json['address'];
    mailId = json['mail_id'];
    district = json['district'];
    state = json['state'];
    dob = json['dob'];
    foodStatus = json['food_status'];
    courses = json['courses'];
    organization = json['organization'];
    rent = json['rent'];
    renewalPlan = json['renewal_plan'];
    registrationDateCheck = json['registration_date_check'];
    releaseDate = json['release_date'];
    totalDue = json['total_due'];
    lastUnit = json['last_unit'];
    totalAdvance = json['total_advance'];
    policeThana = json['police_thana'];
    pinCode = json['pin_code'];
    policeVerificationCode = json['police_verification_code'];
    source = json['source'];
    govtId = json['govt_id'];
    agreementDate = json['agreement_date'];
    remark = json['remark'];
    deviceId = json['device_id'];
    imeiNo = json['imei_no'];
    paymentId = json['payment_id'];
    roomBed = json['room_bed'];
    receivedAmount = json['received_amount'].toString();
    pendingAmount = json['pending_amount'].toString();
    receiptStatus = json['receipt_status'];
    receiptUrl = json['receipt_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['room_id'] = this.roomId;
    data['flat_id'] = this.flatId;
    data['bed_id'] = this.bedId;
    data['receipt_no'] = this.receiptNo;
    data['res_id'] = this.resId;
    data['transaction_date'] = this.transactionDate;
    data['receipt_date'] = this.receiptDate;
    data['due_date'] = this.dueDate;
    data['amount'] = this.amount;
    data['electricity_charges'] = this.electricityCharges;
    data['gas_charges'] = this.gasCharges;
    data['water_charges'] = this.waterCharges;
    data['gst'] = this.gst;
    data['discount_amt'] = this.discountAmt;
    data['other_charges'] = this.otherCharges;
    data['due_amount'] = this.dueAmount;
    data['advance_amount'] = this.advanceAmount;
    data['net_amount'] = this.netAmount;
    data['payment_days'] = this.paymentDays;
    data['per_day_paymentsum'] = this.perDayPaymentsum;
    data['paymode'] = this.paymode;
    data['service'] = this.service;
    data['paymode_trans_id'] = this.paymodeTransId;
    data['unique_id'] = this.uniqueId;
    data['remarks'] = this.remarks;
    data['security_amount'] = this.securityAmount;
    data['collection_agent'] = this.collectionAgent;
    data['relase_remark'] = this.relaseRemark;
    data['penalty_charges'] = this.penaltyCharges;
    data['status'] = this.status;
    data['is_settlement'] = this.isSettlement;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['registration_date'] = this.registrationDate;
    data['resident_name'] = this.residentName;
    data['resident_contatct'] = this.residentContatct;
    data['gender'] = this.gender;
    data['martial_status'] = this.martialStatus;
    data['address'] = this.address;
    data['mail_id'] = this.mailId;
    data['district'] = this.district;
    data['state'] = this.state;
    data['dob'] = this.dob;
    data['food_status'] = this.foodStatus;
    data['courses'] = this.courses;
    data['organization'] = this.organization;
    data['rent'] = this.rent;
    data['renewal_plan'] = this.renewalPlan;
    data['registration_date_check'] = this.registrationDateCheck;
    data['release_date'] = this.releaseDate;
    data['total_due'] = this.totalDue;
    data['last_unit'] = this.lastUnit;
    data['total_advance'] = this.totalAdvance;
    data['police_thana'] = this.policeThana;
    data['pin_code'] = this.pinCode;
    data['police_verification_code'] = this.policeVerificationCode;
    data['source'] = this.source;
    data['govt_id'] = this.govtId;
    data['agreement_date'] = this.agreementDate;
    data['remark'] = this.remark;
    data['device_id'] = this.deviceId;
    data['imei_no'] = this.imeiNo;
    data['payment_id'] = this.paymentId;
    data['room_bed'] = this.roomBed;
    data['received_amount'] = this.receivedAmount.toString();
    data['pending_amount'] = this.pendingAmount.toString();
    data['receipt_status'] = this.receiptStatus;
    data['receipt_url'] = this.receiptUrl;
    return data;
  }
}
