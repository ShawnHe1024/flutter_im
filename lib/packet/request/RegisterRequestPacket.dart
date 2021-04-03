import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class RegisterRequestPacket extends Packet {

  String username;

  String nickname;

  String password;

  String avatar;

  RegisterRequestPacket(this.username, this.nickname, this.password,
      this.avatar);

  RegisterRequestPacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    username = json['username'];
    nickname = json['nickname'];
    password = json['password'];
    avatar = json['avatar'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.getCommand();
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['version'] = this.version;
    return data;
  }

  @override
  int getCommand() {
    return Command.REGISTER_REQUEST;
  }

}