import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';
import 'package:idol/models/models.dart';

@immutable
class RewardsDetailArguments implements Arguments{
  final Reward reward;

  const RewardsDetailArguments({this.reward = const Reward()});
}