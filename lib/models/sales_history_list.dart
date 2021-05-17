import 'package:flutter/material.dart';

/*
{
        "list": [
            {
                "id": "商品id",
                "goodsName": "商品名称",
                "goodsPicture": "商品头图",
                "soldNum": 100, //销售数量
                "earningPrice": 10, //"卖出收入"
                "earningPriceStr": "0.10", //卖出收入 两位小数 单位美元
            }
        ]
    }
 */
@immutable
class SalesHistoryList {
  final List<SalesHistory> list;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const SalesHistoryList({
    this.list,
  });

  SalesHistoryList copyWith({
    List<SalesHistory> list,
  }) {
    if ((list == null || identical(list, this.list))) {
      return this;
    }

    return SalesHistoryList(
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'SalesHistoryList{list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesHistoryList &&
          runtimeType == other.runtimeType &&
          list == other.list);

  @override
  int get hashCode => list.hashCode;

  factory SalesHistoryList.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return SalesHistoryList(
      list: map[keyMapper('list')] != null
          ? (map[keyMapper('list')] as List)
              .map((e) => SalesHistory.fromMap(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('list'): this.list,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class SalesHistory {
  final String id;
  final String goodsName;
  final String goodsPicture;
  final int soldNum;
  final int earningPrice;
  final String earningPriceStr;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const SalesHistory({
    this.id,
    this.goodsName,
    this.goodsPicture,
    this.soldNum,
    this.earningPrice,
    this.earningPriceStr,
  });

  SalesHistory copyWith({
    String id,
    String goodsName,
    String goodsPicture,
    String soldNum,
    int earningPrice,
    String earningPriceStr,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (goodsName == null || identical(goodsName, this.goodsName)) &&
        (goodsPicture == null || identical(goodsPicture, this.goodsPicture)) &&
        (soldNum == null || identical(soldNum, this.soldNum)) &&
        (earningPrice == null || identical(earningPrice, this.earningPrice)) &&
        (earningPriceStr == null ||
            identical(earningPriceStr, this.earningPriceStr))) {
      return this;
    }

    return SalesHistory(
      id: id ?? this.id,
      goodsName: goodsName ?? this.goodsName,
      goodsPicture: goodsPicture ?? this.goodsPicture,
      soldNum: soldNum ?? this.soldNum,
      earningPrice: earningPrice ?? this.earningPrice,
      earningPriceStr: earningPriceStr ?? this.earningPriceStr,
    );
  }

  @override
  String toString() {
    return 'SalesHistory{id: $id, goodsName: $goodsName, goodsPicture: $goodsPicture, soldNum: $soldNum, earningPrice: $earningPrice, earningPriceStr: $earningPriceStr}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesHistory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          goodsName == other.goodsName &&
          goodsPicture == other.goodsPicture &&
          soldNum == other.soldNum &&
          earningPrice == other.earningPrice &&
          earningPriceStr == other.earningPriceStr);

  @override
  int get hashCode =>
      id.hashCode ^
      goodsName.hashCode ^
      goodsPicture.hashCode ^
      soldNum.hashCode ^
      earningPrice.hashCode ^
      earningPriceStr.hashCode;

  factory SalesHistory.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return SalesHistory(
      id: map[keyMapper('id')] as String,
      goodsName: map[keyMapper('goodsName')] as String,
      goodsPicture: map[keyMapper('goodsPicture')] as String,
      soldNum: map[keyMapper('soldNum')] as int,
      earningPrice: map[keyMapper('earningPrice')] as int,
      earningPriceStr: map[keyMapper('earningPriceStr')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('goodsName'): this.goodsName,
      keyMapper('goodsPicture'): this.goodsPicture,
      keyMapper('soldNum'): this.soldNum,
      keyMapper('earningPrice'): this.earningPrice,
      keyMapper('earningPriceStr'): this.earningPriceStr,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
