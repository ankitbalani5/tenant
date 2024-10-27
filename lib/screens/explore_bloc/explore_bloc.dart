import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/ExploreModel.dart';

import '../../api/apitget.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState>{
  ExploreBloc() : super(ExploreInitial()){
   on<ExploreRefreshEvent>((event, emit) async{
     emit(ExploreLoading());
     try{
       final propertyData = await API.explore(event.mobile_no);
       if(propertyData != null){
         emit(ExploreSuccess(propertyData));
       }else{
         emit(ExploreLoading());
       }
     } on SocketException {
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check your internet connection')));
       emit(ExploreError('Please check your internet connection'));
     }catch (e){
       emit(ExploreError(e.toString()));
     }
   });
  }

}