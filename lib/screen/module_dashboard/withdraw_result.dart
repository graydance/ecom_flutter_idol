import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/models/arguments/withdraw_result.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/widgets.dart';

class WithdrawResultScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>
      _WithdrawResultScreenState();
}

class _WithdrawResultScreenState extends State {
  WithdrawResultArguments arguments;

  _WithdrawResultScreenState();

  @override
  void initState() {
    super.initState();
    Store<AppState> store = StoreProvider.of<AppState>(context, listen: false);
    arguments = store.state.withdrawResultArguments;
    if (arguments.withdrawStatus != -1) {
      if(arguments.withdrawStatus == 0){
      Future.delayed(
          Duration(milliseconds: 1000), () => {_showRateDialog(context)});
      }
    }else{
      IdolRoute.popAndResult(context);
    }
  }

  _showRateDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false, // 屏蔽返回键
              child: RatingDialog(
                onClose: () => {IdolRoute.pop(context)},
                onRate: (rateValue) {
                  debugPrint('rate：' + rateValue);
                  if (double.tryParse(rateValue) >= 8) {
                    // TODO 跳转到应用商店进行评分
                    EasyLoading.showToast(
                        'Jump to the GooglePlay Store rating.');
                  } else {
                    EasyLoading.showToast(
                        'Thank you for your comment, we will do better.');
                  }
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IdolUI.appBar(context, 'Withdraw'),
        body: Container(
          margin: EdgeInsets.only(left: 40, top: 16, right: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: arguments.withdrawStatus == 0
                    ? R.image.bg_withdraw_success_webp()
                    : R.image.bg_withdraw_failure_webp(),
                width: 136,
                height: 136,
              ),
              Text(
                _getResultMessageByStatus(arguments.withdrawStatus),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colours.color_3B3F42, fontSize: 16),
              ),
              SizedBox(
                height: 47,
              ),
              IdolButton(
                'Make more money',
                status: IdolButtonStatus.enable,
                enableColors: arguments.withdrawStatus == 0
                    ? [Colours.color_95EC7E, Colours.color_5CD548]
                    : [Colours.color_F17F7F, Colours.color_EA4E4E],
                linearGradientBegin: Alignment.topCenter,
                linearGradientEnd: Alignment.bottomCenter,
                listener: (status) => {IdolRoute.popAndResult(context)},
              ),
            ],
          ),
        ));
  }

  String _getResultMessageByStatus(int status) {
    if (status == 0) {
      return 'Your withdrawal request has been\nsubmitted successfully!';
    } else {
      return 'Error!';
    }
  }
}
