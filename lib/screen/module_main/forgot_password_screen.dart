import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/signup_signin.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/Strings.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/dialog_reset_password.dart';
import 'package:redux/redux.dart';

import '../../router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  String email;
  ForgotPasswordScreen({this.email = 'error'});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.formStore,
        builder: (context, vm) {
          return Scaffold(
              body: Stack(
            children: [
              Container(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            StringBasic.forgotPasswordTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            StringBasic.forgotPasswordDesc,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          IdolButton(
                            StringBasic.forgotPasswordReset,
                            status: IdolButtonStatus.enable,
                            listener: (status) => {
                              //请求接口发送邮箱重置密码
                              vm._resetPassword(email, context)
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
          ));
        });
  }
}

class _ViewModel {
  final Function(String, BuildContext) _resetPassword;

  _ViewModel(this._resetPassword);

  static _ViewModel formStore(Store<AppState> store) {
    resetPassword(String email, BuildContext context) {
      EasyLoading.show(status: StringBasic.loading);
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.showSuccess(StringBasic.done,
            duration: Duration(seconds: 2));
        Future.delayed(Duration(seconds: 2))
            .then((_) => {_showConfirmDialog(context)});
      }).catchError((err) =>
          {EasyLoading.showError(err.toString()), IdolRoute.pop(context)});
      store.dispatch(ResetPasswordAction(
        ResetPasswordRequest(email),
        completer,
      ));
    }

    return _ViewModel(resetPassword);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModel && other._resetPassword == _resetPassword;
  }

  @override
  int get hashCode => _resetPassword.hashCode;

  static _showConfirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return DialogResetPassword(
            StringBasic.forgotPasswordCheckInbox,
            StringBasic.forgotPasswordResetSuccess,
            onTab: () {
              IdolRoute.pop(context);
              Navigator.of(context).pop();
            },
          );
        });
  }
}
