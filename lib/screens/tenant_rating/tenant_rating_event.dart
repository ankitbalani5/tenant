part of 'tenant_rating_bloc.dart';

@immutable
abstract class TenantRatingEvent {}

class TenantRatingRefreshEvent extends TenantRatingEvent {
  String mobile_no;
  TenantRatingRefreshEvent(this.mobile_no);
}
