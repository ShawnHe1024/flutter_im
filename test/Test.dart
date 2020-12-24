giimport 'dart:convert';

import 'package:flutter_im/model/MessageInfo.dart';
import 'package:flutter_im/packet/request/MessageRequestPacket.dart';

void main() {
  MessageInfo info = MessageInfo(
      null, 1, 1,
      "哈哈", 1);
  MessageRequestPacket req = MessageRequestPacket(info);
  print(req.getBytes());
  print(Utf8Encoder().convert(json.encode(req.toJson())));
}