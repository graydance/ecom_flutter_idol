import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/rating_widget.dart';

/// 评分弹窗
class RatingDialog extends StatelessWidget {
  final Function onClose;
  final Function(String) onRate;

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