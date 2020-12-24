import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class CreateGroupResponsePacket extends Packet {
  String groupId;

  bool success;

  List<String> usernameList;

  CreateGroupResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    groupId = json['groupId'];
    success = json['success'];
    usernameList = json['usernameList'];
  }

  @override
  int getCommand() {
    return Command.CREATE_GROUP_RESPONSE;
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
