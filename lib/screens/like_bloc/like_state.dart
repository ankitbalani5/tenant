//
// import 'package:equatable/equatable.dart';
//
// class LikeState extends Equatable {
//   List dataList;
//
//   LikeState({
//     this.dataList = []
//   });
//
//   LikeState copyWith({List? dataList}){
//     return LikeState(
//         dataList: dataList ?? this.dataList
//     );
//   }
//
//   @override
//   List<Object> get props => [dataList];
// }
//


import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final List dataList;

  LikeState({List? dataList})
      : dataList = dataList ?? [];

  LikeState copyWith({List? dataList}) {
    return LikeState(
      dataList: dataList ?? this.dataList,
    );
  }

  @override
  List<Object> get props => [dataList];
}
