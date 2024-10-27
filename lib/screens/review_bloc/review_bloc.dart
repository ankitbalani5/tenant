import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/review_model.dart';

import '../../api/apitget.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<ReviewRefreshEvent>((event, emit) async {
      emit(ReviewLoading());
      try{
        final response = await API.reviewApi(event.branch_id);
        if(response != null){
          emit(ReviewSuccess(response));
        }
      }on SocketException{
        emit(ReviewError('Please connect a internet connection'));
      }catch(e){
        emit(ReviewError(e.toString()));
      }
    });
  }
}
