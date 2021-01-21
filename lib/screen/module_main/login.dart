import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/login.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/widgets/widgets.dart';

/// Sign Up/Sign In
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _passwordVisible = false;
  IdolButtonStatus _buttonStatus = IdolButtonStatus.normal;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  String _emailErrorText = '';
  String _passwordErrorText = '';
  bool fastMockFlag = SpUtil.getBool('fastMockFlag');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'gaopengfeidev@gmail.com');
    _passwordController = TextEditingController(text: 'abc123');
    _emailController.addListener(() {
      debugPrint('email => ${_emailController.text}');
      setState(() {
        bool isEmail = RegexUtil.isEmail(_emailController.text);
        if (isEmail) {
          _emailErrorText = '';
        } else {
          _emailErrorText = 'Please enter the correct email address!';
        }
      });
    });
    _passwordController.addListener(() {
      setState(() {
        if (_passwordController.text.length == 0) {
          _buttonStatus = IdolButtonStatus.normal;
          _passwordErrorText = '';
        } else if (_passwordController.text.length > 0 &&
            _passwordController.text.length < 6) {
          _buttonStatus = IdolButtonStatus.disable;
          _passwordErrorText = 'Password length at least 6 characters!';
        } else {
          _buttonStatus = IdolButtonStatus.enable;
          _passwordErrorText = '';
        }
      });
    });
  }

  void _changePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _clear() {
    _emailController.text = '';
    _emailController.clear();
  }

  void _onLoginStateChange(LoginState state) {
    if (state is LoginLoading) {
      EasyLoading.show(status: 'Signing in...');
    } else if (state is LoginSuccess) {
      EasyLoading.dismiss();
      IdolRoute.startHome(context);
    } else if (state is LoginFailure) {
      String errorMsg = (state).message;
      EasyLoading.showToast(errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        onWillChange: (oldVM, newVM) {
          debugPrint('oldVM：$oldVM, newVM：$newVM');
          _onLoginStateChange(
              newVM == null ? oldVM.loginState : newVM.loginState);
        },
        converter: _ViewModel.fromStore,
        builder: (context, vm) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 120, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign Up/Sign In',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _emailController,
                  //cursorColor: Colours.color_F68A51,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  //style: TextStyle(color: Colours.color_3B3F42, fontSize: 14),
                  decoration: InputDecoration(
                    focusColor: Colours.color_B1B2B3,
                    // errorText: _emailErrorText,
                    hintText: 'Please input email',
                    //hintStyle: TextStyle(color: Colours.color_B1B2B3, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colours.color_B1B2B3,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colours.color_B1B2B3,
                        ),
                        onPressed: _clear),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  //cursorColor: Colours.color_F68A51,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  //style: TextStyle(color: Colours.color_3B3F42, fontSize: 14),
                  decoration: InputDecoration(
                    focusColor: Colours.color_B1B2B3,
                    //errorText: _passwordErrorText,
                    hintText: 'Please input password',
                    //hintStyle: TextStyle(color: Colours.color_B1B2B3, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colours.color_B1B2B3,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colours.color_B1B2B3,
                        ),
                        onPressed: _changePasswordVisibility),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('FastMock：'),
                    Switch(
                        value: fastMockFlag,
                        onChanged: (flag) {
                          setState(() {
                            fastMockFlag = flag;
                          });
                          SpUtil.putBool('fastMockFlag', fastMockFlag);
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                IdolButton(
                  'Sign Up/Sign In',
                  status: _buttonStatus,
                  listener: (status) {
                    if (status == IdolButtonStatus.enable) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // 发起登录请求
                      vm._signInOrSignUp(
                          _emailController.text, _passwordController.text);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final LoginState loginState;
  final Function(String, String) _signInOrSignUp;

  _ViewModel(this.loginState, this._signInOrSignUp);

  static _ViewModel fromStore(Store<AppState> store) {
    _signInOrSignUp(String email, String password) {
      store.dispatch(LoginAction(LoginRequest(email, password)));
    }

    return _ViewModel(store.state.loginState, _signInOrSignUp);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          loginState == other.loginState;

  @override
  int get hashCode => loginState.hashCode;
}
