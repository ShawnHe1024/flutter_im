import 'dart:ffi';
import 'dart:math';

import 'package:flutter_im/common/Application.dart';

class MessageInfo {

  //消息id
  int _id;
  //发送人
  int _fromUserId;
  //接收人
  int _toUserId;
  //内容
  Object _content;
  //消息类型
  int _type;
  //发送时间
  int _sendTime;
  //是否本人消息
  bool _isSelf;

  MessageInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fromUserId = json['fromUserId'];
    _toUserId = json['toUserId'];
    _content = json['content'];
    _type = json['type'];
    _sendTime = json['sendTime'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['fromUserId'] = this._fromUserId;
    data['toUserId'] = this._toUserId;
    data['content'] = this._content;
    data['type'] = this._type;
    data['sendTime'] = this._sendTime;
    return data;
  }

  MessageInfo(this._id, this._fromUserId, this._toUserId, this._content,
      this._type):this._sendTime = DateTime.now().millisecondsSinceEpoch;

  bool get isSelf => fromUserId == Application.loginUser.id;

  DateTime getTime() => DateTime.fromMillisecondsSinceEpoch(_sendTime);

  int get sendTime => _sendTime;

  int get type => _type;

  Object get content => _content;

  int get toUserId => _toUserId;

  int get fromUserId => _fromUserId;

  int get id => _id;

}