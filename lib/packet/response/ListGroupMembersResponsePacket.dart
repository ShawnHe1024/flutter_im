import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class ListGroupMembersResponsePacket extends Packet {
  String groupId;

  Map<String, String> users;

  ListGroupMembersResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    groupId = json['groupId'];
    users = json['users'];
  }

  @override
  int getCommand() {
    return Command.LIST_GROUP_MEMBERS_RESPONSE;
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
