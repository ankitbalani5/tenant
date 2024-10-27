
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/logoutOtpTenant.dart';

import '../../api/apitget.dart';

part 'logout_otp_tenant_event.dart';
part 'logout_otp_tenant_state.dart';

class LogoutOtpTenantBloc extends Bloc<LogoutOtpTenantEvent, LogoutOtpTenantState>{
  LogoutOtpTenantBloc() : super(LogoutOtpTenantInitial()){
    on<LogoutOtpTenantRefreshEvent>((event, emit) async {
      emit(LogoutOtpTenantLoading());
      try{
        final response = await API.logoutOtpTenant(event.tenantId);
        if(response != null){
          emit(LogoutOtpTenantSuccess(response));

        }else{
          emit(LogoutOtpTenantLoading());
        }

      } on SocketException{
        emit(LogoutOtpTenantError('Please check your Internet connection'));
      } catch (e) {
        emit(LogoutOtpTenantError(e.toString()));
      }
    });
  }
}