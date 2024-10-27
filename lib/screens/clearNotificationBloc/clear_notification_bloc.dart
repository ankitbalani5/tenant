import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/apitget.dart';

part 'clear_notification_event.dart';
part 'clear_notification_state.dart';

class ClearNotificationBloc extends Bloc<ClearNotificationEvent, ClearNotificationState> {
  ClearNotificationBloc() : super(ClearNotificationInitial()) {
    on<ClearNotificationRefreshEvent>((event, emit) async {

      emit(ClearNotificationLoading());
      try{
        final response = await API.clearNotificationdata(event.tenant_id);
        if(response != null){
          emit(ClearNotificationSuccess());

        }else{
          emit(ClearNotificationLoading());
        }

      } on SocketException{
        emit(ClearNotificationError('Please check your Internet connection'));
      } catch (e) {
        emit(ClearNotificationError(e.toString()));
      }
    });
  }
}
