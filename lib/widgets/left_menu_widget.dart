import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/packet/request/LogoutRequestPacket.dart';

class LeftMenuWidget extends StatefulWidget {
  LeftMenuWidget({Key key}) : super(key: key);

  @override
  _LeftMenuWidgetState createState() => _LeftMenuWidgetState();
}

class _LeftMenuWidgetState extends State<LeftMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: ScreenUtil().getHeight(190),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: Application.loginUser.avatar.isNotEmpty?Image.memory(Base64Decoder().convert(Application.loginUser.avatar)).image:null
              ),
              accountName: Text(Application.loginUser.nickname),
              accountEmail: null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
          ),
          Divider(), //分割线
          ListTile(
            leading: Icon(Icons.close),
            title: Text('退出'),
            onTap: () {
              LogoutRequestPacket req = LogoutRequestPacket();
              Application.networkManager.sendMsg(req);
              Application.loginUser = null;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => route == null);
            }, // 关闭抽屉
          )
        ],
      ),
    );
  }
}
