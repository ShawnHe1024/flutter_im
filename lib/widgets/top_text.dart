import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:provider/provider.dart';

class TopText extends StatefulWidget {
  String title;

  @override
  _TopTextState createState() => _TopTextState();
}

class _TopTextState extends State<TopText> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> animation;
  List<String> dot = ["", ".", "..", "..."];
  String finalTitle = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this);
    animation = new IntTween(begin: 0, end: 3).animate(_controller);
    animation.addListener(() {
      this.setState(() {
        finalTitle = widget.title + dot[animation.value];
      });
    });
    _controller.forward();
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.title = context.watch<AppStateProvide>().homeTitle;
    if (widget.title == Application.TITLE_DEFAULT) {
      finalTitle = widget.title;
      _controller.stop();
    } else {
      _controller.repeat(reverse: false);
    }
    return Container(
      child: Text(finalTitle),
    );
  }
}
