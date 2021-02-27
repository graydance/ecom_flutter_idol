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
  final String updateTime;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GoodsDetail({
    this.id = '',
    this.supplierName= '',
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
    this.goods = const[],
    this.updateTime = '',
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
    List<Tag> tag,
    List<String> goods,
    String updateTime,
  }) {
    if ((id == null || identical(id, this.id)) &&
    (supplierName == null || identical(supplierName, this.supplierName)) &&
        (supplierId == null || identical(supplierId, this.supplierId)) &&
        (followStatus == null || identical(followStatus, this.followStatus)) &&
        (goodsName == null || identical(goodsName, this.goodsName)) &&
        (earningPrice == null || identical(earningPrice, this.earningPrice)) &&
        (earningPriceStr == null ||
            identical(earningPriceStr, this.earningPriceStr)) &&
        (suggestedPrice == null ||
            identical(suggestedPrice, this.suggestedPrice)) &&
        (suggestedPriceStr == null ||
            identical(suggestedPriceStr, this.suggestedPriceStr)) &&
        (goodsDescription == null ||
            identical(goodsDescription, this.goodsDescription)) &&
        (discount == null || identical(discount, this.discount)) &&
        (soldNum == null || identical(soldNum, this.soldNum)) &&
        (collectNum == null || identical(collectNum, this.collectNum)) &&
        (inMyStore == null || identical(inMyStore, this.inMyStore)) &&
        (tag == null || identical(tag, this.tag)) &&
        (goods == null || identical(goods, this.goods)) &&
        (updateTime == null || identical(updateTime, this.updateTime))) {
      return this;
    }

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
          other is GoodsDetail && runtimeType == other.runtimeType &&
              id == other.id && supplierName == other.supplierName &&
              supplierId == other.supplierId &&
              followStatus == other.followStatus &&
              goodsName == other.goodsName &&
              earningPrice == other.earningPrice &&
              earningPriceStr == other.earningPriceStr &&
              suggestedPrice == other.suggestedPrice &&
              suggestedPriceStr == other.suggestedPriceStr &&
              goodsDescription == other.goodsDescription &&
              discount == other.discount && soldNum == other.soldNum &&
              collectNum == other.collectNum && inMyStore == other.inMyStore &&
              tag == other.tag && goods == other.goods &&
              updateTime == other.updateTime;

  @override
  int get hashCode =>
      id.hashCode ^ supplierName.hashCode ^ supplierId.hashCode ^ followStatus
          .hashCode ^ goodsName.hashCode ^ earningPrice
          .hashCode ^ earningPriceStr.hashCode ^ suggestedPrice
          .hashCode ^ suggestedPriceStr.hashCode ^ goodsDescription
          .hashCode ^ discount.hashCode ^ soldNum.hashCode ^ collectNum
          .hashCode ^ inMyStore.hashCode ^ tag.hashCode ^ goods
          .hashCode ^ updateTime.hashCode;

  factory GoodsDetail.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return GoodsDetail(
      id: map[keyMapper('id')] as String,
      supplierName: map[keyMapper('supplierName')] as String,
      supplierId: map[keyMapper('supplierId')] as String,
      followStatus: map[keyMapper('followStatus')] as int,
      goodsName: map[keyMapper('goodsName')] as String,
      earningPrice: map[keyMapper('earningPrice')] as int,
      earningPriceStr: map[keyMapper('earningPriceStr')] as String,
      suggestedPrice: map[keyMapper('suggestedPrice')] as int,
      suggestedPriceStr: map[keyMapper('suggestedPriceStr')] as String,
      goodsDescription: map[keyMapper('goodsDescription')] as String,
      discount: map[keyMapper('discount')] as String,
      updateTime: map[keyMapper('updateTime')] as String,
      soldNum: map[keyMapper('soldNum')] as int,
      collectNum: map[keyMapper('collectNum')] as int,
      inMyStore: map[keyMapper('inMyStore')] as int,
      tag: (map[keyMapper('tag')] as List).map((e) => Tag.fromMap(e as Map<String, dynamic>)).toList(),
      goods: map[keyMapper('goods')].cast<String>(),
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
      keyMapper('supplierId'): this.supplierId,
      keyMapper('followStatus'): this.followStatus,
      keyMapper('goodsName'): this.goodsName,
      keyMapper('earningPrice'): this.earningPrice,
      keyMapper('earningPriceStr'): this.earningPriceStr,
      keyMapper('suggestedPrice'): this.suggestedPrice,
      keyMapper('suggestedPriceStr'): this.suggestedPriceStr,
      keyMapper('goodsDescription'): this.goodsDescription,
      keyMapper('discount'): this.discount,
      keyMapper('soldNum'): this.soldNum,
      keyMapper('collectNum'): this.collectNum,
      keyMapper('inMyStore'): this.inMyStore,
      keyMapper('tag'): this.tag,
      keyMapper('goods'): this.goods,
      keyMapper('updateTime'): this.updateTime,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}