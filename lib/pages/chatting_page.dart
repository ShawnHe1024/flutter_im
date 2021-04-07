import 'dart:async';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/animate/SlideTransitionX.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/MessageInfo.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/MessageRequestPacket.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_im/widgets/chat_edit_widget.dart';
import 'package:flutter_im/widgets/message_text_item.dart';
import 'package:provider/provider.dart';

class ChattingPage extends StatefulWidget {
  final UserInfo userInfo;
  ChattingPage(this.userInfo, {Key key}) : super(key: key);

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

bool _isShowEmoji = false;

class _ChattingPageState extends State<ChattingPage>{

  bool encrypt = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Text(widget.userInfo.online?'在线':'离线'),
              Text(widget.userInfo.nickname),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              encrypt = true;
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                encrypt?Icons.enhanced_encryption:Icons.no_encryption,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Builder(builder: (context) {
        List<MessageInfo> list = context.watch<ChatListStateProvide>().chatDataMap[widget.userInfo.id];
        return GestureDetector(
          onTap: () {
            setState(() {
              _isShowEmoji = false;
            });
            SystemUtils.hideKeyBoard();
          },
          child: Container(
            color: Color.fromRGBO(208, 217, 224, 1),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: context.watch<ChatListStateProvide>().chatDataMap[widget.userInfo.id]?.length,
                      itemBuilder: (context, index) {
                        if (list != null) {
                          // list.sort((a, b) => b.sendTime.compareTo(a.sendTime));
                          return MessageTextItem(list[list.length-1-index], widget.userInfo.avatar);
                        } else {
                          return null;
                        }
                      }
                  ),
                ),
                ChatEditWidget(_isShowEmoji, _sendMsg),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _sendMsg(msg, type) {
    if (msg != null && msg.isNotEmpty) {
      MessageInfo info = MessageInfo(
          null, Application.loginUser.id, widget.userInfo.id,
          msg, type);
      MessageRequestPacket req = MessageRequestPacket(info);
      // context.read<ChatListStateProvide>().addChatData(info);
      Application.networkManager.sendMsg(req);
    }
  }

  @override
  void initState() {
    _isShowEmoji = false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
