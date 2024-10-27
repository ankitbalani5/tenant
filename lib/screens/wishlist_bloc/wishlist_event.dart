
part of 'wishlist_bloc.dart';
abstract class WishlistEvent {}
class WishlistRefreshEvent extends WishlistEvent{
  final String branch_id;
  String tenant_id;
  String imei_no;
  String ip_address;
  String latitude;
  String longitude;
  String address;
  WishlistRefreshEvent(this.branch_id, this.tenant_id, this.imei_no, this.ip_address,
      this.latitude, this.longitude, this.address);
}