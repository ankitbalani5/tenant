part of 'sendmessagechat_bloc.dart';

@immutable
abstract class SendmessagechatEvent {}

class SendMessageChatRefresh extends SendmessagechatEvent{
  String login_id;
  String branch_id;
  String msg;
  String tenant_name;
  SendMessageChatRefresh(this.login_id, this.branch_id, this.msg, this.tenant_name);
}
