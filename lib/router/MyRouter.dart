import 'package:flutter/widgets.dart';
import 'package:flutter_im/pages/chatting_page.dart';
import 'package:flutter_im/pages/login_page.dart';
import 'package:flutter_im/pages/my_home_page.dart';
import 'package:flutter_im/pages/register_page.dart';
import 'package:flutter_im/pages/search_result_page.dart';
import 'package:flutter_im/pages/splash_page.dart';

class MyRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final Map<String, WidgetBuilder> routerMap = {
    // '/': (content) => SplashPage(),
    '/': (content) => MyHomePage(),
    '/register': (content) => RegisterPage(),
    '/login': (content) => LoginPage(),
    '/search': (content) => SearchResultPage()
  };
}
