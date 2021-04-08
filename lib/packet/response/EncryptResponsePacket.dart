import 'dart:convert' as convert;

import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/Packet.dart';

class EncryptResponsePacket extends Packet {

  int _userId;

  bool _agree;

  BigInt _modulus;

  BigInt _exponent;

  EncryptResponsePacket(
      this._userId, this._agree, this._modulus, this._exponent);

  EncryptResponsePacket.fromJson(String jsonStr) {
    Map<String, dynamic> json = convert.jsonDecode(jsonStr);
    _userId = json['userId'];
    _agree = json['agree'];
    _modulus = json['modulus'];
    _exponent = json['exponent'];
  }


  int get userId => _userId;

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  int getCommand() {
    return Command.ENCRYPT_RESPONSE;
  }

  bool get agree => _agree;

  BigInt get exponent => _exponent;

  BigInt get modulus => _modulus;
}