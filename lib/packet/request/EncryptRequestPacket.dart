import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class EncryptRequestPacket extends Packet {

  int _userId;

  EncryptRequestPacket(this._userId);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['userId'] = this._userId;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.ENCRYPT_REQUEST;
  }

}