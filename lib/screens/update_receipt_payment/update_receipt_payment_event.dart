part of 'update_receipt_payment_bloc.dart';

@immutable
abstract class UpdateReceiptPaymentEvent {
  const UpdateReceiptPaymentEvent();
}

class UpdateReceiptPaymentRefreshEvent extends UpdateReceiptPaymentEvent {
  String type;
  String branch_id;
  String tenant_id;
  String transaction_amount;
  String pay_mode;
  String payment_transaction_date;
  String payment_transation_id;
  String transaction_remark;
  String payment_id;
  UpdateReceiptPaymentRefreshEvent(this.type, this.branch_id, this.tenant_id,
      this.transaction_amount, this.pay_mode, this.payment_transaction_date,
      this.payment_transation_id, this.transaction_remark, this.payment_id);
}