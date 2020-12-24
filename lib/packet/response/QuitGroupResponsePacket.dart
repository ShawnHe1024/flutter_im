import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class QuitGroupResponsePacket extends Packet {
  String groupId;

  bool success;

  QuitGroupResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    groupId = json['groupId'];
    success = json['success'];
  }

  @override
  int getCommand() {
    return Command.QUIT_GROUP_RESPONSE;
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
