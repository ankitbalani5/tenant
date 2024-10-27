part of 'getmessagechat_bloc.dart';

@immutable
abstract class GetmessagechatState {}

class GetmessagechatInitial extends GetmessagechatState {}
class GetmessagechatLoading extends GetmessagechatState {}
class GetmessagechatSuccess extends GetmessagechatState {
  GetMessageChatModel getMessageChatModel;
  GetmessagechatSuccess(this.getMessageChatModel);
}
class GetmessagechatError extends GetmessagechatState {
  String error;
  GetmessagechatError(this.error);
}
