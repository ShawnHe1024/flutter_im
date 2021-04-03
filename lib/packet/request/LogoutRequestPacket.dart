import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class LogoutRequestPacket extends Packet {


  @override
  int getCommand() {
    return Command.LOGOUT_REQUEST;
  }

  @override
  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['version'] = this.version;
    return data;
  }

}