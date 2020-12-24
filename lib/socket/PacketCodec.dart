import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';
import 'package:flutter_im/handler/ResponseHandler.dart';

const int MAGIC_NUMBER = 0X12345678;
const int magicNumberLen = 4;
const int versionLen = 1;
const int serializeAlgorithmLen = 1;
const int commandLen = 1;
const int bodyLen = 4;

const int minMsgLen =
    magicNumberLen + versionLen + serializeAlgorithmLen + commandLen + bodyLen;

List<int> bufferList;
int bufferLength;
int bufferCommand;

/**
 * 客户端解码方法
 */
void decode(dataList) {
  Uint8List input = Uint8List.fromList(dataList);
  ByteData data = input.buffer.asByteData();
  int magicNumber = data.getUint32(0);
  if (magicNumber != MAGIC_NUMBER) {
    if (bufferList == null) {
      print("服务器不匹配!");
      throw SocketException("服务器不匹配");
    }
    bufferList.addAll(input.toList()) ;
    if (bufferLength == bufferList.length-11) {
      String result = utf8.decode(bufferList.sublist(11));
      Function handler = socketHandler[bufferCommand];
      if (handler == null) {
        throw SocketException("没有找到消息号$bufferCommand的处理器");
      }
      handler(result);
      bufferList = null;
    }
  } else {
    int command = data.getUint8(6);
    int bodyLen = data.getUint32(7);
    String result = utf8.decode(input.sublist(11));
    if (command == Command.MESSAGE_RESPONSE && input.length-11 != bodyLen) {
      bufferList = input.toList();
      bufferLength = bodyLen;
      bufferCommand = command;
      return;
    }
    Function handler = socketHandler[command];
    if (handler == null) {
      throw SocketException("没有找到消息号$command的处理器");
    }
    handler(result);
  }
  // int version = data.getUint8(4);
  // int serialMethod = data.getUint8(5);
}

/**
 * 客户端编码方法
 */
List<int> encode(Packet packet) {
  Uint8List body;
  int bodyLen = 0;
  if (packet != null) {
    body = packet.getBytes();
    bodyLen = body.length;
  }
  ByteData header = ByteData(minMsgLen);
  header.setUint32(0, MAGIC_NUMBER);
  header.setUint8(4, packet.version);
  header.setUint8(5, 1);
  header.setUint8(6, packet.getCommand());
  header.setUint32(7, bodyLen);

  return body == null
      ? header.buffer.asUint8List()
      : header.buffer.asUint8List() + body;
}
