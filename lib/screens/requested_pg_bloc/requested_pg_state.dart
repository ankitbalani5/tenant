part of 'requested_pg_bloc.dart';


@immutable
abstract class RequestedPgState {}

class RequestedPgInitial extends RequestedPgState {}

class RequestedPgLoading extends RequestedPgState{}

class RequestedPgSuccess extends RequestedPgState {
  final RequestedPgModel requestedPgModel;
  RequestedPgSuccess(this.requestedPgModel);
}

class RequestedPgError extends RequestedPgState {
  final String errorMsg;
  RequestedPgError(this.errorMsg);
}