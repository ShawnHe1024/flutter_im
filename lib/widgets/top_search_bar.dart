import 'package:flutter/material.dart';

class TopSearchBar extends StatefulWidget {
  TopSearchBar({Key key}) : super(key: key);

  @override
  _TopSearchBarState createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/login');
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: Icon(
          Icons.search,
          size: 30,
        ),
      ),
    );
  }
}