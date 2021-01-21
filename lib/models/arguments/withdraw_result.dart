import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class WithdrawResultArguments implements Arguments{
  final int withdrawStatus;

  const WithdrawResultArguments({this.withdrawStatus = -1});
}