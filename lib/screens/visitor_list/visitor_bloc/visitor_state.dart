import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:roomertenant/model/visitor_model.dart';

@immutable
abstract class VisitorState extends Equatable{}

class VisitorLoadingState extends VisitorState{
  @override
  List<Object?> get props => [];
}

class VisitorLoadedState extends VisitorState {
  final VisitorModel visitorDetail;
  VisitorLoadedState(this.visitorDetail);
  @override
  List<Object?> get props => [visitorDetail];
}

class VisitorErrorState extends VisitorState{
  VisitorErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}