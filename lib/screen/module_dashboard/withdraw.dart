import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/widgets.dart';

/// 提现信息填写页
class WithdrawScreen extends StatefulWidget {
  final Map arguments;

  WithdrawScreen(this.arguments);

  @override
  State<StatefulWidget> createState() =>
      _WithdrawScreenState(arguments['availableAmount']);
}

class _WithdrawScreenState extends State {
  final int availableAmount;

  _WithdrawScreenState(this.availableAmount);

  TextEditingController accountController;
  TextEditingController reAccountController;
  TextEditingController amountController;
  String withdrawTypeId, account, password;
  int amount = 0;
  String accountErrorText = '';
  String confirmAccountErrorText = '';
  String amountTips = 'Transfer fees will charged by PayPal \$0';

  @override
  void initState() {
    super.initState();
    accountController = TextEditingController();
    accountController.addListener(() {
      bool isEmail = RegexUtil.isEmail(accountController.text);
      accountErrorText = isEmail ? '' : 'Account is not a valid email address';
    });

    reAccountController = TextEditingController();
    reAccountController.addListener(() {
      bool isEmail = RegexUtil.isEmail(reAccountController.text);
      accountErrorText = isEmail &&
              !TextUtil.isEmpty(accountController.text) &&
              !TextUtil.isEmpty(reAccountController.text) &&
              reAccountController.text == accountController.text
          ? ''
          : 'Account not match';
    });

    amountController = TextEditingController();
    amountController.addListener(() {
      String withdrawalAmountString = amountController.text;
      if (!TextUtil.isEmpty(withdrawalAmountString)) {
        if (withdrawalAmountString.contains('.')) {
          double withdrawalAmountDouble =
              double.tryParse(withdrawalAmountString);
          if (withdrawalAmountDouble < 100) {
            amountTips = 'The minimum withdrawal amount is \$100';
          } else {
            // 提现金额+手续费大于 可提现余额，则提示错误信息。
          }
        } else {
          int withdrawalAmountInt = int.tryParse(withdrawalAmountString);
          if (withdrawalAmountInt < 100) {
            amountTips = 'The minimum withdrawal amount is \$100';
          } else {
            // 提现金额+手续费大于 可提现余额，则提示错误信息。
          }
        }
      } else {
        amountTips = 'Transfer fees will charged by PayPal \$0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdolUI.appBar(context, 'Withdraw'),
      body: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 16, color: Colours.color_A9A9A9),
                    ),
                    Icon(Icons.info, size: 15, color: Colours.color_40A2A2A2),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  TextUtil.formatDoubleComma3(availableAmount / 100),
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
                    Padding(
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
                                'Select the payment',
                                style: TextStyle(
                                    color: Colours.color_B1B2B3, fontSize: 14),
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
                    Divider(
                      color: Colours.color_E7E8EC,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 0),
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
                              controller: accountController,
                              style: TextStyle(
                                  color: Colours.color_B1B2B3, fontSize: 14),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 254,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: accountErrorText,
                                errorStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colours.color_ED3544,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colours.color_E7E8EC,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 0),
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
                              controller: reAccountController,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colours.color_B1B2B3, fontSize: 14),
                              maxLines: 1,
                              maxLength: 254,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: confirmAccountErrorText,
                                errorStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colours.color_ED3544,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colours.color_E7E8EC,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount(\$)',
                            style: TextStyle(
                              color: Colours.color_3B3F42,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              style: TextStyle(
                                  color: Colours.color_B1B2B3, fontSize: 14),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: amountTips,
                                errorStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colours.color_ED3544,
                                ),
                              ),
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
                            amountTips,
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
                                  fontSize: 14, color: Colours.color_3B3F42),
                            ),
                            SizedBox(
                              height: 7,
                              width: double.infinity,
                            ),
                            Text(
                              'We will process the withdraw request within 2 working days.\nThe minimum withdrawal amount is \$100',
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
                        status: IdolButtonStatus.normal,
                        listener: (status) => {
                          if (status == IdolButtonStatus.enable) {_withdraw()}
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _withdraw() {
    IdolRoute.startVerifyPassword(
            context, withdrawTypeId, account, amount, password)
        .then((value) {
      if (value != null) {
        IdolRoute.popAndResult(context);
      }
    });
  }
}
