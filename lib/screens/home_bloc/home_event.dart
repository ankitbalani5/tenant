part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeRefreshEvent extends HomeEvent {
  String email, id;
  HomeRefreshEvent(this.email, this.id);
}