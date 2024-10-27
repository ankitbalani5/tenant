part of 'sendmessagechat_bloc.dart';

@immutable
abstract class SendmessagechatState {}

class SendmessagechatInitial extends SendmessagechatState {}
class SendmessagechatLoading extends SendmessagechatState {}
class SendmessagechatSuccess extends SendmessagechatState {}
class SendmessagechatError extends SendmessagechatState {
  String error;
  SendmessagechatError(this.error);
}
