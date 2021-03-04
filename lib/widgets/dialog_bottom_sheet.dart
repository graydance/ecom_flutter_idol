import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';

/// 底部选择弹窗
class BottomSheetDialog extends StatefulWidget {
  //按钮title
  final List<String> items;

  //点击事件回调 0开始
  final Function(int) onItemClick;

  //标题 可选
  final String title;

  BottomSheetDialog(
      this.items, {
        this.onItemClick,
        this.title,
      });

  @override
  _BottomSheetDialogState createState() => _BottomSheetDialogState();
}

class _BottomSheetDialogState extends State<BottomSheetDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.color_C4C5CD,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //有标题的情况下
          (widget.title != null && widget.title.length > 0)
              ? Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Text(
              widget.title,
              style: TextStyle(color: Colours.color_979AA9, fontSize: 14),
            ),
            decoration: BoxDecoration(
              color: Colours.white,
              border: Border(
                bottom: BorderSide(color: Colours.color_E7E8EC, width: 1),
              ),
            ),
          )
              : Container(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((title) {
              int index = widget.items.indexOf(title);
              return GestureDetector(
                onTap: () {
                  IdolRoute.pop(context);
                  widget.onItemClick(index);
                },
                child: _createItem(title),
              );
            }).toList(),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: _createItem('Cancel'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _createItem(String title) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colours.black),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
        Border(bottom: BorderSide(color: Colours.color_E7E8EC, width: 1)),
      ),
    );
  }
}