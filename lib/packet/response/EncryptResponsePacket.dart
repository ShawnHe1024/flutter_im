import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class AddFriendResponsePacket extends Packet {

  int _userId;

  bool _agree;

  String _key;


  AddFriendResponsePacket(this._userId, this._agree, this._key);

  AddFriendResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    _userId = json['userId'];
    _agree = json['agree'];
    _key = json['key'];
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  int getCommand() {
    return Command.ENCRYPT_RESPONSE;
  }

}