part of 'interested_bloc.dart';

@immutable
abstract class InterestedState {}

class InterestedInitial extends InterestedState {}

class InterestedLoading extends InterestedState {}

class InterestedSuccess extends InterestedState {
  final InterestedModel interestedModel;
  InterestedSuccess(this.interestedModel);
}
class InterestedError extends InterestedState {
  String error;
  InterestedError(this.error);
}

