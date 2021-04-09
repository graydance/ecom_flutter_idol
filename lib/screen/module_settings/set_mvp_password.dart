import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/Strings.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/widgets/ui.dart';
import 'package:redux/redux.dart';

import '../../router.dart';

class SetMVPPassword extends StatefulWidget {
  SetMVPPassword();

  factory SetMVPPassword.forDesignTime() {
    return new SetMVPPassword();
  }

  @override
  State<StatefulWidget> createState() => _SetMVPPasswordState();
}

class _SetMVPPasswordState extends State<SetMVPPassword> {
  List<bool> index = [true, true, true];
  List<String> passwordStr = [null, null, null];
  String _errorText;
  String _errorNewText;
  Color _btnStartColor = Colours.color_C4C5CD;
  Color _btnEndColor = Colours.color_E7E8EC;

  // ignore: non_constant_identifier_names
  TextEditingController _ConfirmController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController _OldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  //状态监听
  @override
  // ignore: must_call_super
  void initState() {
    //老密码（当前密码）
    _OldPasswordController.addListener(() {
      passwordStr[0] = _OldPasswordController.text;
    });
    //输入密码监听
    _newPasswordController.addListener(() {
      passwordStr[1] = _newPasswordController.text;
    });

    //确认密码监听
    _ConfirmController.addListener(() {
      passwordStr[2] = _ConfirmController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        // 1.不要用onWillChange
        // onWillChange: (oldVM, newVM) {
        //   _onStateChanged(newVM._updatePasswordState);
        // },
        builder: (context, vm) {
          return Scaffold(
            appBar: IdolUI.appBar(context, StringBasic.setPasswordTitle),
            body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // 触摸收起键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                  _checkMessage();
                },
                child: _buildBodyWidget(vm)),
          );
        });
  }

  // ignore: missing_return
  Widget _buildBodyWidget(_ViewModel vm) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _bodyContent(vm)),
      ),
    );
  }

  _bodyContent(_ViewModel vm) {
    return [
      SizedBox(
        height: 40,
      ),
      new Container(
        margin: EdgeInsets.only(left: 16),
        child: new Text(
          StringBasic.setPasswordCurrent,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14, color: Colours.black),
        ),
      ),
      new Container(
        padding: EdgeInsets.only(left: 16, bottom: 7, right: 16),
        child: new TextField(
          //光标颜色
          cursorColor: Colours.black,
          //设置光标是否可编辑
          enabled: true,
          //回车键响应模式
          textInputAction: TextInputAction.done,
          //输入内容是否可见
          obscureText: index[0],
          //限制输入最大字符数
          maxLength: 10,
          //控制当达到输入字符数上限时是否还可再输入
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: _OldPasswordController,
          onChanged: (value) {
            passwordStr[0] = value;
            _btnStateListener();
          },
          decoration: InputDecoration(
            hintText: StringBasic.setPasswordEnter,
            //取消显示输入字符数量
            counterText: "",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black, //边框颜色为黑色
            )),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    index[0] = !index[0];
                  });
                },
                child: new Container(
                    padding: EdgeInsets.all(10), child: _Images(0))),
          ),
        ),
      ),
      new Container(
        margin: EdgeInsets.only(left: 16, top: 20),
        child: new Text(
          StringBasic.setPasswordNew,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14, color: Colours.black),
        ),
      ),
      new Container(
        padding: EdgeInsets.only(left: 16, bottom: 7, right: 16),
        child: new TextField(
          cursorColor: Colours.black,
          //光标颜色
          enabled: true,
          //限制输入最大字符数
          maxLength: 50,
          //控制当达到输入字符数上限时是否还可再输入
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          //设置光标是否可编辑
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            passwordStr[1] = value;
            _btnStateListener();
          },
          //回车键响应模式
          //输入内容是否可见
          obscureText: index[1],
          controller: _newPasswordController,
          onSubmitted: (String text) {
            if (!TextUtil.isEmpty(passwordStr[1]) && text != passwordStr[1]) {
              _errorText = StringBasic.setPasswordOps;
            } else {
              _errorText = null;
            }

            if (TextUtil.isEmpty(passwordStr[1]) || passwordStr[1].length < 8) {
              _errorNewText = StringBasic.setPasswordCharacter;
            } else {
              _errorNewText = null;
            }
          },
          decoration: InputDecoration(
            hintText: StringBasic.setPasswordInto,
            //取消显示输入字符数量
            counterText: "",
            errorText: _getNewErrorText(),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black, //边框颜色为黑色
            )),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    index[1] = !index[1];
                  });
                },
                child: new Container(
                    padding: EdgeInsets.only(
                        top: 10, right: 10, bottom: 10, left: 10),
                    child: _Images(1))),
          ),
        ),
      ),
      new Container(
        margin: EdgeInsets.only(left: 16, top: 20),
        child: new Text(
          StringBasic.setPasswordConfirm,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14, color: Colours.black),
        ),
      ),
      new Container(
          padding: EdgeInsets.only(left: 16, bottom: 7, right: 16),
          child: new TextField(
            cursorColor: Colours.black,
            //光标颜色
            enabled: true,
            //限制输入最大字符数
            maxLength: 50,
            //控制当达到输入字符数上限时是否还可再输入
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            //设置光标是否可编辑
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              passwordStr[1] = value;
              _btnStateListener();
            },
            controller: _ConfirmController,
            onSubmitted: (String text) {
              setState(() {
                if (!TextUtil.isEmpty(passwordStr[1]) &&
                    passwordStr[1].length < 8) {
                  _errorText = StringBasic.setPasswordCharacter;
                } else {
                  if (TextUtil.isEmpty(passwordStr[1]) ||
                      text != passwordStr[1]) {
                    _errorText = StringBasic.setPasswordOps;
                  } else {
                    _errorText = null;
                  }
                }
              });
            },
            //回车键响应模式
            obscureText: index[2],
            decoration: InputDecoration(
              hintText: StringBasic.setPasswordConfirmInto,
              errorText: _getErrorText(),
              //取消显示输入字符数量
              counterText: "",
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black, //边框颜色为黑色
              )),
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      index[2] = !index[2];
                    });
                  },
                  child: new Container(
                    padding: EdgeInsets.only(
                        top: 10, right: 10, bottom: 10, left: 10),
                    child: _Images(2),
                  )),
            ),
          )),
      new Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient:
                LinearGradient(colors: <Color>[_btnStartColor, _btnEndColor])),
        // ignore: deprecated_member_use
        child: FlatButton(
          onPressed: () {
            _checkMessage();
            _checkContent(vm);
          },
          child: Text(StringBasic.setPasswordUpdate),
          textColor: Colours.white,
        ),
      ),
    ];
  }

  _getErrorText() {
    return _errorText;
  }

  _getNewErrorText() {
    return _errorNewText;
  }

  _btnStateListener() {
    setState(() {
      if (!TextUtil.isEmpty(passwordStr[0]) &&
          !TextUtil.isEmpty(passwordStr[1]) &&
          !TextUtil.isEmpty(passwordStr[2])) {
        _btnStartColor = Colours.color_F68A51;
        _btnEndColor = Colours.color_EA5228;
      } else {
        _btnStartColor = Colours.color_C4C5CD;
        _btnEndColor = Colours.color_E7E8EC;
      }
    });
  }

  void _checkMessage() {
    setState(() {
      if (!TextUtil.isEmpty(passwordStr[1]) && passwordStr[1].length < 8) {
        _errorText = StringBasic.setPasswordCharacter;
      } else {
        if (passwordStr[1] != passwordStr[1]) {
          _errorText = StringBasic.setPasswordOps;
        } else {
          _errorText = null;
        }
      }

      if (TextUtil.isEmpty(passwordStr[1]) || passwordStr[1].length < 8) {
        _errorNewText = StringBasic.setPasswordCharacter;
      } else {
        _errorNewText = null;
      }
    });
  }

  void _checkContent(_ViewModel vm) {
    if (TextUtil.isEmpty(passwordStr[0]) || passwordStr[0].length < 8) {
      //原密码为空或长度小于8
      EasyLoading.showToast(StringBasic.setPasswordOldCharacter);
    } else if (TextUtil.isEmpty(passwordStr[1]) || passwordStr[1].length < 8) {
      //新密码为空或长度小于8
      EasyLoading.showToast(StringBasic.setPasswordNewCharacter);
    } else if (TextUtil.isEmpty(passwordStr[2]) || passwordStr[2].length < 8) {
      //确认密码为空或长度小于8
      EasyLoading.showToast(StringBasic.setPasswordConfirmCharacter);
    } else if (passwordStr[1] != passwordStr[2]) {
      //两次密码不相同
      EasyLoading.showToast(StringBasic.setPasswordOps);
    } else if (passwordStr[0] == passwordStr[1]) {
      //新密码和老密码一致
      EasyLoading.showToast(StringBasic.setPasswordMatch);
    } else {
      //符合要求 -> 请求更新密码接口
      vm._updatePassword(passwordStr[0], passwordStr[1], context);
    }
  }

  // ignore: non_constant_identifier_names
  Image _Images(int position) {
    return Image(
      image: index[position] ? R.image.eyes_normal() : R.image.eyes_select(),
      width: 22,
      height: 22,
    );
  }
}

class _ViewModel {
  final Function(String, String, BuildContext) _updatePassword;

  _ViewModel(this._updatePassword);

  static _ViewModel fromStore(Store<AppState> store) {
    updatePassword(
        String oldPassword, String newPassword, BuildContext context) {
      EasyLoading.show(status: 'Loading...');
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.showSuccess('Done', duration: Duration(seconds: 2));
        Future.delayed(Duration(seconds: 2))
            .then((_) => IdolRoute.logOut(context));
      }).catchError((err) => EasyLoading.showError(err.toString()));
      store.dispatch(
        UpdatePasswordAction(
          UpdatePasswordRequest(oldPassword, newPassword),
          completer,
        ),
      );
    }

    return _ViewModel(updatePassword);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel && other._updatePassword == _updatePassword;
  }

  @override
  int get hashCode => _updatePassword.hashCode;
}
