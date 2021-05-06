import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class SalesHistoryArguments implements Arguments {
  final String date;
  final String money;
  final String dateStr;
  const SalesHistoryArguments(this.date, this.money, this.dateStr);
}
