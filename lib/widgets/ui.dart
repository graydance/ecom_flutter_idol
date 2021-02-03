import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
class IdolUI {
  static AppBar appBar(BuildContext context, String title,{bool centerTitle = false}) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colours.color_29292B),
      ),
      centerTitle: centerTitle,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colours.color_444648,
          size: 16,
        ),
        onPressed: () => IdolRoute.pop(context),
      ),
    );
  }
}