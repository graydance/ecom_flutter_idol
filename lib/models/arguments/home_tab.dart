import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class HomeTabArguments implements Arguments{
  final int tabIndex;

  const HomeTabArguments({this.tabIndex = 0});
}