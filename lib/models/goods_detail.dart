import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:idol/models/tag.dart';

/// id : "商品id"
/// supplierName : "供应商名称"
/// supplierId : "供应商id"
/// followStatus : 0
/// goodsName : "商品名称"
/// earningPrice : 10
/// earningPriceStr : "0.10"
/// suggestedPrice : 100
/// suggestedPriceStr : "1.00"
/// goodsDescription : "商品描述"
/// discount : "商品折扣 ps: -20%"
/// soldNum : 100
/// collectNum : 100
/// inMyStore: 0, //0不在我的商店 1在我的商店
/// tag : [{"id":"标签id","interestName":"标签名称","interestPortrait":"标签图标","interestDescription":"标签描述","interestType":0}]
/// goods : ["商品图片/视频地址"]

@immutable
class GoodsDetail {
  final String id;
  final String supplierName;
  final String supplierId;
  final int followStatus;
  final String goodsName;
  final int earningPrice;
  final String earningPriceStr;
  final int suggestedPrice;
  final String suggestedPriceStr;
  final String goodsDescription;
  final String discount;
  final int soldNum;
  final int collectNum;
  final int inMyStore;
  final List<Tag> tag;
  final List<String> goods;
  final int updateTime;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GoodsDetail({
    this.id = '',
    this.supplierName = '',
    this.supplierId = '',
    this.followStatus = 0,
    this.goodsName = '',
    this.earningPrice = 0,
    this.earningPriceStr = '',
    this.suggestedPrice = 0,
    this.suggestedPriceStr = '',
    this.goodsDescription = '',
    this.discount = '',
    this.soldNum = 0,
    this.collectNum = 0,
    this.inMyStore = 0,
    this.tag = const [],
    this.goods = const [],
    this.updateTime = 0,
  });

  GoodsDetail copyWith({
    String id,
    String supplierName,
    String supplierId,
    int followStatus,
    String goodsName,
    int earningPrice,
    String earningPriceStr,
    int suggestedPrice,
    String suggestedPriceStr,
    String goodsDescription,
    String discount,
    int soldNum,
    int collectNum,
    int inMyStore,
    List<Tag> tag,
    List<String> goods,
    int updateTime,
  }) {
    return GoodsDetail(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      supplierId: supplierId ?? this.supplierId,
      followStatus: followStatus ?? this.followStatus,
      goodsName: goodsName ?? this.goodsName,
      earningPrice: earningPrice ?? this.earningPrice,
      earningPriceStr: earningPriceStr ?? this.earningPriceStr,
      suggestedPrice: suggestedPrice ?? this.suggestedPrice,
      suggestedPriceStr: suggestedPriceStr ?? this.suggestedPriceStr,
      goodsDescription: goodsDescription ?? this.goodsDescription,
      discount: discount ?? this.discount,
      soldNum: soldNum ?? this.soldNum,
      collectNum: collectNum ?? this.collectNum,
      inMyStore: inMyStore ?? this.inMyStore,
      tag: tag ?? this.tag,
      goods: goods ?? this.goods,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  String toString() {
    return 'GoodsDetail{id: $id, supplierName: $supplierName, supplierId: $supplierId, followStatus: $followStatus, goodsName: $goodsName, earningPrice: $earningPrice, earningPriceStr: $earningPriceStr, suggestedPrice: $suggestedPrice, suggestedPriceStr: $suggestedPriceStr, goodsDescription: $goodsDescription, discount: $discount, soldNum: $soldNum, collectNum: $collectNum, inMyStore: $inMyStore, tag: $tag, goods: $goods, updateTime: $updateTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodsDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          supplierName == other.supplierName &&
          supplierId == other.supplierId &&
          followStatus == other.followStatus &&
          goodsName == other.goodsName &&
          earningPrice == other.earningPrice &&
          earningPriceStr == other.earningPriceStr &&
          suggestedPrice == other.suggestedPrice &&
          suggestedPriceStr == other.suggestedPriceStr &&
          goodsDescription == other.goodsDescription &&
          discount == other.discount &&
          soldNum == other.soldNum &&
          collectNum == other.collectNum &&
          inMyStore == other.inMyStore &&
          tag == other.tag &&
          goods == other.goods &&
          updateTime == other.updateTime;

  @override
  int get hashCode =>
      id.hashCode ^
      supplierName.hashCode ^
      supplierId.hashCode ^
      followStatus.hashCode ^
      goodsName.hashCode ^
      earningPrice.hashCode ^
      earningPriceStr.hashCode ^
      suggestedPrice.hashCode ^
      suggestedPriceStr.hashCode ^
      goodsDescription.hashCode ^
      discount.hashCode ^
      soldNum.hashCode ^
      collectNum.hashCode ^
      inMyStore.hashCode ^
      tag.hashCode ^
      goods.hashCode ^
      updateTime.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplierName': supplierName,
      'supplierId': supplierId,
      'followStatus': followStatus,
      'goodsName': goodsName,
      'earningPrice': earningPrice,
      'earningPriceStr': earningPriceStr,
      'suggestedPrice': suggestedPrice,
      'suggestedPriceStr': suggestedPriceStr,
      'goodsDescription': goodsDescription,
      'discount': discount,
      'soldNum': soldNum,
      'collectNum': collectNum,
      'inMyStore': inMyStore,
      'tag': tag?.map((x) => x?.toMap())?.toList(),
      'goods': goods,
      'updateTime': updateTime,
    };
  }

  factory GoodsDetail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsDetail(
      id: map['id'],
      supplierName: map['supplierName'],
      supplierId: map['supplierId'],
      followStatus: map['followStatus'],
      goodsName: map['goodsName'],
      earningPrice: map['earningPrice'],
      earningPriceStr: map['earningPriceStr'],
      suggestedPrice: map['suggestedPrice'],
      suggestedPriceStr: map['suggestedPriceStr'],
      goodsDescription: map['goodsDescription'],
      discount: map['discount'],
      soldNum: map['soldNum'],
      collectNum: map['collectNum'],
      inMyStore: map['inMyStore'],
      tag: List<Tag>.from(map['tag']?.map((x) => Tag.fromMap(x))),
      goods: List<String>.from(map['goods']),
      updateTime: map['updateTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsDetail.fromJson(String source) =>
      GoodsDetail.fromMap(json.decode(source));
}
