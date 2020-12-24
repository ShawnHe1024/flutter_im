import 'package:flutter/widgets.dart';
import 'package:flutter_im/pages/chatting_page.dart';
import 'package:flutter_im/pages/login_page.dart';
import 'package:flutter_im/pages/my_home_page.dart';
import 'package:flutter_im/pages/splash_page.dart';

class MyRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final Map<String, WidgetBuilder> routerMap = {
    // '/': (content) => SplashPage(),
    '/': (content) => MyHomePage(),
    '/login': (content) => LoginPage()
  };
}
