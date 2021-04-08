import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/common/Command.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/EncryptRequestPacket.dart';
import 'package:flutter_im/packet/request/SearchFriendRequestPacket.dart';
import 'package:flutter_im/packet/request/UpdateAvatarRequestPacket.dart';
import 'package:flutter_im/packet/response/EncryptResponsePacket.dart';
import 'package:flutter_im/packet/response/ForwardResponsePacket.dart';
import 'package:flutter_im/packet/response/GetFriendsResponsePacket.dart';
import 'package:flutter_im/packet/response/LoginResponsePacket.dart';
import 'package:flutter_im/packet/response/MessageResponsePacket.dart';
import 'package:flutter_im/packet/response/SearchFriendResponsePacket.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:provider/provider.dart';

Map<int, Function> socketHandler = const {
  Command.LOGIN_RESPONSE: loginResponseHandler,
  Command.HEARTBEAT_RESPONSE: heartBeatResponseHandler,
  Command.MESSAGE_RESPONSE: messageResponseHandler,
  Command.GET_FRIENDS_RESPONSE: getFriendsResponseHandler,
  Command.SEARCH_FRIEND_RESPONSE: searchFriendResponseHandler,
  Command.ADD_FRIEND_RESPONSE: null,
  Command.ENCRYPT_RESPONSE: encryptResponsePacketHandler,
  Command.FORWARD_RESPONSE: forwardResponsePacketHandler,
  Command.UPDATE_AVATAR_REQUEST: updateAvatarRequestPacketHandler,
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
}

void messageResponseHandler(String json) {
  MessageResponsePacket packet = MessageResponsePacket.fromJson(json);
  if (packet.messageInfo.type == 2) {
    int id = packet.messageInfo.isSelf?packet.messageInfo.toUserId:packet.messageInfo.fromUserId;
    UserInfo userInfo = Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).chatMap[id];
    packet.messageInfo.content = SystemUtils.rsaDecrypt(userInfo.privateKey, packet.messageInfo.content);
  }
  Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).addChatData(packet.messageInfo);
}

void getFriendsResponseHandler(String json) {
  GetFriendsResponsePacket packet = GetFriendsResponsePacket.fromJson(json);
  Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).importUserList(packet.userList);
}

void searchFriendResponseHandler(String json) {
  SearchFriendResponsePacket packet = SearchFriendResponsePacket.fromJson(json);
  Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).getSearchResult(packet);
}

void updateAvatarRequestPacketHandler(String json) {
  UpdateAvatarRequestPacket packet = UpdateAvatarRequestPacket.fromJson(json);
  Application.loginUser.avatar = packet.avatar;
}

void forwardResponsePacketHandler(String json) {
  ForwardResponsePacket packet = ForwardResponsePacket.fromJson(json);
  showToast(packet.reason);
}

void encryptResponsePacketHandler(String json) {
  EncryptResponsePacket packet = EncryptResponsePacket.fromJson(json);
  if (packet.agree) {
    UserInfo userInfo = Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).chatMap[packet.userId];
    if (userInfo.privateKey == null) {
      final pair = SystemUtils.generateRSAkeyPair();
      final public = pair.publicKey;
      final private = pair.privateKey;
      EncryptResponsePacket responsePacket = EncryptResponsePacket(packet.userId, true, public.modulus, public.exponent);
      Application.networkManager.sendMsg(responsePacket);
      Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false)
          .updateRSA(packet.userId, RSAPublicKey(packet.modulus, packet.exponent), private);
    } else {
      Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false)
          .updateRSA(packet.userId, RSAPublicKey(packet.modulus, packet.exponent), userInfo.privateKey);
    }
  } else {
    showToast("对方拒绝了您的加密通信请求！");
  }

}
