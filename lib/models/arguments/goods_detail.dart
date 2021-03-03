import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class GoodsDetailArguments implements Arguments{
  final String supplierId;
  final String goodsId;

  const GoodsDetailArguments(this.supplierId, this.goodsId);
}