//
// import 'package:bloc/bloc.dart';
//
// import 'like_event.dart';
// import 'like_state.dart';
//
//
// class LikeBloc extends Bloc<LikeEvent, LikeState> {
//   LikeBloc() : super(LikeState()) {
//     on<LikeEvent>(_like);
//   }
//
//   void _like(LikeEvent event, Emitter<LikeState> emit){
//     emit(state.copyWith(like: event.like));
//   }
// }

import 'package:bloc/bloc.dart';
import 'like_event.dart';
import 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeState()) {
    on<LikeEvent>(_like);
  }

  void _like(LikeEvent event, Emitter<LikeState> emit) {

    // Assuming event.like is something that should be added to dataList
    final updatedList = List.from(state.dataList)..add(event.like);
    emit(state.copyWith(dataList: updatedList));
  }
}
