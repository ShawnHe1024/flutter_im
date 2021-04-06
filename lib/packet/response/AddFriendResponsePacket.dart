import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class AddFriendResponsePacket extends Packet {

  bool _success;

  String _reason;


  AddFriendResponsePacket(this._success, this._reason);

  AddFriendResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    _success = json['success'];
    _reason = json['reason'];
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  int getCommand() {
    return Command.ADD_FRIEND_RESPONSE;
  }

}