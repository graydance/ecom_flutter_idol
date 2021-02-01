import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';

/// 统一错误提示
class IdolErrorWidget extends StatefulWidget {
  final String tipsText;
  final OnRetryClickCallback onRetry;

  IdolErrorWidget(this.onRetry,
      {this.tipsText = 'Oh, sorry about the network connection\n error'});

  @override
  State<StatefulWidget> createState() => _IdolErrorWidgetState();
}

class _IdolErrorWidgetState extends State<IdolErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: R.image.bg_common_error(),
            width: 212,
            height: 168,
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            'Sorry',
            style: TextStyle(color: Colours.color_3B3F42, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.tipsText,
            style: TextStyle(color: Colours.color_B1B2B3, fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              widget.onRetry();
            },
            child: Text(
              'Retry',
              style: TextStyle(color: Colours.color_48B6EF, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}

typedef OnRetryClickCallback = Function();