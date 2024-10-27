import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/TenantRatingModel.dart';

import '../../api/apitget.dart';

part 'tenant_rating_event.dart';
part 'tenant_rating_state.dart';

class TenantRatingBloc extends Bloc<TenantRatingEvent, TenantRatingState> {
  TenantRatingBloc() : super(TenantRatingInitial()) {
    on<TenantRatingRefreshEvent>((event, emit) async {
      emit(TenantRatingLoading());
      try{
        final response = await API.tenantRating(event.mobile_no);
        if(response != null){
          emit(TenantRatingSuccess(response));
        }
      }on SocketException{
        emit(TenantRatingError('Please check your internet connection'));
      }catch(e){
        emit(TenantRatingError(e.toString()));
      }
    });
  }
}
