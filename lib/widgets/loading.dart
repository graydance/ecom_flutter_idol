import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class IdolLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('IdolLoading Widget buid');
    return Center(
      child: Container(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
          )),
    );
  }
}
