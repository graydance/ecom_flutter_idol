import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/dialog.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/models.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/r.g.dart';

class BalanceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colours.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colours.color_444648,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      extendBodyBehindAppBar: true,
      body: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        onInit: (store) {
          StoreProvider.of<AppState>(context)
              .dispatch(WithdrawInfoAction(BaseRequestImpl()));
        },
        distinct: true,
        builder: (context, vm) {
          return _buildWidget(vm);
        },
      ),
    );
  }

  Widget _buildWidget(_ViewModel _viewModel){
    WithdrawInfo withdrawInfo;
    if (_viewModel.withdrawInfoState is WithdrawInfoSuccess) {
      withdrawInfo =
          (_viewModel.withdrawInfoState as WithdrawInfoSuccess).withdrawInfo;
    }
    return Container(
      color: Colours.color_F8F8F8,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: R.image.bg_withdraw_webp(),
                fit: BoxFit.cover,
              ),
            ),
            height: 220,
          ),
          Container(
            //height: 220,
            margin: EdgeInsets.only(top: 120, left: 15, right: 15),
            padding:
            EdgeInsets.only(left: 24, right: 24, top: 33, bottom: 33),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  withdrawInfo == null
                      ? '-'
                      : _viewModel.user.monetaryUnit +
                      TextUtil.formatDoubleComma3(
                          withdrawInfo.availableBalance / 100),
                  style: TextStyle(
                      color: Colours.color_EA5228,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Balance(' +
                          (withdrawInfo == null
                              ? "\$"
                              : _viewModel.user.monetaryUnit) +
                          ')',
                      style: TextStyle(
                          color: Colours.color_5028292A,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: _tips(
                          'Money you\'ve earned but have yet to withdraw.'),
                      child: Icon(
                        Icons.info,
                        size: 15,
                        color: Colours.color_40A2A2A2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available(' +
                                    (withdrawInfo == null
                                        ? "\$"
                                        : _viewModel.user.monetaryUnit) +
                                    ')',
                                style: TextStyle(
                                    color: Colours.color_A9A9A9,
                                    fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: _tips(
                                    'Money you\'ve earned and yuo can withdraw now.'),
                                child: Icon(
                                  Icons.info,
                                  size: 15,
                                  color: Colours.color_40A2A2A2,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 7),
                            child: Text(
                              withdrawInfo == null
                                  ? '-'
                                  : _viewModel.user.monetaryUnit +
                                  TextUtil.formatDoubleComma3(
                                      withdrawInfo.withdraw / 100),
                              style: TextStyle(
                                  color: Colours.color_28292A,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Unavailable(' +
                                        (withdrawInfo == null
                                            ? "\$"
                                            : _viewModel.user.monetaryUnit) +
                                        ')',
                                    style: TextStyle(
                                        color: Colours.color_A9A9A9,
                                        fontSize: 14),
                                  ),
                                  GestureDetector(
                                    onTap: _tips(
                                        'Money you\'ve earned but you can\'t withdraw now.\nThe money will available after the sale confirmed.'),
                                    child: Icon(
                                      Icons.info,
                                      size: 15,
                                      color: Colours.color_40A2A2A2,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 7),
                                child: Text(
                                  withdrawInfo == null
                                      ? '-'
                                      : _viewModel.user.monetaryUnit +
                                      TextUtil.formatDoubleComma3(
                                          withdrawInfo.freeze / 100),
                                  style: TextStyle(
                                      color: Colours.color_28292A,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 40, right: 40, bottom: 180),
            child: IdolButton(
              'Withdraw',
              status: withdrawInfo == null
                  ? IdolButtonStatus.normal
                  : IdolButtonStatus.enable,
              listener: (status) => _withdraw(status),
            ),
          ),
        ],
      ),
    );
  }

  _withdraw(IdolButtonStatus status) {
    if (status == IdolButtonStatus.enable) {
      String paymentAccount = SpUtil.getString(KeyStore.PAYMENT_ACCOUNT);
      if (paymentAccount.isEmpty) {
        _showNeedSetWithdrawAccountDialog(context);
      } else {
        IdolRoute.startDashboardWithdraw(context)
            .then((value){
              if(value != null){
                // 通知上层跳转到选品页
                IdolRoute.popAndExit(context);
              }
        });
      }
    }
  }

  /// 临时方案
  _tips(String tips) {
    // TODO 展示PopupWindow
  }

  /// 未设置提现账户弹窗
  _showNeedSetWithdrawAccountDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false, // 屏蔽返回键
              child: IdolMessageDialog(
                'Please confirm your email address\n for password security and to\n receive withdrawal updates.',
                onClose: () => {IdolRoute.pop(context)},
                onTap: () {
                  IdolRoute.pop(context);
                  IdolRoute.startDashboardWithdraw(context).then((value) {
                    IdolRoute.pop(context);
                  });
                },
              ),
            ));
  }
}

class _ViewModel {
  final WithdrawInfoState withdrawInfoState;
  final User user;

  _ViewModel(this.withdrawInfoState, this.user);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.withdrawInfoState, (store.state.signInState as SignInSuccess).signInUser);
  }
}
