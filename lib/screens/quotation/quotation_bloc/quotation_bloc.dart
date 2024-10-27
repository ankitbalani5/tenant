import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/screens/quotation/quotation_bloc/quotation_event.dart';
import 'package:roomertenant/screens/quotation/quotation_bloc/quotation_state.dart';

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  final API _api;

  QuotationBloc(this._api) : super(QuotationLoadingState()) {
    on<LoadQuotationUserEvent>((event, emit) async {
      emit(QuotationLoadingState());
      try {
        final quotation = await _api.quotationList();
        emit(QuotationLoadedState(quotation));
      } catch (e) {
        emit(QuotationErrorState(e.toString()));
      }
    });
  }
}