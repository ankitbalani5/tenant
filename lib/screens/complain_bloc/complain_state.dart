part of 'complain_bloc.dart';
@immutable
abstract class ComplainState {}

class ComplainInitial extends ComplainState {}

class ComplainLoading extends ComplainState {}

class ComplainSuccess extends ComplainState {
  final ComplainModel complainModel;
  ComplainSuccess(this.complainModel);
}

class ComplainError extends ComplainState {
  final String error;
  ComplainError(this.error);
}