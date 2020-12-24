import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class GetFriendsResponsePacket extends Packet {

  List<UserInfo> _userList;

  GetFriendsResponsePacket(this._userList);

  GetFriendsResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    List<dynamic> list = json['userList'];
    _userList = list.map((e) => UserInfo.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['userList'] = this._userList;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.GET_FRIENDS_RESPONSE;
  }

  List<UserInfo> get userList => _userList;
}