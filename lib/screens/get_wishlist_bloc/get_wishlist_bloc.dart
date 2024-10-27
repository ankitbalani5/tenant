import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/api/apitget.dart';

import '../../model/get_wishlist_model.dart';

part 'get_wishlist_event.dart';
part 'get_wishlist_state.dart';

class GetWishlistBloc extends Bloc<GetWishlistEvent, GetWishlistState> {
  GetWishlistBloc() : super(GetWishlistInitial()) {
    on<GetWishlistRefreshEvent>((event, emit) async {
      emit(GetWishlistLoading());
      try{
        final response = await API.getWishlist(event.branch_id, event.imei_no, event.tenant_id);
        print("REsponse : ${response}");
        if(response != null){
          print(response);
          emit(GetWishlistSuccess(response));
        }else{
          print("Erroir");
          emit(GetWishlistError('error'));
        }

      } on SocketException{
        emit(GetWishlistError('Please check your Internet connection'));
      } catch (e) {
        emit(GetWishlistError(e.toString()));
      }
    });
  }
}
