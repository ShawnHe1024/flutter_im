import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/packet/Packet.dart';

class HeartBeatResponsePacket extends Packet {

  @override
  int getCommand() {
    return Command.HEARTBEAT_RESPONSE;
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}