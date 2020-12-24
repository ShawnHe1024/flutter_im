import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SystemUtils {
  static StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static void scrollToBottom(ScrollController scrollController) {
    Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  static Future hideKeyBoard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
  static Future showKeyBoard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.show');
  }
  static Future vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100, amplitude: 200);
    }
  }

  //网络初始状态
  static void connectivityInitState(){
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          print(result.toString());
          if(result == ConnectivityResult.none){
            Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT_FAILED);
          } else {
            Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT);
          }
        });
  }

  //网络进行监听
  static Future<Null> initConnectivity() async {
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      ConnectivityResult connectionStatus = (await Connectivity().checkConnectivity());
      print(connectionStatus.toString());
      if (connectionStatus == ConnectivityResult.none) {
        Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT_FAILED);
      } else {
        Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT);
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  //网络结束监听
  static void connectivityDispose(){
    _connectivitySubscription.cancel();
  }

}