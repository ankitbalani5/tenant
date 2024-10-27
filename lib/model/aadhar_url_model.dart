class AadharUrlModel {
  String? requestId;
  String? url;
  String? callback;
  String? taskId;

  AadharUrlModel({this.requestId, this.url, this.callback, this.taskId});

  AadharUrlModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    url = json['url'];
    callback = json['callback'];
    taskId = json['taskId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['url'] = this.url;
    data['callback'] = this.callback;
    data['taskId'] = this.taskId;
    return data;
  }
}
