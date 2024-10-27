part of 'get_wishlist_bloc.dart';

@immutable
abstract class GetWishlistEvent{}
class GetWishlistRefreshEvent extends GetWishlistEvent {
  String branch_id;
  String imei_no;
  String tenant_id;
  GetWishlistRefreshEvent(this.branch_id, this.imei_no, this.tenant_id);
}
