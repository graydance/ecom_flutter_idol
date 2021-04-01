import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/button.dart';

class WelcomeDialog extends StatelessWidget {
  final VoidCallback onClose;

  const WelcomeDialog({Key key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    IdolRoute.pop(context);
                    if (onClose != null) onClose();
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Color(0xFF40A2A2A2),
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: Image(
                    image: R.image.ic_welcome_dialog(),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Congratulations!\nYou\'ve opened your store!\nYou can check it at the last tab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F1015),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: IdolButton(
                    'START',
                    status: IdolButtonStatus.enable,
                    listener: (status) {
                      IdolRoute.pop(context);
                      if (onClose != null) onClose();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FirstDialog extends StatelessWidget {
  final VoidCallback onClose;

  const FirstDialog({Key key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    IdolRoute.pop(context);
                    if (onClose != null) onClose();
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Color(0xFF40A2A2A2),
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: Image(
                    image: R.image.new_guid(),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Congratulations on the first step!\nStart making money with Olaak.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F1015),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: IdolButton(
                    "Let's Roll",
                    status: IdolButtonStatus.enable,
                    listener: (status) {
                      IdolRoute.pop(context);
                      if (onClose != null) onClose();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
