
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../api/apitget.dart';
import '../../model/InterestedModel.dart';
import '../../model/addwishlist_model.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState>{
  WishlistBloc() : super(WishlistInitial()){
    on<WishlistRefreshEvent>((event, emit) async {
      emit(WishlistLoading());
      try{
        final response = await API.addWishlist(event.branch_id, event.tenant_id, event.imei_no,
            event.ip_address, event.latitude, event.longitude, event.address);
        print("REsponse : ${response}");
        if(response != null){
          print(response);
          emit(WishlistSuccess(response));
        }else{
          print("Erroir");
          // emit(WishlistError(response));
        }

      } on SocketException{
        emit(WishlistError('Please check your Internet connection'));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
  }

}