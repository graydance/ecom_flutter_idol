import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/rating_widget.dart';

class IdolUI {
  static AppBar appBar(BuildContext context, String title) {
    return AppBar(
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colours.color_29292B),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colours.color_444648,
          size: 16,
        ),
        onPressed: () => IdolRoute.pop(context),
      ),
    );
  }
}

/// 通用按钮样式
class IdolButton extends StatelessWidget {
  /// Button text.
  final String text;

  /// Button status [IdolButtonStatus]
  final IdolButtonStatus status;

  /// Button width.
  final double width;

  /// Button height.
  final double height;

  /// Button active gradient colors.
  final List<Color> enableColors;

  /// Button IdolButtonStatus.disable color.
  final Color disableColor;

  /// Button IdolButtonStatus.normal color.
  final Color normalColor;

  /// Button [LinearGradient.begin]
  final Alignment linearGradientBegin;

  /// Button [LinearGradient.end]
  final Alignment linearGradientEnd;

  /// Button click callback.
  final IdolButtonClickListener listener;

  const IdolButton(
    this.text, {
    Key key,
    this.status = IdolButtonStatus.enable,
    this.width = double.infinity,
    this.height = 45,
    this.enableColors = const <Color>[
      Colours.color_F68A51,
      Colours.color_EA5228
    ],
    this.disableColor = Colours.color_FFD8B1,
    this.normalColor = Colours.color_C3C4C4,
    this.linearGradientBegin = Alignment.centerLeft,
    this.linearGradientEnd = Alignment.centerRight,
    this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return status == IdolButtonStatus.enable
        ? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: linearGradientBegin,
                end: linearGradientEnd,
                colors: enableColors,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: RaisedButton(
              onPressed: () => listener(status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: Text(
                text,
                style: TextStyle(color: Colours.white, fontSize: 16),
              ),
            ),
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: status == IdolButtonStatus.normal
                  ? normalColor
                  : disableColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: RaisedButton(
              onPressed: () => listener(status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: Text(
                text,
                style: TextStyle(color: Colours.white, fontSize: 16),
              ),
            ),
          );
  }
}

enum IdolButtonStatus {
  /// 默认状态，为灰色不可点击
  normal,

  /// 用户已进行交互，但条件未完全满足
  disable,

  /// 满足条件，可进行点击
  enable,
}

/// IdolButton点击监听
typedef IdolButtonClickListener = void Function(IdolButtonStatus status);

/// 点击回调
typedef OnClickListener = void Function();

/// 评分点击回调
typedef OnRateClickListener = void Function(String rateValue);

/// Dialog
class WithdrawMessageDialog extends StatelessWidget {
  final String message;
  final OnClickListener onClose;
  final OnClickListener onNext;

  const WithdrawMessageDialog(this.message,
      {Key key, this.onClose, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onClose(),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colours.color_3B3F42),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                IdolButton(
                  'Next',
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => onNext(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 选择支付方式弹窗
class SelectPaymentMethodsDialog extends StatefulWidget {
  final List<WithdrawType> withdrawType;
  final OnClickListener onClose;
  final OnClickListener onNext;

  const SelectPaymentMethodsDialog(
    this.withdrawType, {
    Key key,
    this.onClose,
    this.onNext,
  });

  @override
  State<StatefulWidget> createState() => _SelectPaymentMethodsDialogState();
}

class _SelectPaymentMethodsDialogState
    extends State<SelectPaymentMethodsDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => widget.onClose,
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Payment Methods',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colours.color_3B3F42,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GridView.count(
                  //水平子Widget之间间距
                  crossAxisSpacing: 10.0,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 10.0,
                  //GridView内边距
                  padding: EdgeInsets.all(10.0),
                  //一行的Widget数量
                  crossAxisCount: 2,
                  //子Widget宽高比例
                  childAspectRatio: 2.0,
                  //子Widget列表
                  children: _createPaymentMethodsWidgets(),
                ),
                SizedBox(
                  height: 15,
                ),
                IdolButton(
                  'Next',
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => widget.onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createPaymentMethodsWidgets() {
    widget.withdrawType.forEach((element) {
      Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: Colours.color_4E9AE3, width: 1)),
            child: Image(
              image: NetworkImage(element.portrait),
              width: 65,
              height: 24,
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colours.color_4E9AE3,
            size: 12,
          ),
        ],
      );
    });
  }
}

/// 评分弹窗
class RatingDialog extends StatelessWidget {
  final OnClickListener onClose;
  final OnRateClickListener onRate;

  const RatingDialog({Key key, this.onClose, this.onRate});

  @override
  Widget build(BuildContext context) {
    String rateValue;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onClose(),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Let us know how we\'re doing!\nPlease rate our app and services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colours.color_3B3F42),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: RatingWidget(
                    onRatingUpdate: (value) => {rateValue = value},
                    normalImage: Icon(
                      Icons.star_border,
                      size: 25,
                      color: Colours.color_C4C5CD,
                    ),
                    selectImage: Icon(
                      Icons.star,
                      size: 25,
                      color: Colours.color_FFD457,
                    ),
                    selectAble: true,
                    count: 5,
                    maxRating: 10,
                    padding: 5,
                  ),
                ),
                IdolButton(
                  'Rate',
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => onRate(rateValue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
