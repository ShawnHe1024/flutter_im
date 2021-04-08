import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/GetFriendsRequestPacket.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/widgets/main_chatting_widget.dart';
import 'package:provider/provider.dart';

class ChattingListPage extends StatefulWidget {
  ChattingListPage({Key key}) : super(key: key);

  @override
  _ChattingListPageState createState() => _ChattingListPageState();
}

class _ChattingListPageState extends State<ChattingListPage> {

  @override
  Widget build(BuildContext context) {
    List<UserInfo> chatList = context.watch<ChatListStateProvide>().chatMap?.values?.toList();
    return RefreshIndicator(
      onRefresh: _getFriends,
      child: ListView.builder(
        itemCount: chatList?.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(chatList[index].id.toString()),
              background: dismissBackGround(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                context.read<ChatListStateProvide>().removeFromChatMap(chatList[index].id);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("删除一行"),
                ));
              },
              // child: MainChattingWidget(infos[index])
              child: MainChattingWidget(chatList[index].id)
          );
        },
      ),
    );
  }

  Widget dismissBackGround() {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
            Text(
              "删除",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getFriends() async {
    GetFriendsRequestPacket req = GetFriendsRequestPacket(Application.loginUser.id);
    Application.networkManager.sendMsg(req);
  }

}