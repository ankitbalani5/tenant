class GetMessageChatModel {
  int? success;
  String? details;
  List<ChatData>? data;

  GetMessageChatModel({this.success, this.details, this.data});

  GetMessageChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
    if (json['data'] != null) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(new ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatData {
  String? id;
  String? msg;
  String? postDate;

  @override
  String toString() {
    return '$msg';
  }

  String? postTime;
  String? userType;

  ChatData({this.id, this.msg, this.postDate, this.postTime, this.userType});

  ChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    postDate = json['post_date'];
    postTime = json['post_time'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msg'] = this.msg;
    data['post_date'] = this.postDate;
    data['post_time'] = this.postTime;
    data['user_type'] = this.userType;
    return data;
  }
}
