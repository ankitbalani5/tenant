part of 'clear_notification_bloc.dart';

@immutable
abstract class ClearNotificationEvent {}

class ClearNotificationRefreshEvent extends ClearNotificationEvent {
  String tenant_id;
  ClearNotificationRefreshEvent(this.tenant_id);
}
