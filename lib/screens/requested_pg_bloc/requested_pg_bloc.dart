import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../../model/requested_pg_model.dart';
part 'requested_pg_event.dart';
part 'requested_pg_state.dart';

class RequestedPgBloc extends Bloc<RequestedPgEvent, RequestedPgState> {
  RequestedPgBloc() : super(RequestedPgInitial()){

    on<RequestedPgRefreshEvent>((event, emit) async{
      emit(RequestedPgLoading());
      try{
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        final user = await API.requestedPg(event.mobile_no);
        // RequestedPgModel requestedPgModel = jsonDecode(user);
        if(user != null){
          print(user);
          if(user.success == 1){

            emit(RequestedPgSuccess(user));
          }
          else{
            emit(RequestedPgError('No Requested PG'));
          }
        }
      } on SocketException {
        emit(RequestedPgError('Please check your internet connection'));
      }catch (error){
        emit(RequestedPgError(error.toString()));
      }
    });
  }

}