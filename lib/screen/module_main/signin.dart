import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/r.g.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/main.dart';

/// Sign Up/Sign In
class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  SignUpSignInArguments _signUpSignInArguments;
  bool _passwordVisible = false;
  TextEditingController _passwordController;
  bool _showForgotPasswordWidget = false;
  bool _enableSignIn = false;

  @override
  void initState() {
    super.initState();
    _signUpSignInArguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .signUpSignInArguments;
    _passwordController = TextEditingController();
    _passwordController.addListener(() {
      setState(() {
        _enableSignIn = _passwordController.text != null &&
            _passwordController.text.trim().isNotEmpty;
      });
    });
  }

  void _changePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: R.image.bg_login_signup(), fit: BoxFit.cover),
            ),
            padding: EdgeInsets.only(left: 35, right: 35),
            child: _showForgotPasswordWidget
                ? _forgotPasswordWidget()
                : _signInWidget(vm),
          ),
        );
      },
      // ),
    );
  }

  Widget _signInWidget(_ViewModel vm) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'LOGIN',
                style: TextStyle(color: Colours.white, fontSize: 26),
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                _signUpSignInArguments.email,
                style: TextStyle(fontSize: 20, color: Colours.white),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colours.white, fontSize: 20),
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colours.transparent,
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 22,
                      color: Colours.color_white60,
                    ),
                    onTap: () {
                      _changePasswordVisibility();
                    },
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colours.color_white60),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours.color_white60,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours.color_white60,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours.color_white60,
                    ),
                  ),
                  counterStyle:
                      TextStyle(fontSize: 12, color: Colours.color_white10),
                  // errorText: '',
                  // // 无法确定网络错误还是服务端返回的错误信息 _errorText,
                  // errorMaxLines: 1,
                  // errorStyle:
                  //     TextStyle(color: Colours.color_ED3544, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showForgotPasswordWidget = true;
                  });
                },
                child: Text(
                  'Forgot your password',
                  style: TextStyle(
                      color: Colours.color_white60,
                      fontSize: 12,
                      decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  // sign in
                  if (_enableSignIn) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    vm._signIn(_signUpSignInArguments.email,
                        _passwordController.text.trim());
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 60,
                    right: 60,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: _enableSignIn
                        ? Colours.color_white40
                        : Colours.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    border: Border.all(color: Colours.color_white40),
                  ),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colours.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'FORGOT PASSWORD',
            style: TextStyle(color: Colours.white, fontSize: 26),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Don\'t worry, it happens to all of us.',
            style: TextStyle(color: Colours.color_white10, fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Enter your email and we\'ll send you a link to reset your password.',
            style: TextStyle(color: Colours.color_white10, fontSize: 16),
          ),
          SizedBox(
            height: 80,
          ),
          GestureDetector(
            onTap: () {
              // TODO Link WhatsApp
            },
            child: Image(
              image: R.image.ic_whatsapp(),
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final SignInState _signInState;
  final Function(String, String) _signIn;

  _ViewModel(this._signInState, this._signIn);

  static _ViewModel fromStore(Store<AppState> store) {
    _signInOrSignUp(String email, String password) {
      store.dispatch(SignInAction(SignUpSignInRequest(email, password)));
    }

    return _ViewModel(store.state.signInState, _signInOrSignUp);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _signInState == other._signInState;

  @override
  int get hashCode => _signInState.hashCode;
}
