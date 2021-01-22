import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/withdraw_verify.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/arguments.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/widgets.dart';
import 'package:redux/redux.dart';

/// 提现信息填写页
class WithdrawScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State {
  _WithdrawScreenState();

  WithdrawInfo _withdrawInfo;
  TextEditingController _accountController;
  TextEditingController _confirmAccountController;
  TextEditingController _amountController;
  String _withdrawTypeId;
  String _withdrawTypeName = 'Select the payment';
  int _serviceCharge = 0;
  int _paymentTypeIndex = -1;
  FocusNode _accountFocusNode = FocusNode(debugLabel: 'accountFocusNode');
  FocusNode _confirmAccountFocusNode =
      FocusNode(debugLabel: 'confirmAccountFocusNode');
  FocusNode _amountFocusNode = FocusNode(debugLabel: 'amountFocusNode');
  String _accountTips = '';
  String _confirmAccountTips = '';
  String _amountTips = '';
  IdolButtonStatus withdrawButtonStatus = IdolButtonStatus.normal;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _accountController.addListener(() => _changeWithdrawButtonStatus());
    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        bool isEmail = RegexUtil.isEmail(_accountController.text);
        setState(() {
          _accountTips = isEmail ? '' : 'Account is not a valid email address';
        });
      }
    });

    _confirmAccountController = TextEditingController();
    _confirmAccountController.addListener(() => _changeWithdrawButtonStatus());
    _confirmAccountFocusNode.addListener(() {
      if (!_confirmAccountFocusNode.hasFocus) {
        debugPrint('Confirm Account TextField lose focus.');
        setState(() {
          _confirmAccountTips = _accountController.text.isNotEmpty &&
                  _confirmAccountController.text.isNotEmpty &&
                  _confirmAccountController.text == _accountController.text
              ? ''
              : 'Account not match';
        });
      }
    });

    _amountController = TextEditingController();
    _amountController.addListener(() => _changeWithdrawButtonStatus());
    _amountFocusNode.addListener(() {
      String withdrawalAmountString = _amountController.text;
      setState(() {
        if (withdrawalAmountString.isNotEmpty) {
          if (withdrawalAmountString.contains('.')) {
            double withdrawalAmountDouble =
                double.tryParse(withdrawalAmountString);
            if (withdrawalAmountDouble < 100) {
              _amountTips =
                  'The minimum withdrawal amount is ${Global.getUser(context).monetaryUnit}100';
            } else {
              // 提现金额+手续费大于 可提现余额，则提示错误信息。
              _amountTips = (withdrawalAmountDouble + _serviceCharge) * 100 >
                      _withdrawInfo.withdraw
                  ? ''
                  : 'Not sufficient funds';
            }
          } else {
            int withdrawalAmountInt = int.tryParse(withdrawalAmountString);
            if (withdrawalAmountInt < 100) {
              _amountTips =
                  'The minimum withdrawal amount is ${Global.getUser(context).monetaryUnit}100';
            } else {
              // 提现金额+手续费大于 可提现余额，则提示错误信息。
              _amountTips = (withdrawalAmountInt + _serviceCharge) * 100 >
                      _withdrawInfo.withdraw
                  ? ''
                  : 'Not sufficient funds';
            }
          }
        } else {
          _amountTips = '';
        }
      });
    });
  }

  void _changeWithdrawButtonStatus() {
    var enable = _withdrawTypeId.isNotEmpty &&
        _accountController.text.isNotEmpty &&
        _confirmAccountController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _accountController.text == _confirmAccountController.text &&
        RegexUtil.isEmail(_accountController.text) &&
        RegexUtil.isEmail(_confirmAccountController.text) &&
        (_amountController.text.contains(".")
                ? double.tryParse(_amountController.text)
                : int.tryParse(_amountController.text)) >=
            100;
    setState(() {
      withdrawButtonStatus =
          enable ? IdolButtonStatus.enable : IdolButtonStatus.disable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdolUI.appBar(context, 'Withdraw'),
      body: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        distinct: true,
        builder: (context, vm) {
          _withdrawInfo = vm._withdrawInfo;
          return _buildWidget(vm);
        },
      ),
    );
  }

  Widget _buildWidget(_ViewModel vm){
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 40),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Text(
                    'Available',
                    style: TextStyle(
                        fontSize: 16, color: Colours.color_A9A9A9),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(Global.getUser(context).monetaryUnit +
                TextUtil.formatDoubleComma3(
                    vm._withdrawInfo.withdraw / 100),
                style: TextStyle(
                    fontSize: 35,
                    color: Colours.color_EA5228,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              //color: Colours.color_F4F5F6,
              decoration: BoxDecoration(
                color: Colours.color_F4F5F6,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              margin: EdgeInsets.only(top: 35),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showPaymentMethodsDialog(
                        vm._withdrawInfo.withdrawType),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 25, right: 15, bottom: 0),
                      child: Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment',
                            style: TextStyle(
                              color: Colours.color_3B3F42,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _withdrawTypeName,
                                style: TextStyle(
                                    color: Colours.color_B1B2B3,
                                    fontSize: 14),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colours.color_35444648,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colours.color_E7E8EC,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, top: 15, right: 15, bottom: 5),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                            color: Colours.color_3B3F42,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _accountController,
                            focusNode: _accountFocusNode,
                            style: TextStyle(
                                color: Colours.color_B1B2B3,
                                fontSize: 14),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            //maxLength: 254,
                            keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 1.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colours.color_E7E8EC,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        _accountTips,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colours.color_ED3544,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, top: 6, right: 15, bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confirm Account',
                          style: TextStyle(
                            color: Colours.color_3B3F42,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _confirmAccountController,
                            textAlign: TextAlign.end,
                            focusNode: _confirmAccountFocusNode,
                            style: TextStyle(
                                color: Colours.color_B1B2B3,
                                fontSize: 14),
                            maxLines: 1,
                            //maxLength: 254,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 1.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colours.color_E7E8EC,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        _confirmAccountTips,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colours.color_ED3544,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, top: 6, right: 15, bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount(${Global.getUser(context).monetaryUnit})',
                          style: TextStyle(
                            color: Colours.color_3B3F42,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            style: TextStyle(
                                color: Colours.color_B1B2B3,
                                fontSize: 14),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 1.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colours.color_E7E8EC,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          _amountTips,
                          style: TextStyle(
                              color: Colours.color_B1B2B3, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Notice',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colours.color_3B3F42),
                          ),
                          SizedBox(
                            height: 7,
                            width: double.infinity,
                          ),
                          Text(
                            'We will process the withdraw request within 2 working days.\nThe minimum withdrawal amount is ${Global.getUser(context).monetaryUnit}100',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colours.color_B1B2B3,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        left: 24, top: 26, right: 24, bottom: 26),
                    child: IdolButton(
                      'Withdraw',
                      status: withdrawButtonStatus,
                      listener: (status) => {
                        if (status == IdolButtonStatus.enable)
                          {_withdraw(vm)}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodsDialog(List<WithdrawType> withdrawTypeList) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false, // 屏蔽返回键
              child: SelectPaymentMethodsDialog(
                withdrawTypeList,
                defaultSelectedIndex: _paymentTypeIndex,
                onClose: () {
                  debugPrint('onShowPaymentMethodsDialog close >>>');
                  IdolRoute.pop(context);
                },
                onItemSelected: (index, withdrawType) {
                  IdolRoute.pop(context);
                  if (withdrawType != null) {
                    setState(() {
                      _paymentTypeIndex = index;
                      _withdrawTypeName = withdrawType.payName;
                      _withdrawTypeId = withdrawType.id;
                      _serviceCharge = withdrawType.serviceFee;
                    });
                  }
                },
              ),
            ));
  }

  void _withdraw(_ViewModel vm) {
    int amount = 0;
    if (_amountController.text.contains(".")) {
      String amountStr =
          double.tryParse(_amountController.text).toStringAsFixed(2);
      amount = (double.tryParse(amountStr) * 100).toInt();
    } else {
      amount = int.tryParse(_amountController.text) * 100;
    }

    // 缓存下级页面所需参数信息到AppStore
    vm._updateArguments(_withdrawTypeId, _accountController.text, amount);
    IdolRoute.startDashboardWithdrawVerifyPassword(context).then((value) {
      if (value != null) {
        IdolRoute.popAndResult(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountFocusNode.unfocus();
    _confirmAccountFocusNode.unfocus();
    _amountFocusNode.unfocus();
  }
}

class _ViewModel {
  final WithdrawInfo _withdrawInfo;
  final Function(String, String, int) _updateArguments;

  _ViewModel(this._withdrawInfo, this._updateArguments);

  static _ViewModel fromStore(Store<AppState> store) {
    _updateArguments(String withdrawTypeId, String account, int amount) {
      store.dispatch(UpdateArgumentsAction<WithdrawVerifyArguments>(
          WithdrawVerifyArguments(
              withdrawTypeId: withdrawTypeId,
              account: account,
              amount: amount)));
    }

    WithdrawInfo withdrawInfo = store.state.withdrawInfoState
            is WithdrawInfoSuccess
        ? (store.state.withdrawInfoState as WithdrawInfoSuccess).withdrawInfo
        : WithdrawInfo();
    return _ViewModel(withdrawInfo, _updateArguments);
  }
}