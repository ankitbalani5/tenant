import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class QuotationEvent extends Equatable{
  const QuotationEvent();
}

class LoadQuotationUserEvent extends QuotationEvent {
  const LoadQuotationUserEvent();
  @override
  List<Object?> get props => [];
}
class PostQuotationAddEvent extends QuotationEvent{
  const PostQuotationAddEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}