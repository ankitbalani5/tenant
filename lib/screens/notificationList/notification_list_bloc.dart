import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/notification_model.dart';

import '../../api/apitget.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(NotificationListInitial()) {
    on<NotificationListRefreshEvent>((event, emit) async {

      emit(NotificationListLoading());
      try{
        final response = await API.notificationList(event.tenant_id);
        if(response != null){
          emit(NotificationListSuccess(response));

        }else{
          emit(NotificationListLoading());
        }

      } on SocketException{
        emit(NotificationListError('Please check your Internet connection'));
      } catch (e) {
        emit(NotificationListError(e.toString()));
      }
    });
  }
}
