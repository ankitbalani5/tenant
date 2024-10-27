part of 'notification_list_bloc.dart';

@immutable
abstract class NotificationListState {}

class NotificationListInitial extends NotificationListState {}
class NotificationListLoading extends NotificationListState {}
class NotificationListSuccess extends NotificationListState {
  NotificationModel notificationModel;
  NotificationListSuccess(this.notificationModel);
}
class NotificationListError extends NotificationListState {
  String error;
  NotificationListError(this.error);
}
