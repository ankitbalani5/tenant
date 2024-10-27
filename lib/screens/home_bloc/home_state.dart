part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final UserModel userModel;
  HomeSuccess(this.userModel);
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}