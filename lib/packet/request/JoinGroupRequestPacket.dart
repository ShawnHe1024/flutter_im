import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class JoinGroupRequestPacket extends Packet {
  String groupId;

  JoinGroupRequestPacket({this.groupId});

  JoinGroupRequestPacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    groupId = json['groupId'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['groupId'] = this.groupId;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.JOIN_GROUP_REQUEST;
  }
}
