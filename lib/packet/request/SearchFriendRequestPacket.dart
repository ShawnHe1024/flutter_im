import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class SearchFriendRequestPacket extends Packet {

  String _username;

  SearchFriendRequestPacket(this._username);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['username'] = this._username;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.SEARCH_FRIEND_REQUEST;
  }

}