import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class QuitGroupRequestPacket extends Packet {
  String groupId;

  QuitGroupRequestPacket({this.groupId});

  QuitGroupRequestPacket.fromJson(String jsonStr) {
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
    return Command.QUIT_GROUP_REQUEST;
  }
}
