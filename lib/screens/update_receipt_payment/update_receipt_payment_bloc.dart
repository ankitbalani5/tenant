
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/logoutOtpTenant.dart';

import '../../api/apitget.dart';
import '../../model/updatereceiptpaymentmodel.dart';

part 'update_receipt_payment_event.dart';
part 'update_receipt_payment_state.dart';

class UpdateReceiptPaymentBloc extends Bloc<UpdateReceiptPaymentEvent, UpdateReceiptPaymentState>{
  UpdateReceiptPaymentBloc() : super(UpdateReceiptPaymentInitial()){
    on<UpdateReceiptPaymentRefreshEvent>((event, emit) async {
      emit(UpdateReceiptPaymentLoading());
      try{
        final response = await API.updatepaymentreceipts(event.type, event.branch_id,
        event.tenant_id, event.transaction_amount, event.pay_mode, event.payment_transaction_date,
        event.payment_transation_id, event.transaction_remark, event.payment_id);
        if(response != null){
          emit(UpdateReceiptPaymentSuccess(response));

        }else{
          emit(UpdateReceiptPaymentLoading());
        }

      } on SocketException{
        emit(UpdateReceiptPaymentError('Please check your Internet connection'));
      } catch (e) {
        emit(UpdateReceiptPaymentError(e.toString()));
      }
    });
  }
}