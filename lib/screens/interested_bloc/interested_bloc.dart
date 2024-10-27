
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../api/apitget.dart';
import '../../model/InterestedModel.dart';

part 'interested_event.dart';
part 'interested_state.dart';

class InterestedBloc extends Bloc<InterestedEvent, InterestedState>{
  InterestedBloc() : super(InterestedInitial()){
   on<InterestedRefreshEvent>((event, emit) async {
     emit(InterestedLoading());
     try{
       final response = await API.interested(event.type, event.phone);
       print("REsponse : ${response}");
       if(response != null){
         print(response);
         emit(InterestedSuccess(response));
       }else{
         print("Erroir");
         emit(InterestedError(response));
       }

     } on SocketException{
       emit(InterestedError('Please check your Internet connection'));
     } catch (e) {
       emit(InterestedError(e.toString()));
     }
   });
  }

}