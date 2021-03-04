import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/utils/keystore.dart';
import 'package:redux/redux.dart';

/// 校验邮箱
class ValidateEmailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ValidateEmailScreenState();
}

class _ValidateEmailScreenState extends State<ValidateEmailScreen> {
  bool _enable = false;
  bool _finish = false;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final storage = new FlutterSecureStorage();
    storage.write(key: KeyStore.IS_FIRST_RUN, value: 'false');
    _controller.addListener(() {
      setState(() {
        _enable = RegexUtil.isEmail(_controller.text.trim());
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
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: R.image.bg_login_signup(), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    children: [
                      Image(
                        image: R.image.ic_circle_logo(),
                        width: 120,
                        height: 120,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        style: TextStyle(color: Colours.white, fontSize: 18),
                        textAlign: TextAlign.center,
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colours.transparent,
                          hintText: 'E-mail',
                          hintStyle: TextStyle(color: Colours.color_white40),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_enable) {
                            // _validateEmail
                            FocusScope.of(context).requestFocus(FocusNode());
                            vm._validateEmail(_controller.text.trim());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 10),
                          decoration: BoxDecoration(
                            color: _enable
                                ? Colours.color_white10
                                : Colours.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(color: Colours.color_white40),
                          ),
                          child: Text(
                            'LOGIN/SIGN UP',
                            style:
                                TextStyle(color: Colours.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final ValidateEmailState _validateEmailState;
  final Function(String) _validateEmail;

  _ViewModel(this._validateEmailState, this._validateEmail);

  static _ViewModel fromStore(Store<AppState> store) {
    void _validateEmail(String email) {
      store.dispatch(ValidateEmailAction(ValidateEmailRequest(email)));
    }

    return _ViewModel(store.state.validateEmailState, _validateEmail);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _validateEmailState == other._validateEmailState &&
          _validateEmail == other._validateEmail;

  @override
  int get hashCode => _validateEmailState.hashCode ^ _validateEmail.hashCode;
}
