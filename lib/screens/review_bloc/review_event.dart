part of 'review_bloc.dart';

@immutable
abstract class ReviewEvent {}

class ReviewRefreshEvent extends ReviewEvent {
  String branch_id;
  ReviewRefreshEvent(this.branch_id);
}
