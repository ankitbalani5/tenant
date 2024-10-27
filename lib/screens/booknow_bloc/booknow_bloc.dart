
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../api/apitget.dart';
import '../../model/BookNowModel.dart';

part 'booknow_event.dart';
part 'booknow_state.dart';
class BookNowBloc extends Bloc<BookNowEvent, BookNowState>{
  BookNowBloc() : super(BookNowInitial()){
    on<BookNowRefreshEvent>((event, emit) async {
      emit(BookNowLoading());
      try{
        final response = await API.bookNow(event.name,
            event.email, event.phone, event.message, event.bdid);
        if(response != null){
          emit(BookNowSuccess(response));

        }else{
          emit(BookNowLoading());
        }

      } on SocketException{
        emit(BookNowError('Please check your Internet connection'));
      } catch (e) {
        emit(BookNowError(e.toString()));
      }
    });
  }

}