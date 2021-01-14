import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/login.dart';
import 'package:idol/r.g.dart';
import 'package:idol/router.dart';
import 'package:redux/redux.dart';
import 'package:idol/store/actions/actions_main.dart';
import 'package:idol/utils/keystore.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (_isUserLoggedIn()) {
      // auto login
      debugPrint(
          'User is logged in. will running auto login.');
      String email = SpUtil.getString(KeyStore.EMAIL);
      String password = SpUtil.getString(KeyStore.PASSWORD);
      StoreProvider.of<AppState>(context)
          .dispatch(LoginAction(LoginRequest(email, password)));
    } else {
      debugPrint(
          'User is not logged in. will jump to Sign Up/Sign In.');
      // sing up/sign in.
      Future.delayed(Duration(milliseconds: 3000),
          () => {IdolRoute.startSignUpOrSignIn(context)});
    }
    super.initState();
  }

  bool _isUserLoggedIn() {
    return !TextUtil.isEmpty(SpUtil.getString(KeyStore.TOKEN));
  }

  void _onLoginStateChange(LoginState state) {
    if (state is LoginSuccess) {
      Future.delayed(
          Duration(milliseconds: 3000), () => {IdolRoute.startHome(context)});
    } else if (state is LoginFailure) {
      Future.delayed(Duration(milliseconds: 3000),
          () => {IdolRoute.startSignUpOrSignIn(context)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        onWillChange: (oldVM, newVM) =>
            {_onLoginStateChange(newVM == null ? oldVM.loginState : newVM)},
        converter: _ViewModel.fromStore,
        builder: (context, vm) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: R.image.bg_splash_jpg(), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final LoginState loginState;

  _ViewModel(this.loginState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.loginState);
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
