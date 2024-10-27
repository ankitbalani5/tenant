import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/apitget.dart';

part 'sendmessagechat_event.dart';
part 'sendmessagechat_state.dart';

class SendmessagechatBloc extends Bloc<SendmessagechatEvent, SendmessagechatState> {
  SendmessagechatBloc() : super(SendmessagechatInitial()) {
    on<SendMessageChatRefresh>((event, emit) {
      try{
        final response = API.sendMessageChat(event.login_id, event.branch_id, event.msg, event.tenant_name);
        if(response != null){
          print(response);
          // if(response.success == 1){

            emit(SendmessagechatSuccess());
          // }
          // else{
          //   emit(SendmessagechatError('No Requested PG'));
          // }
        }

      }on SocketException{
        emit(SendmessagechatError('Please check your internet connection'));
      }catch(e){
        emit(SendmessagechatError(e.toString()));
      }
    });
  }
}
