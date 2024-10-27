import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()){

    on<LoginRefreshEvent>((event, emit) async{
      emit(LoginLoading());
      try{
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        final user = await API.login(event.mobile_no, event.password,
            event.imei_no, event.device_id, event.ip_address, event.carrier_name,
            event.app_version, event.phone_model, event.phone_manufacturer,
            event.sdk_phone_version);
        if(user != null){
          print(user);
          emit(LoginSuccess(user));
        }
      } on SocketException {
        emit(LoginError('Please check your internet connection'));
      }catch (error){
        emit(LoginError(error.toString()));
      }
    });
  }

}