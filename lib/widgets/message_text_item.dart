
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/MessageInfo.dart';
import 'package:path_provider/path_provider.dart';

class MessageTextItem extends StatelessWidget {
  final MessageInfo messageInfo;
  final String avatarUrl;

  MessageTextItem(this.messageInfo, this.avatarUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: messageInfo.isSelf?_MineMessage():_OtherMessage()
    );
  }

  Widget _MineMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 40
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  margin: EdgeInsets.only(left: 50),
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(149, 236, 105, 1),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showContent()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image(
            image: Application.loginUser.avatar.isNotEmpty?Image.memory(Base64Decoder().convert(Application.loginUser.avatar)).image:null,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _OtherMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image(
            image: avatarUrl.isNotEmpty?Image.memory(Base64Decoder().convert(avatarUrl)).image:null,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 40
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  margin: EdgeInsets.only(right: 50),
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showContent()
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  
  Widget showContent() {
    if (messageInfo.type == 1) {
      return Text(
        messageInfo.content,
        style: TextStyle(
            fontSize: 18
        ),
      );
    }
  }

  Future<String> getPath() async {
    Directory tempDir = await getTemporaryDirectory();
    File file = new File(tempDir.path+"/"+DateTime.now().millisecond.toString()+".wav");
    file.writeAsBytes(List.castFrom<dynamic, int>(messageInfo.content));

    return file.path;
  }

}
