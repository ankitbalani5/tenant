part of 'clear_notification_bloc.dart';

@immutable
abstract class ClearNotificationState {}

class ClearNotificationInitial extends ClearNotificationState {}

class ClearNotificationLoading extends ClearNotificationState {}

class ClearNotificationSuccess extends ClearNotificationState {

}

class ClearNotificationError extends ClearNotificationState {
  String error;
  ClearNotificationError(this.error);
}
