import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/widgets.dart';

class WithdrawResult extends StatefulWidget {
  final Map arguments;

  const WithdrawResult(this.arguments) : assert(arguments != null);

  @override
  State<StatefulWidget> createState() => _WithdrawResultState(arguments['withdrawStatus']);
}

class _WithdrawResultState extends State {
  final int withdrawStatus;

  _WithdrawResultState(this.withdrawStatus);

  @override
  void initState() {
    super.initState();
    if (withdrawStatus == 0) {
      Future.delayed(
          Duration(milliseconds: 1000), () => {_showRateDialog(context)});
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
                onRate: (rateValue) => {print('rate：'+rateValue)},
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
                image: withdrawStatus == 0
                    ? R.image.bg_withdraw_success_webp()
                    : R.image.bg_withdraw_failure_webp(),
                width: 136,
                height: 136,
              ),
              Text(
                _getResultMessageByStatus(withdrawStatus),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colours.color_3B3F42, fontSize: 16),
              ),
              SizedBox(
                height: 47,
              ),
              IdolButton(
                'Make more money',
                status: IdolButtonStatus.enable,
                enableColors: withdrawStatus == 0
                    ? [Colours.color_95EC7E, Colours.color_5CD548]
                    : [Colours.color_F17F7F, Colours.color_EA4E4E],
                linearGradientBegin: Alignment.topCenter,
                linearGradientEnd: Alignment.bottomCenter,
                listener: (status) => {
                  //
                },
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
