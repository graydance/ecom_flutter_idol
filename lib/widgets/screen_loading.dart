import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class ScreenLoadingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLoadingWidgetState();
}

class _ScreenLoadingWidgetState extends State<ScreenLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
      ),
    );
  }
}
