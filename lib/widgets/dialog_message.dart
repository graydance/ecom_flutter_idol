import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';

/// Dialog
class IdolMessageDialog extends StatelessWidget {
  final String buttonText;
  final String message;
  final AssetImage image;
  final Function onClose;
  final Function onTap;

  const IdolMessageDialog(this.message,
      {Key key,
      this.buttonText = 'Next',
      this.onClose,
      this.onTap,
      this.image});

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
              borderRadius: BorderRadius.all(Radius.circular(12)),
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
                image != null ? Padding(
                  padding: EdgeInsets.only(
                    left: 45,
                    right: 45,
                  ),
                  child: Image(
                    image: image,
                  ),
                ) : [],
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colours.color_0F1015),
                  ),
                ),
                IdolButton(
                  buttonText,
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => onTap(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
