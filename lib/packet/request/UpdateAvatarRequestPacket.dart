import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class UpdateAvatarRequestPacket extends Packet {

  String avatar;

  UpdateAvatarRequestPacket(this.avatar);

  UpdateAvatarRequestPacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    avatar = json['avatar'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['avatar'] = this.avatar;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.UPDATE_AVATAR_REQUEST;
  }

}