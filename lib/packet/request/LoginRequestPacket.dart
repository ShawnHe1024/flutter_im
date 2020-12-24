import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class LoginRequestPacket extends Packet {

  String username;

  String password;

  LoginRequestPacket({this.username, this.password});

  LoginRequestPacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    username = json['username'];
    password = json['password'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['username'] = this.username;
    data['password'] = this.password;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.LOGIN_REQUEST;
  }

}