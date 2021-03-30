import 'dart:ffi';

import 'package:flutter_im/model/MessageInfo.dart';

class UserInfo {

  int _id;

  String _nickname;

  String _avatar;

  MessageInfo _lastMessage;

  bool _online;

  UserInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nickname = json['nickname'];
    _avatar = json['avatar'];
    _online = json['online'];
    if (json['lastMessage'] != null) {
      _lastMessage = MessageInfo.fromJson(json['lastMessage']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nickname'] = this._nickname;
    data['avatar'] = this._avatar;
    data['online'] = this._online;
    data['lastMessage'] = this._lastMessage;
    return data;
  }

  int get id => _id;

  String get nickname => _nickname;

  String get avatar => _avatar;

  bool get online => _online;

  MessageInfo get lastMessage => _lastMessage;

  set lastMessage(MessageInfo value) {
    _lastMessage = value;
  }
}