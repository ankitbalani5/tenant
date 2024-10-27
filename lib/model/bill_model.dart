import 'dart:convert';

/// payments : [{"payment_id":6965,"receipt_no":"Rec-20","res_id":2796,"bed_name":"Bed 2","room_name":"Room 2","amount":"3000","net_amount":"3000","receipt_date":"24-Jan-2023","paymode":"Cash","paymode_trans_id":"","unique_id":"1063cf6aa6d40f9","remarks":"","url":"https://testdashboard.btroomer.com/getInvoice/Mjc5Ng==/1063cf6aa6d40f9"},{"payment_id":6946,"receipt_no":"Rec-12","res_id":2796,"bed_name":"window-01","room_name":"Room-08","amount":"0","net_amount":"0","receipt_date":"21-Jan-2023","paymode":"Cash","paymode_trans_id":"","unique_id":"1063cb968179861","remarks":"","url":"https://testdashboard.btroomer.com/getInvoice/Mjc5Ng==/1063cb968179861"},{"payment_id":6945,"receipt_no":"Rec-11","res_id":2796,"bed_name":"window-01","room_name":"Room-08","amount":"0","net_amount":"5000","receipt_date":"21-Jan-2023","paymode":"Cash","paymode_trans_id":"","unique_id":"1063cb9652d59fa","remarks":"","url":"https://testdashboard.btroomer.com/getInvoice/Mjc5Ng==/1063cb9652d59fa"}]
/// success : "1"
/// details : "Data Fetched Successfully"
BillModel billModelFromJson(String str) => BillModel.fromJson(json.decode(str));

String billModelToJson(BillModel data) => json.encode(data.toJson());

class BillModel {
  BillModel({
      List<Payments>? payments, 
      String? success, 
      String? details,}){
    _payments = payments;
    _success = success;
    _details = details;
}

  BillModel.fromJson(dynamic json) {
    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }
    _success = json['success'];
    _details = json['details'];
  }
  List<Payments>? _payments;
  String? _success;
  String? _details;
BillModel copyWith({  List<Payments>? payments,
  String? success,
  String? details,
}) => BillModel(  payments: payments ?? _payments,
  success: success ?? _success,
  details: details ?? _details,
);
  List<Payments>? get payments => _payments;
  String? get success => _success;
  String? get details => _details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['details'] = _details;
    return map;
  }

}

/// payment_id : 6965
/// receipt_no : "Rec-20"
/// res_id : 2796
/// bed_name : "Bed 2"
/// room_name : "Room 2"
/// amount : "3000"
/// net_amount : "3000"
/// receipt_date : "24-Jan-2023"
/// paymode : "Cash"
/// paymode_trans_id : ""
/// unique_id : "1063cf6aa6d40f9"
/// remarks : ""
/// url : "https://testdashboard.btroomer.com/getInvoice/Mjc5Ng==/1063cf6aa6d40f9"

class Payments {
  Payments({
      num? paymentId, 
      String? receiptNo, 
      num? resId, 
      String? bedName, 
      String? roomName, 
      String? amount, 
      String? netAmount, 
      String? receiptDate, 
      String? paymode, 
      String? paymodeTransId, 
      String? uniqueId, 
      String? remarks, 
      String? url,}){
    _paymentId = paymentId;
    _receiptNo = receiptNo;
    _resId = resId;
    _bedName = bedName;
    _roomName = roomName;
    _amount = amount;
    _netAmount = netAmount;
    _receiptDate = receiptDate;
    _paymode = paymode;
    _paymodeTransId = paymodeTransId;
    _uniqueId = uniqueId;
    _remarks = remarks;
    _url = url;
}

  Payments.fromJson(dynamic json) {
    _paymentId = json['payment_id'];
    _receiptNo = json['receipt_no'];
    _resId = json['res_id'];
    _bedName = json['bed_name'];
    _roomName = json['room_name'];
    _amount = json['amount'];
    _netAmount = json['net_amount'];
    _receiptDate = json['receipt_date'];
    _paymode = json['paymode'];
    _paymodeTransId = json['paymode_trans_id'];
    _uniqueId = json['unique_id'];
    _remarks = json['remarks'];
    _url = json['url'];
  }
  num? _paymentId;
  String? _receiptNo;
  num? _resId;
  String? _bedName;
  String? _roomName;
  String? _amount;
  String? _netAmount;
  String? _receiptDate;
  String? _paymode;
  String? _paymodeTransId;
  String? _uniqueId;
  String? _remarks;
  String? _url;
Payments copyWith({  num? paymentId,
  String? receiptNo,
  num? resId,
  String? bedName,
  String? roomName,
  String? amount,
  String? netAmount,
  String? receiptDate,
  String? paymode,
  String? paymodeTransId,
  String? uniqueId,
  String? remarks,
  String? url,
}) => Payments(  paymentId: paymentId ?? _paymentId,
  receiptNo: receiptNo ?? _receiptNo,
  resId: resId ?? _resId,
  bedName: bedName ?? _bedName,
  roomName: roomName ?? _roomName,
  amount: amount ?? _amount,
  netAmount: netAmount ?? _netAmount,
  receiptDate: receiptDate ?? _receiptDate,
  paymode: paymode ?? _paymode,
  paymodeTransId: paymodeTransId ?? _paymodeTransId,
  uniqueId: uniqueId ?? _uniqueId,
  remarks: remarks ?? _remarks,
  url: url ?? _url,
);
  num? get paymentId => _paymentId;
  String? get receiptNo => _receiptNo;
  num? get resId => _resId;
  String? get bedName => _bedName;
  String? get roomName => _roomName;
  String? get amount => _amount;
  String? get netAmount => _netAmount;
  String? get receiptDate => _receiptDate;
  String? get paymode => _paymode;
  String? get paymodeTransId => _paymodeTransId;
  String? get uniqueId => _uniqueId;
  String? get remarks => _remarks;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_id'] = _paymentId;
    map['receipt_no'] = _receiptNo;
    map['res_id'] = _resId;
    map['bed_name'] = _bedName;
    map['room_name'] = _roomName;
    map['amount'] = _amount;
    map['net_amount'] = _netAmount;
    map['receipt_date'] = _receiptDate;
    map['paymode'] = _paymode;
    map['paymode_trans_id'] = _paymodeTransId;
    map['unique_id'] = _uniqueId;
    map['remarks'] = _remarks;
    map['url'] = _url;
    return map;
  }

}