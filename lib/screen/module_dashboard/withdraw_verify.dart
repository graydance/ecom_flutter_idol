import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/ui.dart';
import 'package:redux/redux.dart';

/// 验证登录密码
class VerifyPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPasswordScreen> {
  bool _passwordVisible = false;
  IdolButtonStatus _buttonStatus = IdolButtonStatus.disable;
  TextEditingController _controller;
  WithdrawVerifyArguments arguments;

  @override
  void initState() {
    super.initState();
    debugPrint('arguments: $arguments');
    _controller = TextEditingController();
    _controller.addListener(() {
      if (arguments.withdrawTypeId.isEmpty ||
          arguments.account.isEmpty ||
          arguments.amount == 0) {
        // 如果参数非法，则禁止后续操作
        _buttonStatus = IdolButtonStatus.disable;
        return;
      }
      debugPrint('verify password => ${_controller.text}');
      setState(() {
        if (_controller.text.length == 0) {
          _buttonStatus = IdolButtonStatus.disable;
        } else if (_controller.text.length > 0 && _controller.text.length < 6) {
          _buttonStatus = IdolButtonStatus.disable;
        } else {
          _buttonStatus = IdolButtonStatus.enable;
        }
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
      distinct: true,
      onInit: (store) {
        arguments = store.state.withdrawVerifyArguments;
        debugPrint('onInit >>> $arguments');
      },
      onWillChange: (oldVM, newVM) {
        debugPrint('onWillChange >>> $oldVM, $newVM');
        // 处理网络请求返回的结果
        _onWithdrawStateChanged(
            newVM == null ? oldVM.withdrawState : newVM.withdrawState);
      },
      builder: (context, vm) => _buildWidget(vm),
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    return Scaffold(
      appBar: IdolUI.appBar(context, 'Enter your password'),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Enter your password',
                      style:
                          TextStyle(color: Colours.color_3B3F42, fontSize: 14)),
                )),
            TextField(
              controller: _controller,
              obscureText: !_passwordVisible,
              cursorColor: Colours.color_F68A51,
              maxLines: 1,
              style: TextStyle(color: Colours.color_3B3F42, fontSize: 14),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colours.color_3B3F42,
                    style: BorderStyle.solid,
                  ),
                ),
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colours.color_B1B2B3, fontSize: 14),
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colours.color_3B3F42,
                      size: 20,
                    ),
                    onPressed: _changePasswordVisibility),
              ),
            ),
            SizedBox(
              height: 170,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: IdolButton(
                'Confirm',
                status: _buttonStatus,
                listener: (status) {
                  if (status == IdolButtonStatus.enable) {
                    // 请求提现接口
                    vm.withdraw(_controller.text);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Forgot password?',
                style: TextStyle(fontSize: 14, color: Colours.color_3B3F42),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onWithdrawStateChanged(WithdrawState state) {
    if (state is WithdrawLoading) {
      EasyLoading.show(status: 'Submitting...');
    } else if (state is WithdrawSuccess) {
      EasyLoading.dismiss();
      IdolRoute.startDashboardWithdrawResult(
              context, WithdrawResultArguments(withdrawStatus: 0))
          .then((value) => IdolRoute.popAndExit(context));
    } else if (state is WithdrawFailure) {
      EasyLoading.showToast(state.message);
    }
  }
}

class _ViewModel {
  final WithdrawState withdrawState;
  final Function withdraw;
  _ViewModel(this.withdrawState, this.withdraw);

  static _ViewModel fromStore(Store<AppState> store) {
    _withdraw(String password) {
      store.dispatch(WithdrawAction(WithdrawRequest(
          store.state.withdrawVerifyArguments.withdrawTypeId,
          store.state.withdrawVerifyArguments.account,
          store.state.withdrawVerifyArguments.amount,
          password)));
    }

    return _ViewModel(store.state.withdrawState, _withdraw);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          withdrawState == other.withdrawState;

  @override
  int get hashCode => withdrawState.hashCode;
}
