import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class ForwardResponsePacket extends Packet {

  bool _success;

  String _reason;


  ForwardResponsePacket(this._success, this._reason);

  ForwardResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    _success = json['success'];
    _reason = json['reason'];
  }


  bool get success => _success;

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  int getCommand() {
    return Command.FORWARD_RESPONSE;
  }

  String get reason => _reason;
}