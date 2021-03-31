import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/r.g.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
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
  bool _enableSignIn = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _signUpSignInArguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .signUpSignInArguments;
    _passwordController = TextEditingController();
    _passwordController.addListener(() {
      setState(() {
        _enableSignIn = validatePassowrd(_passwordController.text);
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
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: R.image.bg_login_signup(), fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: _signInWidget(vm),
              ),
            ),
          ),
        );
      },
      // ),
    );
  }

  Widget _signInWidget(_ViewModel vm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Text(
            'LOG IN',
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
            onChanged: (value) {
              setState(() {
                final msg = 'Make sure it\'s at least 8 characters';
                _error = validatePassowrd(value) ? '' : msg;
              });
            },
            autofocus: true,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colours.white, fontSize: 20),
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colours.transparent,
              prefix: SizedBox(
                width: 50,
              ),
              suffixIcon: GestureDetector(
                child: Image(
                  image: _passwordVisible
                      ? R.image.eyes_visibility()
                      : R.image.eyes_visibility_off(),
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
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(RouterPath.forgotPassword);
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
                color:
                    _enableSignIn ? Colours.color_white40 : Colours.transparent,
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
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              IdolRoute.changeAccount(context);
            },
            child: Text(
              'Change account',
              style: TextStyle(
                  color: Colours.color_white60,
                  fontSize: 12,
                  decoration: TextDecoration.underline),
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
