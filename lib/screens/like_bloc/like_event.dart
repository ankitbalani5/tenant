//
//
//
// import 'package:equatable/equatable.dart';
//
// class LikeEvent extends Equatable {
//   bool like;
//   LikeEvent(this.like);
//
//
//   @override
//   List<Object?> get props => [like];
//
// }

import 'package:equatable/equatable.dart';

class LikeEvent extends Equatable {
  final dynamic like; // You can replace dynamic with the appropriate type

  LikeEvent(this.like);

  @override
  List<Object?> get props => [like];
}
