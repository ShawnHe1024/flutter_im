import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/packet/request/LogoutRequestPacket.dart';
import 'package:flutter_im/packet/request/UpdateAvatarRequestPacket.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class LeftMenuWidget extends StatefulWidget {
  LeftMenuWidget({Key key}) : super(key: key);

  @override
  _LeftMenuWidgetState createState() => _LeftMenuWidgetState();
}

class _LeftMenuWidgetState extends State<LeftMenuWidget> {
  PickedFile _imageFile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: ScreenUtil().getHeight(190),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              currentAccountPicture: InkWell(
                onTap: () async {
                  _imageFile = await SystemUtils.onImageButtonPressed(ImageSource.gallery);
                  if (_imageFile != null) {
                    _updateAvatar();
                  }
                },
                child: CircleAvatar(
                  backgroundImage: Application.loginUser.avatar.isNotEmpty?Image.memory(Base64Decoder().convert(Application.loginUser.avatar)).image:null
                ),
              ),
              accountName: Text(Application.loginUser.nickname),
              accountEmail: null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
          ),
          Divider(), //分割线
          ListTile(
            leading: Icon(Icons.close),
            title: Text('退出'),
            onTap: () {
              LogoutRequestPacket req = LogoutRequestPacket();
              Application.networkManager.sendMsg(req);
              Application.loginUser = null;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => route == null);
            }, // 关闭抽屉
          )
        ],
      ),
    );
  }



  void _updateAvatar() async {
      if(_imageFile == null) {
        showToast('请上传头像');
      }
      List<int> imageBytes = await FlutterImageCompress.compressWithFile(_imageFile.path, quality: 20);
      String avatar = base64Encode(imageBytes);
      UpdateAvatarRequestPacket req = UpdateAvatarRequestPacket(avatar);
      Application.networkManager.sendMsg(req);
  }

}
