import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/packet/request/LoginRequestPacket.dart';
import 'package:flutter_im/packet/request/RegisterRequestPacket.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _unameController = new TextEditingController();
  final TextEditingController _nickNameController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();
  final TextEditingController _avatarController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;
  PickedFile _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: SingleChildScrollView(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/samurai_V_1080x1920.png'),
        //     fit: BoxFit.cover
        //   )
        // ),
        child: Center(
          child: Column(
            children: [
              loginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery);
              },
              child: CircleAvatar(
                  backgroundImage: _imageFile != null?Image.file(File(_imageFile.path)).image:null
              ),
            ),
            TextFormField(
              autofocus: _nameAutoFocus,
              controller: _unameController,
              decoration: InputDecoration(
                  hintText: '请输入用户名',
                  prefixIcon: Icon(Icons.person)),
              validator: (v) {
                return v.trim().isNotEmpty ? null : '用户名不能为空';
              },
            ),
            TextFormField(
              controller: _nickNameController,
              decoration: InputDecoration(
                  hintText: '请输入昵称',
                  prefixIcon: Icon(Icons.account_circle)),
              validator: (v) {
                return v.trim().isNotEmpty ? null : '昵称不能为空';
              },
            ),
            TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                  hintText: '请输入密码',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon:
                        Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                  )),
              obscureText: !pwdShow,
              validator: (v) {
                return v.trim().isNotEmpty ? null : '密码不能为空';
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: '请确认输入密码',
                  prefixIcon: Icon(Icons.lock),
                  ),
              obscureText: true,
              validator: (v) {
                return v.trim().isNotEmpty ? v.compareTo(_pwdController.text) == 0? null : '两次密码输入不一致' : '密码不能为空';
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: ScreenUtil().getHeight(55)),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _onRegister,
                  textColor: Colors.white,
                  child: Text('注册'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onRegister() {
    if ((_formKey.currentState as FormState).validate()) {
      String username = _unameController.text;
      String nickname = _nickNameController.text;
      String password = _pwdController.text;
      String avatar = _avatarController.text;
      RegisterRequestPacket req = RegisterRequestPacket(username, nickname, password, avatar);
      Application.networkManager.sendMsg(req);
    }
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext context}) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: 300,
          maxHeight: 300,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          showToast('选择图片时发生错误');
        });
      }
  }

}
