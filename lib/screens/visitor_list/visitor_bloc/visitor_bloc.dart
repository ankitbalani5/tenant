import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/screens/visitor_list/visitor_bloc/visitor_event.dart';
import 'package:roomertenant/screens/visitor_list/visitor_bloc/visitor_state.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final API _api;

  VisitorBloc(this._api) : super(VisitorLoadingState()) {
    on<LoadVisitorEvent>((event, emit) async {
      emit(VisitorLoadingState());
      try {
        final visitor = await _api.getVisitors();
        emit(VisitorLoadedState(visitor));
      } catch (e) {
        emit(VisitorErrorState(e.toString()));
      }
    });
  }
}