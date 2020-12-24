
import 'package:flutter/cupertino.dart';
import 'package:flutter_im/common/Application.dart';

class AppStateProvide with ChangeNotifier {

  String homeTitle = Application.TITLE_DEFAULT;

  changeHomeTitle(String text) {
    homeTitle = text;
    notifyListeners();
  }

}