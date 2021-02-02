import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class IdolLoadingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IdolLoadingWidgetState();
}

class _IdolLoadingWidgetState extends State<IdolLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
        )
      ),
    );
  }
}
