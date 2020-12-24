
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/pages/error_page.dart';
import 'package:flutter_im/pages/login_page.dart';
import 'package:flutter_im/pages/splash_page.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/provider/ChatListStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  var _appStateProvide = AppStateProvide();
  var _chatListStateProvide = ChatListStateProvide();
  Application.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStateProvide>.value(value: _appStateProvide),
        ChangeNotifierProvider<ChatListStateProvide>.value(value: _chatListStateProvide),
      ],
      child: MyApp(),
    )
  );
  SystemUtils.initConnectivity();
  SystemUtils.connectivityInitState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Application.TITLE_DEFAULT,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // ChineseCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
      navigatorKey: MyRouter.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        String routeName = settings.name;
        WidgetBuilder builder = MyRouter.routerMap[routeName];
        if (builder == null) {
          builder = (content) => ErrorPage(msg: "This page is not found!",);
        }
        if (!anno.contains(routeName) && Application.loginUser == null) {
          builder = (content) => LoginPage();
        }
        final route = MaterialPageRoute(
          builder: builder,
          settings: settings
        );
        return route;
      },
      builder: (context, child) => Scaffold(
        body: child,
      ),
    );
  }

  List<String> anno = [
    // "/",
    "/login",
  ];
}
