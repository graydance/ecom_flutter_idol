import "package:flutter/material.dart";

class AppTheme {
  static final colorED8514 = Color(0xffED8514);
  static final color0F1015 = Color(0xff0F1015);
  static final color979AA9 = Color(0xff979AA9);
  static final colorEDEEF0 = Color(0xffEDEEF0);
  static final colorC4C5CD = Color(0xffC4C5CD);
  static final colorED3544 = Color(0xFFED3544);
  static final colorF6F6F6 = Color(0xFFF6F6F6);
  static final color48B6EF = Color(0xFF48B6EF);
  static final color555764 = Color(0xFF555764);
  static final colorC20010 = Color(0xFFC20010);
  static final colorF4F4F4 = Color(0xFFF4F4F4);

  /// checkbox color
  static final colorFEAC1B = Color(0xFFFEAC1B);

  /// checkbox uncheck color
  static final colorE7E8EC = Color(0xFFE7E8EC);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    } else {
      hexColor = "FFED8514";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
