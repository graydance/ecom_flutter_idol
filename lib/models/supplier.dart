import 'package:flutter/material.dart';
import 'package:idol/models/tag.dart';

/// id : "供应商id"
/// supplierName : "供应商名称"
/// products : 100
/// follows : 100
/// sold : 100
/// followStatus : 0
/// description : "供应商描述"
/// tag : [{"id":"标签id","interestName":"标签名称","interestPortrait":"标签图标","interestDescription":"标签描述","interestType":0}]

/// 供应商个人信息
@immutable
class Supplier {
  final String id;
  final String supplierName;
  final int products;
  final int follows;
  final int sold;
  final int followStatus;
  final String description;
  final List<Tag> tag;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Supplier({
    this.id = '',
    this.supplierName = '',
    this.products = 0,
    this.follows = 0,
    this.sold = 0,
    this.followStatus = 0,
    this.description = '',
    this.tag = const [],
  });

  Supplier copyWith({
    String id,
    String supplierName,
    int products,
    int follows,
    int sold,
    int followStatus,
    String description,
    List<Tag> tag,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (supplierName == null || identical(supplierName, this.supplierName)) &&
        (products == null || identical(products, this.products)) &&
        (follows == null || identical(follows, this.follows)) &&
        (sold == null || identical(sold, this.sold)) &&
        (followStatus == null || identical(followStatus, this.followStatus)) &&
        (description == null || identical(description, this.description)) &&
        (tag == null || identical(tag, this.tag))) {
      return this;
    }

    return Supplier(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      products: products ?? this.products,
      follows: follows ?? this.follows,
      sold: sold ?? this.sold,
      followStatus: followStatus ?? this.followStatus,
      description: description ?? this.description,
      tag: tag ?? this.tag,
    );
  }

  @override
  String toString() {
    return 'Supplier{id: $id, supplierName: $supplierName, products: $products, follows: $follows, sold: $sold, followStatus: $followStatus, description: $description, tag: $tag}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          supplierName == other.supplierName &&
          products == other.products &&
          follows == other.follows &&
          sold == other.sold &&
          followStatus == other.followStatus &&
          description == other.description &&
          tag == other.tag);

  @override
  int get hashCode =>
      id.hashCode ^
      supplierName.hashCode ^
      products.hashCode ^
      follows.hashCode ^
      sold.hashCode ^
      followStatus.hashCode ^
      description.hashCode ^
      tag.hashCode;

  factory Supplier.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Supplier(
      id: map[keyMapper('id')] as String,
      supplierName: map[keyMapper('supplierName')] as String,
      products: map[keyMapper('products')] as int,
      follows: map[keyMapper('follows')] as int,
      sold: map[keyMapper('sold')] as int,
      followStatus: map[keyMapper('followStatus')] as int,
      description: map[keyMapper('description')] as String,
      tag: (map[keyMapper('tag')] as List)?.map((i) => Tag.fromMap(i as Map<String, dynamic>))?.toList(),
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('supplierName'): this.supplierName,
      keyMapper('products'): this.products,
      keyMapper('follows'): this.follows,
      keyMapper('sold'): this.sold,
      keyMapper('followStatus'): this.followStatus,
      keyMapper('description'): this.description,
      keyMapper('tag'): this.tag,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}