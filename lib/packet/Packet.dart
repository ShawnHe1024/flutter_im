import 'dart:convert';
import 'dart:typed_data';

abstract class Packet {

  //协议版本
  int version = 1;

  //获取指令方法
  int getCommand();

  toJson();

  Uint8List getBytes() {
    return Utf8Encoder().convert(json.encode(toJson()));
  }

}