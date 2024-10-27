part of 'review_bloc.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}
class ReviewLoading extends ReviewState {}
class ReviewSuccess extends ReviewState {
  ReviewModel reviewModel;
  ReviewSuccess(this.reviewModel);
}
class ReviewError extends ReviewState {
  String error;
  ReviewError(this.error);
}
