import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/button.dart';

/// 修改用户名
class ChangeUserNameDialog extends StatefulWidget {
  final String userName;
  final String linkDomain;
  final Function onCancel;
  final Function(String newUserName) onSave;

  ChangeUserNameDialog(
      this.userName, this.linkDomain, this.onCancel, this.onSave);

  @override
  State<StatefulWidget> createState() => _ChangeUserNameDialogState();
}

class _ChangeUserNameDialogState extends State<ChangeUserNameDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colours.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 7, bottom: 7, right: 12),
                  child: GestureDetector(
                    onTap: (){
                      IdolRoute.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: Colours.color_C4C5CD,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change Your UserName',
                        style: TextStyle(
                            fontSize: 16, color: Colours.color_0F1015),
                      ),
                      Text(
                        'Changing your username will change the link to your profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, color: Colours.color_979AA9),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (userName) {
                          setState(() {
                            // update IdolButtonStatus
                          });
                        },
                        style: TextStyle(
                            color: Colours.color_979AA9, fontSize: 16),
                        textAlign: TextAlign.start,
                        controller: _controller,
                        maxLength: 512,
                        maxLines: 1,
                        enabled: true,
                        cursorColor: Colours.color_979AA9,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.only(
                              left: 8, top: 12, right: 8, bottom: 12),
                          counterText: '',
                          filled: true,
                          fillColor: Colours.color_EDEEF0,
                          prefix: Text(
                            '${widget.linkDomain.replaceAll('https://', '')}',
                            style: TextStyle(
                                color: Colours.color_48B6EF, fontSize: 16),
                          ),
                          hintText: widget.userName,
                          hintStyle: TextStyle(
                              color: Colours.color_979AA9, fontSize: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colours.white),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      IdolButton(
                        'Save',
                        width: 160,
                        height: 44,
                        status: widget.userName == _controller.text.trim()
                            ? IdolButtonStatus.disable
                            : IdolButtonStatus.enable,
                        listener: (status) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (widget.onSave != null) {
                            widget.onSave(_controller.text.trim());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
