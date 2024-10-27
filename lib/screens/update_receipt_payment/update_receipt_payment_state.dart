part of 'update_receipt_payment_bloc.dart';

abstract class UpdateReceiptPaymentState {}

class UpdateReceiptPaymentInitial extends UpdateReceiptPaymentState{}

class UpdateReceiptPaymentLoading extends UpdateReceiptPaymentState{}

class UpdateReceiptPaymentSuccess extends UpdateReceiptPaymentState{
  UpdateReceiptPaymentModel updateReceiptPaymentModel;
  UpdateReceiptPaymentSuccess(this.updateReceiptPaymentModel);
}

class UpdateReceiptPaymentError extends UpdateReceiptPaymentState{
  String error;
  UpdateReceiptPaymentError(this.error);
}