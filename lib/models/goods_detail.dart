import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:idol/models/goods_skus.dart';
import 'package:idol/models/goods_spec.dart';
import 'package:idol/models/models.dart';
import 'package:idol/models/tag.dart';

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

  final List<GoodsSkus> goodsSkus;
  final List<GoodsSpec> specList;
  final List<ServiceConfig> serviceConfigs;
  final String shippedFrom;
  final String shippedTo;
  final List<ExpressTemplete> expressTemplete;
  final int isCustomiz;

  final String shareText;
  final List<GoodsItem> recommend;

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
    this.goodsSkus = const [],
    this.specList = const [],
    this.serviceConfigs = const [],
    this.shippedFrom = '',
    this.shippedTo = '',
    this.expressTemplete = const [],
    this.isCustomiz = 0,
    this.shareText = '',
    this.recommend = const [],
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
    List<GoodsSkus> goodsSkus,
    List<GoodsSpec> specList,
    List<ServiceConfig> serviceConfigs,
    String shippedFrom,
    String shippedTo,
    List<ExpressTemplete> expressTemplete,
    int isCustomiz,
    String shareText,
    List<GoodsItem> recommend,
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
      goodsSkus: goodsSkus ?? this.goodsSkus,
      specList: specList ?? this.specList,
      serviceConfigs: serviceConfigs ?? this.serviceConfigs,
      shippedFrom: shippedFrom ?? this.shippedFrom,
      shippedTo: shippedTo ?? this.shippedTo,
      expressTemplete: expressTemplete ?? this.expressTemplete,
      isCustomiz: isCustomiz ?? this.isCustomiz,
      shareText: shareText ?? this.shareText,
      recommend: recommend ?? this.recommend,
    );
  }

  @override
  String toString() {
    return 'GoodsDetail(id: $id, supplierName: $supplierName, supplierId: $supplierId, followStatus: $followStatus, goodsName: $goodsName, earningPrice: $earningPrice, earningPriceStr: $earningPriceStr, suggestedPrice: $suggestedPrice, suggestedPriceStr: $suggestedPriceStr, goodsDescription: $goodsDescription, discount: $discount, soldNum: $soldNum, collectNum: $collectNum, inMyStore: $inMyStore, tag: $tag, goods: $goods, updateTime: $updateTime, goodsSkus: $goodsSkus, specList: $specList, serviceConfigs: $serviceConfigs, shippedFrom: $shippedFrom, shippedTo: $shippedTo, expressTemplete: $expressTemplete, isCustomiz: $isCustomiz, shareText: $shareText, recommend: $recommend)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoodsDetail &&
        other.id == id &&
        other.supplierName == supplierName &&
        other.supplierId == supplierId &&
        other.followStatus == followStatus &&
        other.goodsName == goodsName &&
        other.earningPrice == earningPrice &&
        other.earningPriceStr == earningPriceStr &&
        other.suggestedPrice == suggestedPrice &&
        other.suggestedPriceStr == suggestedPriceStr &&
        other.goodsDescription == goodsDescription &&
        other.discount == discount &&
        other.soldNum == soldNum &&
        other.collectNum == collectNum &&
        other.inMyStore == inMyStore &&
        listEquals(other.tag, tag) &&
        listEquals(other.goods, goods) &&
        other.updateTime == updateTime &&
        listEquals(other.goodsSkus, goodsSkus) &&
        listEquals(other.specList, specList) &&
        listEquals(other.serviceConfigs, serviceConfigs) &&
        other.shippedFrom == shippedFrom &&
        other.shippedTo == shippedTo &&
        listEquals(other.expressTemplete, expressTemplete) &&
        other.isCustomiz == isCustomiz &&
        other.shareText == shareText &&
        listEquals(other.recommend, recommend);
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
        updateTime.hashCode ^
        goodsSkus.hashCode ^
        specList.hashCode ^
        serviceConfigs.hashCode ^
        shippedFrom.hashCode ^
        shippedTo.hashCode ^
        expressTemplete.hashCode ^
        isCustomiz.hashCode ^
        shareText.hashCode ^
        recommend.hashCode;
  }

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
      'tag': tag?.map((x) => x.toMap())?.toList(),
      'goods': goods,
      'updateTime': updateTime,
      'goodsSkus': goodsSkus?.map((x) => x.toMap())?.toList(),
      'specList': specList?.map((x) => x.toMap())?.toList(),
      'serviceConfigs': serviceConfigs?.map((x) => x.toMap())?.toList(),
      'shippedFrom': shippedFrom,
      'shippedTo': shippedTo,
      'expressTemplete': expressTemplete?.map((x) => x.toMap())?.toList(),
      'isCustomiz': isCustomiz,
      'shareText': shareText,
      'recommend': recommend?.map((x) => x.toMap())?.toList(),
    };
  }

  factory GoodsDetail.fromMap(Map<String, dynamic> map) {
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
      tag: List<Tag>.from(map['tag']?.map((x) => Tag.fromMap(x)) ?? []),
      goods: List<String>.from(map['goods']),
      updateTime: map['updateTime'],
      goodsSkus: List<GoodsSkus>.from(
          map['goodsSkus']?.map((x) => GoodsSkus.fromMap(x)) ?? []),
      specList: List<GoodsSpec>.from(
          map['specList']?.map((x) => GoodsSpec.fromMap(x)) ?? []),
      serviceConfigs: List<ServiceConfig>.from(
          map['serviceConfigs']?.map((x) => ServiceConfig.fromMap(x)) ?? []),
      shippedFrom: map['shippedFrom'] ?? '',
      shippedTo: map['shippedTo'] ?? '',
      expressTemplete: List<ExpressTemplete>.from(
          map['expressTemplete']?.map((x) => ExpressTemplete.fromMap(x)) ?? []),
      isCustomiz: map['isCustomiz'] ?? 0,
      shareText: map['shareText'] ?? '',
      recommend: List<GoodsItem>.from(
          map['recommend']?.map((x) => GoodsItem.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsDetail.fromJson(String source) =>
      GoodsDetail.fromMap(json.decode(source));
}
