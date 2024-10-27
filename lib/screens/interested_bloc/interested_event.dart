
part of 'interested_bloc.dart';

@immutable
abstract class InterestedEvent {}

class InterestedRefreshEvent extends InterestedEvent {
  String type;
  final String phone;
  InterestedRefreshEvent(this.type, this.phone);
}