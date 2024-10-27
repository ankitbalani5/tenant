part of 'getmessagechat_bloc.dart';

@immutable
abstract class GetmessagechatEvent {}
class GetmessagechatRefreshEvent extends GetmessagechatEvent{
  String login_id;
  String branch_id;
  GetmessagechatRefreshEvent(this.login_id, this.branch_id);
}
