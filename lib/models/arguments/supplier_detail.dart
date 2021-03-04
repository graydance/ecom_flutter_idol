import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class SupplierDetailArguments implements Arguments{
  final String supplierId;
  final String supplierName;

  const SupplierDetailArguments(this.supplierId, this.supplierName);
}