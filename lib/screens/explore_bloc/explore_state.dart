part of 'explore_bloc.dart';
@immutable
abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreSuccess extends ExploreState {
  final ExploreModel exploreModel;
  ExploreSuccess(this.exploreModel);
}

class ExploreError extends ExploreState {
  String error;
  ExploreError(this.error);
}