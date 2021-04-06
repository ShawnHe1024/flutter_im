import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/pages/chatting_page.dart';

class MainChattingWidget extends StatefulWidget {
  final UserInfo userInfo;
  MainChattingWidget(this.userInfo, {Key key}) : super(key: key);

  @override
  _MainChattingWidgetState createState() => _MainChattingWidgetState();
}

class _MainChattingWidgetState extends State<MainChattingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
          return new ChattingPage(widget.userInfo);
        }));
      },
      child: Container(
        height: ScreenUtil().getHeight(70),
        decoration: BoxDecoration(),
        child: Row(
          children: [chat_image(), chat_content()],
        ),
      ),
    );
  }

  Widget chat_content() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(218, 218, 218, 0.5)
                )
            )
        ),
        child: Column(
          children: [
            chat_info(),
            Container(
              padding: EdgeInsets.only(top: 10, right: 35),
              alignment: Alignment.bottomLeft,
              child: Text(
                lastMessageText(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),

            )
          ],
        ),
      ),
    );
  }

  String lastMessageText() {
    if (widget.userInfo.lastMessage.type == 1) {
      return widget.userInfo.lastMessage.content;
    }
    if (widget.userInfo.lastMessage.type == 3) {
      return "[语音]";
    }
  }

  Widget chat_info() {
    DateTime lastChatTime = DateTime.fromMillisecondsSinceEpoch(widget.userInfo.lastMessage.sendTime);
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  widget.userInfo.nickname,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Text(
              lastChatTime.month.toString()+"-"+lastChatTime.day.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget chat_image() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CachedNetworkImage(
          imageUrl: widget.userInfo.avatar,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          errorWidget: (context, str, o) {
            return Image.asset(
                'assets/samurai_V_1080x1920.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            );
          },
        ),
      )
    );
  }

}
