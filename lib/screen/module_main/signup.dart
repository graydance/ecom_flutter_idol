import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idol/conf.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// 白名单用户注册
class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpSignInArguments _signUpSignInArguments;
  bool _enable = false;
  bool _setPassword = true;
  bool _passwordVisible = false;
  String _password;
  String _userName;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signUpSignInArguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .signUpSignInArguments;
    _controller.addListener(() {
      setState(() {
        if (_setPassword) {
          _enable = _controller.text.trim().length >= 8;
        } else {
          _enable = _controller.text.trim().length >= 5;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: R.image.bg_login_signup(), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _setPassword
                                ? 'SET YOUR PASSWORD'
                                : 'SET YOUR USERNAME',
                            style:
                                TextStyle(color: Colours.white, fontSize: 26),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Text(
                            _signUpSignInArguments.email,
                            style:
                                TextStyle(fontSize: 20, color: Colours.white),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colours.white, fontSize: 18),
                            controller: _controller,
                            obscureText: _setPassword && !_passwordVisible,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(_setPassword
                                  ? r"[a-zA-Z0-9_.]+|\s+"
                                  : r"[a-z0-9_.]+|\s+")),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colours.transparent,
                              suffixIcon: _setPassword
                                  ? GestureDetector(
                                      child: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 22,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
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
                              hintText: _setPassword ? 'Password' : 'Username',
                              hintStyle:
                                  TextStyle(color: Colours.color_white60),
                              counterText:
                                  'Make sure it\'s at least ${_setPassword ? 8 : 5} characters',
                              counterStyle: TextStyle(
                                  fontSize: 12, color: Colours.color_white60),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_enable && _setPassword) {
                                _password = _controller.text.trim();
                                setState(() {
                                  _controller.text = '';
                                  _setPassword = false;
                                });
                              } else if (_enable && !_setPassword) {
                                _userName = _controller.text.trim();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // sign up
                                vm._signUp(_signUpSignInArguments.email,
                                    _password, _userName);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(left: 60, right: 60, top: 40),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: _enable
                                    ? Colours.color_white40
                                    : Colours.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                border:
                                    Border.all(color: Colours.color_white40),
                              ),
                              child: Text(
                                _setPassword ? 'NEXT' : 'SIGN UP',
                                style: TextStyle(
                                    color: Colours.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
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
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // link Terms & Conditions
                                IdolRoute.startInnerWebView(
                                    context,
                                    InnerWebViewArguments('Terms & Conditions',
                                        termsConditionsUri));
                              }),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: 'Privacy Policy,',
                            style: TextStyle(
                              color: Colours.color_white60,
                              fontSize: 10,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                IdolRoute.startInnerWebView(
                                    context,
                                    InnerWebViewArguments(
                                        'Privacy Policy', privacyPolicyUri));
                              }),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: 'Cookie Policy.',
                            style: TextStyle(
                              color: Colours.color_white60,
                              fontSize: 10,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                IdolRoute.startInnerWebView(
                                    context,
                                    InnerWebViewArguments(
                                        'Cookie Policy', cookiePolicyUri));
                              }),
                      ]),
                    ),
                    visible: !_setPassword,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final SignUpState _signUpState;
  final Function(String email, String password, String username) _signUp;

  _ViewModel(this._signUpState, this._signUp);

  static _ViewModel fromStore(Store<AppState> store) {
    void _signUp(String email, String password, String username) {
      store.dispatch(SignUpAction(SignUpRequest(email, password, username)));
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
