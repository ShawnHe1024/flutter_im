import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/packet/request/LoginRequestPacket.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登陆'),
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text('忘记密码')
                      ),
                    ),
                    SizedBox(
                      width: 1,
                      height: 13 ,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('注册账号')
                      ),
                    ),
                  ],
                ),
              )
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
            TextFormField(
              autofocus: _nameAutoFocus,
              controller: _unameController,
              decoration: InputDecoration(
                  hintText: '请输入用户名/邮箱',
                  prefixIcon: Icon(Icons.person)),
              validator: (v) {
                return v.trim().isNotEmpty ? null : '用户名不能为空';
              },
            ),
            TextFormField(
              controller: _pwdController,
              autofocus: !_nameAutoFocus,
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
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: ScreenUtil().getHeight(55)),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _onLogin,
                  textColor: Colors.white,
                  child: Text('登陆'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onLogin() {
    if ((_formKey.currentState as FormState).validate()) {
      String username = _unameController.text;
      String password = _pwdController.text;
      LoginRequestPacket req =
          LoginRequestPacket(username: username, password: password);
      Application.networkManager.sendMsg(req);
    }
  }
}
