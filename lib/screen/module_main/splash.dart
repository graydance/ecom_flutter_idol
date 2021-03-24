import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/utils/keystore.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = new FlutterSecureStorage();

  initState() {
    checkSignInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: _ViewModel.fromStore,
          onInit: (store) {
            store.dispatch(LoadConfigurationAction());
          },
          builder: (context, vm) {
            return Container(
              decoration: BoxDecoration(
                color: Colours.transparent,
                image: DecorationImage(
                    image: R.image.launch_background_webp(), fit: BoxFit.cover),
              ),
              child: Center(
                child: ClipOval(
                  child: Image(
                    image: R.image.ic_circle_logo(),
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            );
          }),
    );
  }

  void checkSignInStatus() async {
    String isFirstRun;
    String signedIn;
    String email;
    String password;
    try {
      isFirstRun = await _storage.read(key: KeyStore.IS_FIRST_RUN);
      signedIn = await _storage.read(key: KeyStore.TOKEN);
      email = await _storage.read(key: KeyStore.EMAIL);
      password = await _storage.read(key: KeyStore.PASSWORD);
    } catch (ex) {}
    if (signedIn != null && signedIn.isNotEmpty) {
      // auto login
      debugPrint('User is logged in. will running auto login.');
      Future.delayed(Duration(seconds: 2), () {
        StoreProvider.of<AppState>(context)
            .dispatch(SignInAction(SignUpSignInRequest(email, password)));
      });
    } else {
      debugPrint('User is not logged in. will jump to Sign Up/Sign In.');
      // sing up/sign in.
      Future.delayed(Duration(seconds: 2), () {
        isFirstRun != null &&
                bool.fromEnvironment(isFirstRun, defaultValue: true)
            ? IdolRoute.startGuide(context)
            : IdolRoute.startValidateEmail(context);
      });
    }
  }
}

class _ViewModel {
  final SignInState loginState;

  _ViewModel(this.loginState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.signInState);
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
