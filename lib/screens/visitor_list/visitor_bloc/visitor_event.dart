import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VisitorEvent extends Equatable{

  const VisitorEvent();
}

class LoadVisitorEvent extends VisitorEvent {
  const LoadVisitorEvent();
  @override
  List<Object?> get props => [];
}
class PostVisitorEvent extends VisitorEvent{
  const PostVisitorEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}