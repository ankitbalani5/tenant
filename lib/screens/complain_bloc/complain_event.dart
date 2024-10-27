part of 'complain_bloc.dart';
@immutable
abstract class ComplainEvent {}

class ComplainRefreshEvent extends ComplainEvent {
  final String id;
  ComplainRefreshEvent(this.id);
}