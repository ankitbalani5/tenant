part of 'booknow_bloc.dart';

@immutable
abstract class BookNowEvent {}

class BookNowRefreshEvent extends BookNowEvent {
  final String name;
  final String email;
  final String phone;
  final String message;
  final String bdid;
  BookNowRefreshEvent(this.name, this.email, this.phone, this.message, this.bdid);
}