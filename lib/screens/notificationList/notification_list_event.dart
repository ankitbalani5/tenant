part of 'notification_list_bloc.dart';

@immutable
abstract class NotificationListEvent {}

class NotificationListRefreshEvent extends NotificationListEvent {
  String tenant_id;
  NotificationListRefreshEvent(this.tenant_id);
}
