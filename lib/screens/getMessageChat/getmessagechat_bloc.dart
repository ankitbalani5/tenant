import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/getMessageChatModel.dart';

import '../../api/apitget.dart';

part 'getmessagechat_event.dart';
part 'getmessagechat_state.dart';

class GetmessagechatBloc extends Bloc<GetmessagechatEvent, GetmessagechatState> {
  GetmessagechatBloc() : super(GetmessagechatInitial()) {
    on<GetmessagechatRefreshEvent>((event, emit) async {
      try{
        final user = await API.getMessageChat(event.login_id, event.branch_id);
        if(user != null){
          print(user);
          // if(user.success == 1){

            emit(GetmessagechatSuccess(user));
          // }
          // else{
          //   emit(RequestedPgError('No Requested PG'));
          // }
        }
      }on SocketException{
        emit(GetmessagechatError('Please check your Internet Connection'));
      }catch(e){
        emit(GetmessagechatError(e.toString()));
      }
    });
  }
}
