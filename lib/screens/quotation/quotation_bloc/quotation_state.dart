import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:roomertenant/model/pdfquote_model.dart';

@immutable
abstract class QuotationState extends Equatable{}

class QuotationLoadingState extends QuotationState{
  @override
  List<Object?> get props => [];
}

class QuotationLoadedState extends QuotationState {
  final QuotationModel quotationDetail;
  QuotationLoadedState(this.quotationDetail);
  @override
  List<Object?> get props => [quotationDetail];
}

class QuotationErrorState extends QuotationState{
  QuotationErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}