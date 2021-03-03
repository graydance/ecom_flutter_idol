import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class InnerWebViewArguments extends Arguments{
  final String title;
  final String url;

  const InnerWebViewArguments(this.title, this.url);
}