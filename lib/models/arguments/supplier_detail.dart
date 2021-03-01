import 'package:idol/models/arguments/base.dart';

class SupplierDetailArguments implements Arguments{
  final String supplierId;
  final String supplierName;

  const SupplierDetailArguments(this.supplierId, this.supplierName);
}