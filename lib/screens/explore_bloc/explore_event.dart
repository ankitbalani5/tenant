part of 'explore_bloc.dart';
@immutable
abstract class ExploreEvent {}

class ExploreRefreshEvent extends ExploreEvent {
  final String mobile_no;
  ExploreRefreshEvent(this.mobile_no);
}