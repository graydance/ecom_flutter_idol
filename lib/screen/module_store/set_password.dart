import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/conf.dart';
import 'package:idol/models/models.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/ui.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class SetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  GlobalKey<IdolButtonState> _buttonGlobalKey = GlobalKey();
  List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<bool> _passwordVisibleTags = [false, false, false];
  List<String> _hintTexts = [
    'Enter your current password',
    'Must be at least 8 characters',
    'Confirm your new password'
  ];

  IdolButtonStatus _buttonStatus = IdolButtonStatus.disable;
  List<bool> _validTags = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onStateChanged(newVM._updatePasswordState);
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: IdolUI.appBar(context, 'Set Password', centerTitle: true),
          body: _buildBodyWidget(vm),
        );
      },
    );
  }

  void _onStateChanged(UpdatePasswordState state) async {
    if (state is UpdatePasswordInitial || state is UpdatePasswordLoading) {
      EasyLoading.show(status: 'Loading...');
    } else if (state is UpdatePasswordSuccess) {
      EasyLoading.showSuccess('Update password success, please log in again');
      IdolRoute.startSignIn(
          context, SignUpSignInArguments(Global.getUser(context).email));
    } else if (state is UpdatePasswordFailure) {
      EasyLoading.showError(state.message);
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        _validTags[i] = _controllers[i].text.trim().length >= 8;
        _updateButtonStatus();
      });
    }
  }

  void _updateButtonStatus() {
    if (_controllers[1].text.trim().length > 0 ||
        _controllers[1].text.trim().length > 0 ||
        _controllers[1].text.trim().length > 0) {
      _buttonStatus = IdolButtonStatus.normal;
    } else {
      _buttonStatus = IdolButtonStatus.disable;
    }
    if (_validTags[0] &&
        _validTags[1] &&
        _validTags[2] &&
        (_controllers[1].text.trim() == _controllers[2].text.trim())) {
      _buttonStatus = IdolButtonStatus.enable;
    }
    _buttonGlobalKey.currentState.updateButtonStatus(_buttonStatus);
  }

  void _showDisableUpdateTips() {
    String oldPwd = _controllers[0].text.trim();
    String newPwd = _controllers[1].text.trim();
    String confirmPwd = _controllers[2].text.trim();
    if (oldPwd.length < 8) {
      EasyLoading.showToast('Old password must be at least 8 characters.');
    }
    if (newPwd.length < 8) {
      EasyLoading.showToast('New password must be at least 8 characters.');
    }
    if (confirmPwd.length < 8 || confirmPwd != newPwd) {
      EasyLoading.showToast('The new and confirmed password don\'t match.');
    }
  }

  Widget _buildBodyWidget(_ViewModel vm) {
    return SingleChildScrollView(
      child: Container(
        color: Colours.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Current password',
              style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
            ),
            _createTextField(0),
            Text(
              'New password',
              style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
            ),
            _createTextField(1),
            Text(
              'Confirm password',
              style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
            ),
            _createTextField(2),
            Container(
              child: IdolButton(
                'Update',
                status: _buttonStatus,
                listener: (status) {
                  if (status == IdolButtonStatus.enable) {
                    // update password
                    vm._updatePassword(_controllers[0].text.trim(),
                        _controllers[1].text.trim());
                  } else if (status == IdolButtonStatus.normal) {
                    _showDisableUpdateTips();
                  }
                },
              ),
              margin: EdgeInsets.only(left: 27, right: 27, top: 75, bottom: 8),
            ),
            TextButton(
              onPressed: () {
                Global.launchWhatsApp();
              },
              child: Text(
                'Forgot password',
                style: TextStyle(
                    color: Colours.color_48B6EF,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _createTextField(int index) {
    return TextField(
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colours.white, fontSize: 14),
      controller: _controllers[index],
      obscureText: !_passwordVisibleTags[index],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colours.transparent,
        suffixIcon: GestureDetector(
          child: Icon(
            _passwordVisibleTags[index]
                ? Icons.visibility
                : Icons.visibility_off,
            size: 22,
          ),
          onTap: () {
            setState(() {
              _passwordVisibleTags[index] = !_passwordVisibleTags[index];
            });
          },
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colours.color_E7E8EC),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colours.color_E7E8EC),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colours.color_E7E8EC),
        ),
        hintText: _hintTexts[index],
        hintStyle: TextStyle(color: Colours.color_979AA9, fontSize: 14),
      ),
    );
  }
}

class _ViewModel {
  final UpdatePasswordState _updatePasswordState;
  final Function(String oldPwd, String newPwd) _updatePassword;

  _ViewModel(this._updatePasswordState, this._updatePassword);

  static _ViewModel fromStore(Store<AppState> store) {
    void _updatePassword(String oldPwd, String newPwd) {}
    return _ViewModel(store.state.updatePasswordState, _updatePassword);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _updatePasswordState == other._updatePasswordState &&
          _updatePassword == other._updatePassword;

  @override
  int get hashCode => _updatePasswordState.hashCode ^ _updatePassword.hashCode;
}
