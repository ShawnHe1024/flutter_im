import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class CreateGroupRequestPacket extends Packet {
  List<String> userIdList;

  CreateGroupRequestPacket({this.userIdList});

  CreateGroupRequestPacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    userIdList = json['userIdList'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['userIdList'] = this.userIdList;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.CREATE_GROUP_REQUEST;
  }
}
