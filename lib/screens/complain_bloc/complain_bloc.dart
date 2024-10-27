import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/complain_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apitget.dart';

part 'complain_event.dart';
part 'complain_state.dart';

class ComplainBloc extends Bloc<ComplainEvent, ComplainState>{
  static dynamic userComplains;
  ComplainBloc() : super(ComplainInitial()) {
    on<ComplainRefreshEvent>((event, emit) async{
      emit(ComplainLoading());
      try{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('tenant_id');
        userComplains = await API.complains(userId);
        if(userComplains == null){
          emit(ComplainLoading());
        }else{
          emit(ComplainSuccess(userComplains));
        }

      }on SocketException{
        emit(ComplainError('Please check your internet connection'));
      }catch (e) {
        print(e.toString());
      }
    });
  }


}