import 'package:flutter/material.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/rating_widget.dart';

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

/// 列表Item被点击或选中
/// index：索引
/// T t 返回index对应Item绑定的元素
typedef OnItemSelectedListener<T> = void Function(int index, T t);

/// 选择支付方式弹窗
class SelectPaymentMethodsDialog extends StatefulWidget {
  final defaultSelectedIndex;
  final List<WithdrawType> withdrawType;
  final OnClickListener onClose;
  final OnItemSelectedListener<WithdrawType> onItemSelected;

  const SelectPaymentMethodsDialog(
      this.withdrawType, {
        this.defaultSelectedIndex = -1,
        this.onClose,
        this.onItemSelected,
      });

  @override
  State<StatefulWidget> createState() => _SelectPaymentMethodsDialogState();
}

class _SelectPaymentMethodsDialogState
    extends State<SelectPaymentMethodsDialog> {
  int _selectedItemIndex;
  WithdrawType _withdrawType;

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
                  onTap: () => widget.onClose(),
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
                GridView.count(
                  shrinkWrap: true,
                  //水平子Widget之间间距
                  crossAxisSpacing: 0.0,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 5.0,
                  //GridView内边距
                  padding: EdgeInsets.all(30.0),
                  //一行的Widget数量
                  crossAxisCount: 2,
                  //子Widget宽高比例
                  childAspectRatio: 2.0,
                  //子Widget列表
                  children: _createPaymentMethodsWidgets(),
                ),
                IdolButton('Done',
                    status: IdolButtonStatus.enable,
                    width: 100,
                    height: 36, listener: (status) {
                      debugPrint(
                          '_selectedItemIndex：$_selectedItemIndex, _withdrawType：$_withdrawType');
                      widget.onItemSelected(_selectedItemIndex, _withdrawType);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createPaymentMethodsWidgets() {
    return widget.withdrawType
        .asMap()
        .map((key, value) {
      return MapEntry(
        key,
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedItemIndex = key;
                _withdrawType = value;
              });
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 10, top: 5, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(
                        color: _selected(key)
                            ? Colours.color_4E9AE3
                            : Colours.white,
                        width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colours.color_40A2A2A2,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2,
                          spreadRadius: 0.5),
                    ],
                  ),
                  child: Image(
                    image: NetworkImage(value.portrait),
                    width: 65,
                    height: 24,
                  ),
                ),
                ...(_selected(key))
                    ? [
                  Align(
                    widthFactor: 6.2,
                    heightFactor: 0,
                    alignment: Alignment.topRight,
                    child:
                    // Expanded(),
                    Icon(
                      Icons.check_circle,
                      color: Colours.color_4E9AE3,
                      size: 15,
                    ),
                  ),
                ]
                    : [],
              ],
            ),
          ),
        ),
      );
    })
        .values
        .toList();
  }

  bool _selected(int currentIndex) {
    debugPrint('_selected >>> currentIndex:$currentIndex | _selectedItemIndex:$_selectedItemIndex');
    if(_selectedItemIndex != null){
      return currentIndex == _selectedItemIndex;
    }else{
      return widget.defaultSelectedIndex != null && currentIndex == widget.defaultSelectedIndex;
    }
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
                    value: 0,
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