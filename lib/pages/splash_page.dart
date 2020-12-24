import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: do something to init
    super.initState();
    startHome();
  }

  startHome() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        child: Image(image: AssetImage('assets/samurai_V_1080x1920.png'), fit: BoxFit.fill,),
      );
    });
  }
}
