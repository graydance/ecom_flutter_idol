import 'package:flutter/material.dart';
import 'package:idol/res/Strings.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';

import '../r.g.dart';
import '../router.dart';

/*
  忘记密码
 */
class DialogResetPassword extends StatelessWidget {
  final String title;
  final String content;
  final Function onTab;

  const DialogResetPassword(
    this.title,
    this.content, {
    Key key,
    this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 43, right: 43),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        IdolRoute.pop(context);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Image(
                          image: R.image.dialog_close(),
                          width: 12,
                          height: 12,
                        ),
                      )),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: 23.5, right: 23.5),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colours.color_979AA9, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                IdolButton(
                  StringBasic.ok,
                  status: IdolButtonStatus.enable,
                  width: 160,
                  height: 44,
                  listener: (status) => onTab(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
