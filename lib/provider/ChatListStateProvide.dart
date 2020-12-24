import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/MessageInfo.dart';
import 'package:flutter_im/model/UserInfo.dart';

class ChatListStateProvide with ChangeNotifier {

  Map<int, UserInfo> chatMap = LinkedHashMap();

  Map<int, List<MessageInfo>> chatDataMap = LinkedHashMap();

  addChatData(MessageInfo messageInfo) {
    int friendId;
    if (messageInfo.isSelf) {
      if (chatDataMap[messageInfo.toUserId] == null) {
        chatDataMap[messageInfo.toUserId] = List();
      }
      chatDataMap[messageInfo.toUserId].add(messageInfo);
      friendId = messageInfo.toUserId;
    } else {
      if (chatDataMap[messageInfo.fromUserId] == null) {
        chatDataMap[messageInfo.fromUserId] = List();
      }
      chatDataMap[messageInfo.fromUserId]?.add(messageInfo);
      friendId = messageInfo.fromUserId;
    }
    chatMap[friendId]?.lastMessage = messageInfo;
    //Todo: 这里可以往list里重新添加一次
    notifyListeners();
  }

  importUserList(List<UserInfo> users) {
    chatMap = Map.fromIterable(users, key: (v)=>v.id, value: (v)=>v);
    notifyListeners();
  }

  removeFromChatMap(int key) {
    chatMap.remove(key);
    notifyListeners();
  }

}