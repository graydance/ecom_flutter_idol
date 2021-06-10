import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/utils/global.dart';
import 'package:redux/redux.dart';

import 'package:idol/conf.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/widgets/dialog_welcome.dart';

/// 白名单用户注册
class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpSignInArguments _signUpSignInArguments;
  bool _setPassword = true;
  bool _passwordVisible = false;
  String _password;
  String _userName;
  String _error = '';
  TextEditingController _controller = TextEditingController();

  String get _errorMessage => _setPassword
      ? 'Make sure it\'s at least 8 characters'
      : 'At least 5 characters, only a~z, 0~9, _, . are available.';

  @override
  void initState() {
    super.initState();
    _signUpSignInArguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .signUpSignInArguments;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 35, right: 35),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: R.image.bg_login_signup(), fit: BoxFit.cover),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                              Text(
                                _setPassword
                                    ? 'SET YOUR PASSWORD'
                                    : 'SET YOUR USERNAME',
                                style: TextStyle(
                                    color: Colours.white, fontSize: 26),
                              ),
                              SizedBox(
                                height: 70,
                              ),
                              Text(
                                _signUpSignInArguments.email,
                                style: TextStyle(
                                    fontSize: 20, color: Colours.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _error = _validate(value, _setPassword)
                                        ? ''
                                        : _errorMessage;
                                  });
                                },
                                autofocus: true,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colours.white, fontSize: 18),
                                controller: _controller,
                                obscureText: _setPassword && !_passwordVisible,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colours.transparent,
                                  prefix: _setPassword
                                      ? SizedBox(
                                          width: 50,
                                        )
                                      : null,
                                  suffixIcon: _setPassword
                                      ? GestureDetector(
                                          child: Image(
                                            image: _passwordVisible
                                                ? R.image.eyes_visibility()
                                                : R.image.eyes_visibility_off(),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        )
                                      : null,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colours.color_white60),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colours.color_white60),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colours.color_white60),
                                  ),
                                  hintText:
                                      _setPassword ? 'Password' : 'Username',
                                  hintStyle: TextStyle(
                                    color: Colours.color_white60,
                                  ),
                                ),
                              ),
                              if (_error.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _error,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  bool enable =
                                      _validate(_controller.text, _setPassword);
                                  if (!enable) {
                                    EasyLoading.showError(_errorMessage);
                                    return;
                                  }
                                  if (_setPassword) {
                                    _password = _controller.text.trim();

                                    setState(() {
                                      _controller.text = '';
                                      _setPassword = false;
                                    });
                                  } else {
                                    _userName =
                                        _controller.text.trim().toLowerCase();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    // sign up
                                    final comleter = Completer();
                                    comleter.future
                                        .then(
                                            (user) => _showWelcomeDialog(user))
                                        .catchError((error) =>
                                            EasyLoading.showToast(
                                                error.toString()));

                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SignUpAction(
                                            SignUpRequest(
                                                _signUpSignInArguments.email,
                                                _password,
                                                _userName),
                                            comleter));
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 60, right: 60, top: 40),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colours.color_white40,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    border: Border.all(
                                        color: Colours.color_white40),
                                  ),
                                  child: Text(
                                    _setPassword ? 'NEXT' : 'SIGN UP',
                                    style: TextStyle(
                                        color: Colours.white, fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                  bottom: 20,
                                ),
                                child: Visibility(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            'By signing up, you acknowledge that you agree to our\n',
                                        style: TextStyle(
                                          color: Colours.color_white60,
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                          text: 'Terms & Conditions,',
                                          style: TextStyle(
                                            color: Colours.color_white60,
                                            fontSize: 10,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // link Terms & Conditions
                                              IdolRoute.startInnerWebView(
                                                  context,
                                                  InnerWebViewArguments(
                                                      'Terms & Conditions',
                                                      termsConditionsUri));
                                            }),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                          text: 'Privacy Policy,',
                                          style: TextStyle(
                                            color: Colours.color_white60,
                                            fontSize: 10,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              IdolRoute.startInnerWebView(
                                                  context,
                                                  InnerWebViewArguments(
                                                      'Privacy Policy',
                                                      privacyPolicyUri));
                                            }),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                          text: 'Cookie Policy.',
                                          style: TextStyle(
                                            color: Colours.color_white60,
                                            fontSize: 10,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              IdolRoute.startInnerWebView(
                                                  context,
                                                  InnerWebViewArguments(
                                                      'Cookie Policy',
                                                      cookiePolicyUri));
                                            }),
                                    ]),
                                  ),
                                  visible: !_setPassword,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (Navigator.of(context).canPop())
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SafeArea(
                      child: SizedBox(
                        width: 44,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Image(
                            image: R.image.arrow_left(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showWelcomeDialog(User signUpUser) async {
    return showDialog(
      context: context,
      builder: (context) {
        return WelcomeDialog(
          onClose: () {
            StoreProvider.of<AppState>(context)
                .dispatch(SignUpSuccessAction(signUpUser));
          },
        );
      },
      barrierDismissible: false,
    );
  }

  bool _validate(String text, bool isPassword) {
    return isPassword ? validatePassowrd(text) : validateUserName(text);
  }
}

class _ViewModel {
  final SignUpState _signUpState;
  final Future<User> Function(String email, String password, String username)
      _signUp;

  _ViewModel(this._signUpState, this._signUp);

  static _ViewModel fromStore(Store<AppState> store) {
    Future<User> _signUp(String email, String password, String username) {
      final comleter = Completer();
      store.dispatch(
          SignUpAction(SignUpRequest(email, password, username), comleter));
      return comleter.future;
    }

    return _ViewModel(store.state.signUpState, _signUp);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _signUpState == other._signUpState &&
          _signUp == other._signUp;

  @override
  int get hashCode => _signUpState.hashCode ^ _signUp.hashCode;
}
