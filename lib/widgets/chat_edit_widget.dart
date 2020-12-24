import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/utils/SystemUtils.dart';
import 'package:flutter_im/widgets/voice_widget.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';

class ChatEditWidget extends StatefulWidget {
  bool _isShowEmoji;
  FlutterPluginRecord _recordPlugin;
  Function(Object, int) _sendMsg;

  ChatEditWidget(this._isShowEmoji, this._sendMsg, this._recordPlugin);

  @override
  _ChatEditWidgetState createState() => _ChatEditWidgetState();
}

class _ChatEditWidgetState extends State<ChatEditWidget> {
  TextEditingController _editingController;
  bool _isVoiceMsg;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _isVoiceMsg = false;
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isVoiceMsg = !_isVoiceMsg;
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 5, bottom: 10),
                    child: Icon(
                      _isVoiceMsg?Icons.keyboard:Icons.keyboard_voice_outlined,
                      color: Color.fromRGBO(142, 149, 155, 1),
                      size: 30.0,
                    )
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  constraints: BoxConstraints(
                    minHeight: 50.0
                  ),
                  child: _isVoiceMsg?
                  VoiceWidget(startRecord: startRecord, stopRecord: stopRecord):
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 255,
                      showCursor: true,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(142, 149, 155, 1),
                        ),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        // filled: true,
                        // fillColor: Color.fromRGBO(142, 149, 155, 1),
                      ),
                      onTap: () {
                        SystemUtils.showKeyBoard();
                        setState(() {
                          widget._isShowEmoji = false;
                          _isVoiceMsg = false;
                        });
                      },
                      //有内容时刷新页面，加载发送图标
                      onChanged: (String val) {
                        setState(() {
                        });
                      },
                      controller: _editingController,
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchOutCurve: Curves.bounceIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation, alignment: Alignment.centerRight,);
                },
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (!widget._isShowEmoji) {
                          //延迟50ms执行，否则表情组件会先被顶上去
                          SystemUtils.hideKeyBoard();
                          Future.delayed(Duration(milliseconds: 100));
                          // Future.delayed(Duration(milliseconds: 50), () {
                          setState(() {
                            widget._isShowEmoji = true;
                            _isVoiceMsg = false;
                          });
                          // });
                        } else {
                          SystemUtils.showKeyBoard();
                          setState(() {
                            widget._isShowEmoji = false;
                            _isVoiceMsg = false;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, bottom: 10),
                        child: Icon(
                          widget._isShowEmoji?Icons.keyboard:Icons.emoji_emotions_outlined,
                          color: Color.fromRGBO(142, 149, 155, 1),
                          size: 30.0,
                        ),
                      ),
                    ),
                    _editingController.text.length > 0?
                    InkWell(
                      onTap: () {
                        widget._sendMsg(_editingController.text, Application.MSG_TYPE_TEXT);
                        _editingController.clear();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 30.0,
                        ),
                      ),
                    ) :
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(142, 149, 155, 1),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: widget._isShowEmoji,
            child: Container(
              child: Emoji(),
            ),
          )
        ],
      ),
    );
  }

  Widget Emoji() {
    return SizedBox(
      // height: 460.9,
      child: EmojiPicker(
        buttonMode: ButtonMode.MATERIAL,
        // recommendKeywords: ["racing", "horse"],
        // numRecommended: 10,
        rows: 5,
        onEmojiSelected: (emoji, category) {
          setState(() {
            _editingController.text += emoji.emoji;
            _editingController.selection = TextSelection.fromPosition(
                TextPosition(offset: _editingController.text.length)
            );
          });
        },
      ),
    );
  }

  startRecord() {
    print("开始录音");
  }

  stopRecord(path, length) {
    print("文件地址："+path);
    File file = new File(path);
    widget._sendMsg(file.readAsBytesSync(), 3);
  }



}
