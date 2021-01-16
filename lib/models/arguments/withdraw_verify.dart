import 'package:flutter/material.dart';
import 'base.dart';

@immutable
class WithdrawVerifyArguments implements Arguments{

  final String withdrawTypeId;
  final String account;
  final int amount;

  const WithdrawVerifyArguments({this.withdrawTypeId = '', this.account = '', this.amount = 0});
}