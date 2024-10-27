part of 'requested_pg_bloc.dart';

@immutable
abstract class RequestedPgEvent {
  final String mobile_no;
  const RequestedPgEvent(this.mobile_no,);
}

class RequestedPgRefreshEvent extends RequestedPgEvent {
  const RequestedPgRefreshEvent(super.mobile_no);
}