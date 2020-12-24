import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/MessageInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class MessageResponsePacket extends Packet {

  MessageInfo _messageInfo;

  MessageResponsePacket(this._messageInfo);

  MessageResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    _messageInfo = MessageInfo.fromJson(json['message']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['messageInfo'] = this._messageInfo;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.MESSAGE_RESPONSE;
  }

  MessageInfo get messageInfo => _messageInfo;
}
