import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

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
                backgroundImage: NetworkImage(
                    "https://t8.baidu.com/it/u=3571592872,3353494284&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1603784809&t=e1ea1f77a0c09c75a369667a180335e7"
                ),
              ),
              accountName: Text('hhh eee'),
              accountEmail: Text('+86 132-9657-2347'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
          ),
          Divider(), //分割线
          ListTile(
            leading: Icon(Icons.close),
            title: Text('关闭'),
            onTap: () => Navigator.pop(context), // 关闭抽屉
          )
        ],
      ),
    );
  }
}