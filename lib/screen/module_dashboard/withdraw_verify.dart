import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/withdraw.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/widgets/widgets.dart';

/// 验证登录密码
class VerifyPasswordScreen extends StatefulWidget {
  final Map arguments;

  VerifyPasswordScreen(this.arguments);

  @override
  State<StatefulWidget> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPasswordScreen> {
  bool _passwordVisible = false;
  IdolButtonStatus _buttonStatus = IdolButtonStatus.normal;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      debugPrint('verify password => ${_controller.text}');
      setState(() {
        if (_controller.text.length == 0) {
          _buttonStatus = IdolButtonStatus.normal;
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
    return Scaffold(
      appBar: IdolUI.appBar(context, 'Enter your password'),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your password',
                style: TextStyle(color: Colours.color_3B3F42, fontSize: 14)),
            TextField(
              controller: _controller,
              obscureText: !_passwordVisible,
              cursorColor: Colours.color_F68A51,
              maxLines: 1,
              style: TextStyle(color: Colours.color_3B3F42, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colours.color_B1B2B3, fontSize: 14),
                suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
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
                    StoreProvider.of<AppState>(context).dispatch(WithdrawAction(
                        WithdrawRequest(
                            widget.arguments['withdrawTypeId'],
                            widget.arguments['account'],
                            widget.arguments['amount'],
                            _controller.text)));
                  }
                },
              ),
            ),
            Text(
              'Forgot password?',
              style: TextStyle(fontSize: 14, color: Colours.color_3B3F42),
            ),
          ],
        ),
      ),
    );
  }
}
