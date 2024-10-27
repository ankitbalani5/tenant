part of 'get_wishlist_bloc.dart';

@immutable
abstract class GetWishlistState {}

class GetWishlistInitial extends GetWishlistState {}
class GetWishlistLoading extends GetWishlistState {}
class GetWishlistSuccess extends GetWishlistState {
  GetWishlistModel getWishlistModel;
  GetWishlistSuccess(this.getWishlistModel);
}
class GetWishlistError extends GetWishlistState {
  String error;
  GetWishlistError(this.error);
}
