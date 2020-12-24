import 'package:flutter/material.dart';

class TopMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Container(
        child: Icon(
          Icons.menu,
          size: 30,
        ),
      ),
    );
  }
}
