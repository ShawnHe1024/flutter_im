import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/GetFriendsRequestPacket.dart';
import 'package:flutter_im/packet/request/LoginRequestPacket.dart';
import 'package:flutter_im/packet/request/RegisterRequestPacket.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_im/widgets/LoadingDialog.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class SearchResultPage extends StatefulWidget {
  SearchResultPage({Key key}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("请搜索"), actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {
        },)
      ],),
    );
  }

}

class SearchBarDelegate extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      //放置按钮，点击时，将搜索框清空
      IconButton(
        icon:Icon(Icons.clear),
        onPressed: (){
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton( //返回动态按钮
      icon:AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){ //回调中调用close方法，关闭搜索页面
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Object>(
        future: _searchFrieds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInfo userInfo = snapshot.data;
            return Container(
              height: ScreenUtil().getHeight(70),
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: userInfo.avatar,
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
                  ),
                  Expanded(
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
                                Container(
                                  margin: EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5.0),
                                            child: Text(
                                              userInfo.nickname,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                          )
                      )
                  ),
                  InkWell(
                    onTap: () {
                      print('添加好友');
                    },
                    child: Container(
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('暂未找到相关用户！'),
            );
          }
        }
    );
  }
}

Future _searchFrieds() async {
  GetFriendsRequestPacket req = GetFriendsRequestPacket(Application.loginUser.id);
  Application.networkManager.sendMsg(req);
}
