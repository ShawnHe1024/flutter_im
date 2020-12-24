import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class LoginResponsePacket extends Packet {

  bool success;

  Map<String, dynamic> userInfo;

  String reason;

  LoginResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    success = json['success'];
    userInfo = json['userInfo'];
    reason = json['reason'];
  }

  @override
  int getCommand() {
    return Command.LOGIN_RESPONSE;
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}