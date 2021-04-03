import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  Widget baseDialog() {
    return SizedBox(
      width: 200,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: baseDialog(),
    );
  }
}
