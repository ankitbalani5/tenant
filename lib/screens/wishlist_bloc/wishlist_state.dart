part of 'wishlist_bloc.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState{}
class WishlistLoading extends WishlistState{}
class WishlistSuccess extends WishlistState{
  AddWishlistModel addWishlistModel;
  WishlistSuccess(this.addWishlistModel);
}
class WishlistError extends WishlistState{
  final String error;
  WishlistError(this.error);
}