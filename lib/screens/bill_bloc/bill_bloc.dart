import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:roomertenant/model/bill_model.dart';
import 'package:roomertenant/model/payment_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apitget.dart';
// import 'package:roomertenant/screens/bill_bloc/bill_state.dart';


part 'bill_event.dart';
part 'bill_state.dart';
class BillBloc extends Bloc<BillEvent, BillState>{
  static dynamic userBills;
  BillBloc() : super(BillInitial()){
    on<BillRefreshEvent>((event, emit) async{
      emit(BillLoading());
      try{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // final userId = prefs.getString('id');
        // final branch_id = prefs.getString('branch_id');
        // final tenant_id = prefs.getString('tenant_id');
        userBills = await API.paymenthistory(event.type,
            event.branch_id, event.resident_id,
            event.payment_from, event.payment_to);
        if(userBills == null){
          emit(BillLoading());
        }else{
          print('payments${userBills}');
          emit(BillSuccess(userBills));
        }

      }on SocketException{
        emit(BillError('Please check your internet connection'));
      }catch (e) {
        print(e.toString());
      }
    });
  }


}