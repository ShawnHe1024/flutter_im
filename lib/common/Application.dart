import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/HeartBeatRequestPacket.dart';
import 'package:flutter_im/socket/NetWorkManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Application {
  static const String TITLE_DEFAULT = "PrivateChat";
  static const String TITLE_CONNECT = "Connecting";
  static const String TITLE_CONNECT_FAILED = "Waiting for network";
  static const String TITLE_UPDATE = "Updating";

  static const int MSG_TYPE_TEXT = 1;
  static const int MSG_TYPE_IMAGE = 2;
  static const int MSG_TYPE_AUDIO = 3;

  static String address = "im.shawnhe.tech";
  static int port = 51257;
  static NetworkManager networkManager;

  static UserInfo loginUser;

  static Future init() async {
    networkManager = NetworkManager(Application.address, Application.port);
    await networkManager.init(NetworkManager.retry);
  }

}

void showToast(
  String text, {
  gravity: ToastGravity.CENTER,
  toastLength: Toast.LENGTH_SHORT
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.grey[600],
    fontSize: 16.0
  );
}
