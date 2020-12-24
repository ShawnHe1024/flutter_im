import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/response/GetFriendsResponsePacket.dart';
import 'package:flutter_im/packet/response/LoginResponsePacket.dart';
import 'package:flutter_im/packet/response/MessageResponsePacket.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:provider/provider.dart';

Map<int, Function> socketHandler = const {
  Command.LOGIN_RESPONSE: loginResponseHandler,
  Command.HEARTBEAT_RESPONSE: heartBeatResponseHandler,
  Command.MESSAGE_RESPONSE: messageResponseHandler,
  Command.GET_FRIENDS_RESPONSE: getFriendsResponseHandler,
};

void loginResponseHandler(String json) {
  LoginResponsePacket packet = LoginResponsePacket.fromJson(json);
  if (packet.success) {
    showToast("登录成功!");
    Application.loginUser = UserInfo.fromJson(packet.userInfo);
    MyRouter.navigatorKey.currentState.pushNamed("/");
  } else {
    showToast(packet.reason);
  }
}

void heartBeatResponseHandler(String json) {
  print("接收心跳包响应");
}

void messageResponseHandler(String json) {
  MessageResponsePacket packet = MessageResponsePacket.fromJson(json);
  Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).addChatData(packet.messageInfo);
}

void getFriendsResponseHandler(String json) {
  GetFriendsResponsePacket packet = GetFriendsResponsePacket.fromJson(json);
  Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).importUserList(packet.userList);
}
