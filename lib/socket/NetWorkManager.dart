import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/handler/ResponseHandler.dart';
import 'package:flutter_im/packet/Packet.dart';
import 'package:flutter_im/packet/request/HeartBeatRequestPacket.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:flutter_im/socket/PacketCodec.dart';
import 'package:provider/provider.dart';

const int MAGIC_NUMBER = 0X12345678;
const int magicNumberLen = 4;
const int versionLen = 1;
const int serializeAlgorithmLen = 1;
const int commandLen = 1;
const int bodyLen = 4;

const int minMsgLen =
    magicNumberLen + versionLen + serializeAlgorithmLen + commandLen + bodyLen;

class NetworkManager {
  static final int retry = 3;

  static DateTime lastDateTime;

  final String host;

  final int port;

  SecureSocket socket;

  Int8List cacheData = Int8List(0);

  NetworkManager(this.host, this.port);

  void init(int i) async {
    if (i == 0 && lastDateTime != null && (DateTime.now().second - lastDateTime.second) > 10) {
      i = retry;
    }
    if (i > 0) {
      try {
        SecurityContext context = SecurityContext();
        String certData = await rootBundle.loadString('assets/server.pem');
        context.setTrustedCertificatesBytes(utf8.encode(certData));
        socket = await SecureSocket.connect(host, port, context: context, timeout: Duration(seconds: 10));
        Timer.periodic(Duration(seconds: 10), (timer) {
          HeartBeatRequestPacket heartBeatRequestPacket = HeartBeatRequestPacket();
          Application.networkManager.sendMsg(heartBeatRequestPacket);
        });
        Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_DEFAULT);
      } catch (e) {
        print("连接socket出现异常, e=${e.toString()}");
        init(--i);
      }
      socket.listen(decodeHandle,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    } else {
      showToast("网络故障，请检查网络后重试!");
      lastDateTime = DateTime.now();
    }
  }

  void decodeHandle(dataList) {
    decode(dataList);
  }

  void sendMsg(Packet packet) {
    List<int> msg = encode(packet);
    try {
      socket.add(msg);
    } catch (e) {
      showToast("网络故障，请检查网络后重试!");
      print("send捕获异常：msgcode=${packet.getCommand()}，e=${e.toString()}");
      init(retry);
    }
  }

  void errorHandler(error, StackTrace trace) {
    print("捕获socket异常信息：error=$error, trace=${trace.toString()}");
    socket.close();
  }

  void doneHandler() {
    socket.destroy();
    print("socket关闭处理");
    print("socket重连处理");
    init(retry);
  }
}
