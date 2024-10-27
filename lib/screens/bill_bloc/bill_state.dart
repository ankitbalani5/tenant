part of 'bill_bloc.dart';

@immutable
abstract class BillState {}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillSuccess extends BillState {
  final PaymentHistoryModel paymentHistoryModel;
  BillSuccess(this.paymentHistoryModel);
}

class BillError extends BillState {
  final String error;
  BillError(this.error);
}