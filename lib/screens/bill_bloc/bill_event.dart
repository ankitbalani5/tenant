part of 'bill_bloc.dart';
@immutable
abstract class BillEvent {}

class BillRefreshEvent extends BillEvent {
  final String type;
  final String branch_id;
  final String resident_id;
  final String payment_from;
  final String payment_to;
  BillRefreshEvent(this.type, this.branch_id,
      this.resident_id, this.payment_from,
      this.payment_to);
}