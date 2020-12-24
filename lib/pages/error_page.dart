import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String msg;

  const ErrorPage({Key key, this.msg}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'OOPS!',
                  style: TextStyle(fontSize: 30),
                ),
                Text(msg),
                FlatButton(
                  child: Text('Go to Home Page'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
