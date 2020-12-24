import 'dart:async';
import 'dart:ffi';
import 'dart:wasm';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/model/UserInfo.dart';
import 'package:flutter_im/packet/request/GetFriendsRequestPacket.dart';
import 'package:flutter_im/pages/chatting_list_page.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_im/widgets/left_menu_widget.dart';
import 'package:flutter_im/widgets/main_chatting_widget.dart';
import 'package:flutter_im/widgets/top_menu_bar.dart';
import 'package:flutter_im/widgets/top_search_bar.dart';
import 'package:flutter_im/widgets/top_text.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<String> items = ["1", "2", "3", "4", "5"];
  // Map<int, UserInfo> infos = {
  //   0: UserInfo(1606545041394, "张三", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604150721447&di=0f056f5e94ecf98480ffe0148c856cae&imgtype=0&src=http%3A%2F%2Fwx1.sinaimg.cn%2Fmw690%2F0073VjWaly1ghpdxy883vj30u00u0h17.jpg"),
  //   1: UserInfo(2, "李四", "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1441836571,2166773131&fm=26&gp=0.jpg"),
  //   2: UserInfo(3, "王五", "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3947572783,1476163811&fm=26&gp=0.jpg"),
  //   3: UserInfo(4, "赵六", "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3874067489,2447793058&fm=11&gp=0.jpg"),
  //   4: UserInfo(5, "田七", "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=104284501,1183953633&fm=11&gp=0.jpg"),
  // };
  DateTime lastPopTime;

  @override
  void dispose() {
    super.dispose();
    SystemUtils.connectivityDispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Application.loginUser == null) {
      Navigator.of(context).pushNamed('/login');
    }
    return Scaffold(
      appBar: AppBar(
        leading: TopMenuBar(),
        title: TopText(),
        actions: [TopSearchBar()],
      ),
      drawer: LeftMenuWidget(),
      //使用全屏宽度时会覆盖其他的滑动事件
      // drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      // endDrawerEnableOpenDragGesture: false,
      body: WillPopScope(
        onWillPop: () async {
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) >
                  Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            showToast('再按一次退出');
            return Future.value(false);
          } else {
            lastPopTime = DateTime.now();
            return Future.value(true);
          }
        },
        child: ChattingListPage()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/loin');
        },
        child: Icon(
          Icons.edit,
          size: 30,
        ),
      ), // This t
      // railing comma makes auto-formatting nicer for build methods.
    );
  }

}

