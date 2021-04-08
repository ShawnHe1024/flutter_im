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
import 'package:flutter_im/packet/request/EncryptRequestPacket.dart';
import 'package:flutter_im/packet/request/MessageRequestPacket.dart';
import 'package:flutter_im/packet/response/EncryptResponsePacket.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_im/widgets/chat_edit_widget.dart';
import 'package:flutter_im/widgets/message_text_item.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:provider/provider.dart';

class ChattingPage extends StatefulWidget {
  final int userId;
  ChattingPage(this.userId, {Key key}) : super(key: key);
  UserInfo _userInfo;

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

bool _isShowEmoji = false;

class _ChattingPageState extends State<ChattingPage>{

  bool encrypt = false;

  @override
  Widget build(BuildContext context) {
    widget._userInfo = context.watch<ChatListStateProvide>().chatMap[widget.userId];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Column(
            children: [
              Text(widget._userInfo.nickname),
              Text(
                  widget._userInfo.online?'在线':'离线',
                style: TextStyle(
                  fontSize: 10
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              encrypt = true;
              setState(() {
                _enableEncrypt();
              });
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
        List<MessageInfo> list = context.watch<ChatListStateProvide>().chatDataMap[widget._userInfo.id];
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
                      itemCount: context.watch<ChatListStateProvide>().chatDataMap[widget._userInfo.id]?.length,
                      itemBuilder: (context, index) {
                        if (list != null) {
                          // list.sort((a, b) => b.sendTime.compareTo(a.sendTime));
                          return MessageTextItem(list[list.length-1-index], widget._userInfo.avatar);
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
      if (widget._userInfo.publicKey != null) {
        msg = SystemUtils.rsaEncrypt(widget._userInfo.publicKey, msg);
        type = 2;
      }
      MessageInfo info = MessageInfo(
          null, Application.loginUser.id, widget._userInfo.id,
          msg, type);
      MessageRequestPacket req = MessageRequestPacket(info);
      // context.read<ChatListStateProvide>().addChatData(info);
      Application.networkManager.sendMsg(req);
    }
  }

  void _enableEncrypt() {
    final pair = SystemUtils.generateRSAkeyPair();
    final public = pair.publicKey;
    final private = pair.privateKey;
    EncryptResponsePacket responsePacket =
      EncryptResponsePacket(widget._userInfo.id, true, public.modulus, public.exponent);
    Provider.of<ChatListStateProvide>(MyRouter.navigatorKey.currentContext, listen: false)
        .chatMap[widget._userInfo.id].privateKey = private;
    Application.networkManager.sendMsg(responsePacket);
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
