part of 'booknow_bloc.dart';

@immutable
abstract class BookNowState {}

class BookNowInitial extends BookNowState {}

class BookNowLoading extends BookNowState {}

class BookNowSuccess extends BookNowState {
  final BookNowModel bookNowModel;
  BookNowSuccess(this.bookNowModel);
}
class BookNowError extends BookNowState {
  String error;
  BookNowError(this.error);
}

