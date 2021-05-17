import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:idol/models/tag.dart';

/// totalPage : 1
/// currentPage : 1
/// list : [{"id":"eLRGN8Bw","idolGoodsId":"红人商品id","picture":"https://www.baidu.com1","width":1,"height":1,"isSellOut":1,"isOffTheShelf":1},{"id":"OZ8MpEbg","idolGoodsId":"红人商品id","picture":"","width":1,"height":1,"isSellOut":1,"isOffTheShelf":1}]
@immutable
class StoreGoodsList {
  final int totalPage;
  final int currentPage;
  final List<StoreGoods> list;

  const StoreGoodsList({
    this.totalPage = 1,
    this.currentPage = 1,
    this.list = const [],
  });

  StoreGoodsList copyWith({
    int totalPage,
    int currentPage,
    List<StoreGoods> list,
  }) {
    return StoreGoodsList(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPage': totalPage,
      'currentPage': currentPage,
      'list': list?.map((x) => x.toMap())?.toList(),
    };
  }

  factory StoreGoodsList.fromMap(Map<String, dynamic> map) {
    return StoreGoodsList(
      totalPage: map['totalPage'],
      currentPage: map['currentPage'],
      list:
          List<StoreGoods>.from(map['list']?.map((x) => StoreGoods.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreGoodsList.fromJson(String source) =>
      StoreGoodsList.fromMap(json.decode(source));

  @override
  String toString() =>
      'StoreGoodsList(totalPage: $totalPage, currentPage: $currentPage, list: $list)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreGoodsList &&
        other.totalPage == totalPage &&
        other.currentPage == currentPage &&
        listEquals(other.list, list);
  }

  @override
  int get hashCode => totalPage.hashCode ^ currentPage.hashCode ^ list.hashCode;
}

@immutable
class StoreGoods {
  final String id;
  final String idolGoodsId;
  final String picture;
  final int width;
  final int height;
  final int isSellOut;
  final int isOffTheShelf;
  final String interestName;
  final String supplierId;
  final String goodsName;
  final int originalPrice;
  final String originalPriceStr;
  final int currentPrice;
  final String currentPriceStr;
  final String discount;
  final List<Tag> tag;
  final int heatRank;
  final List<String> pictures;

  const StoreGoods({
    this.id = '',
    this.idolGoodsId = '',
    this.picture = '',
    this.width = 0,
    this.height = 0,
    this.isSellOut = 0,
    this.isOffTheShelf = 0,
    this.interestName = '',
    this.supplierId = '',
    this.goodsName = '',
    this.originalPrice = 0,
    this.originalPriceStr = '',
    this.currentPrice = 0,
    this.currentPriceStr = '',
    this.discount = '',
    this.tag = const [],
    this.heatRank = 0,
    this.pictures = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreGoods &&
        other.id == id &&
        other.idolGoodsId == idolGoodsId &&
        other.picture == picture &&
        other.width == width &&
        other.height == height &&
        other.isSellOut == isSellOut &&
        other.isOffTheShelf == isOffTheShelf &&
        other.interestName == interestName &&
        other.supplierId == supplierId &&
        other.goodsName == goodsName &&
        other.originalPrice == originalPrice &&
        other.originalPriceStr == originalPriceStr &&
        other.currentPrice == currentPrice &&
        other.currentPriceStr == currentPriceStr &&
        other.discount == discount &&
        listEquals(other.tag, tag) &&
        other.heatRank == heatRank &&
        listEquals(other.pictures, pictures);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idolGoodsId.hashCode ^
        picture.hashCode ^
        width.hashCode ^
        height.hashCode ^
        isSellOut.hashCode ^
        isOffTheShelf.hashCode ^
        interestName.hashCode ^
        supplierId.hashCode ^
        goodsName.hashCode ^
        originalPrice.hashCode ^
        originalPriceStr.hashCode ^
        currentPrice.hashCode ^
        currentPriceStr.hashCode ^
        discount.hashCode ^
        tag.hashCode ^
        heatRank.hashCode ^
        pictures.hashCode;
  }

  StoreGoods copyWith({
    String id,
    String idolGoodsId,
    String picture,
    int width,
    int height,
    int isSellOut,
    int isOffTheShelf,
    String interestName,
    String supplierId,
    String goodsName,
    int originalPrice,
    String originalPriceStr,
    int currentPrice,
    String currentPriceStr,
    String discount,
    List<Tag> tag,
    int heatRank,
    List<String> pictures,
  }) {
    return StoreGoods(
      id: id ?? this.id,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      picture: picture ?? this.picture,
      width: width ?? this.width,
      height: height ?? this.height,
      isSellOut: isSellOut ?? this.isSellOut,
      isOffTheShelf: isOffTheShelf ?? this.isOffTheShelf,
      interestName: interestName ?? this.interestName,
      supplierId: supplierId ?? this.supplierId,
      goodsName: goodsName ?? this.goodsName,
      originalPrice: originalPrice ?? this.originalPrice,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      currentPrice: currentPrice ?? this.currentPrice,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
      discount: discount ?? this.discount,
      tag: tag ?? this.tag,
      heatRank: heatRank ?? this.heatRank,
      pictures: pictures ?? this.pictures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idolGoodsId': idolGoodsId,
      'picture': picture,
      'width': width,
      'height': height,
      'isSellOut': isSellOut,
      'isOffTheShelf': isOffTheShelf,
      'interestName': interestName,
      'supplierId': supplierId,
      'goodsName': goodsName,
      'originalPrice': originalPrice,
      'originalPriceStr': originalPriceStr,
      'currentPrice': currentPrice,
      'currentPriceStr': currentPriceStr,
      'discount': discount,
      'tag': tag?.map((x) => x.toMap())?.toList(),
      'heatRank': heatRank,
      'pictures': pictures,
    };
  }

  factory StoreGoods.fromMap(Map<String, dynamic> map) {
    return StoreGoods(
      id: map['id'],
      idolGoodsId: map['idolGoodsId'],
      picture: map['picture'],
      width: map['width'],
      height: map['height'],
      isSellOut: map['isSellOut'],
      isOffTheShelf: map['isOffTheShelf'],
      interestName: map['interestName'],
      supplierId: map['supplierId'],
      goodsName: map['goodsName'],
      originalPrice: map['originalPrice'],
      originalPriceStr: map['originalPriceStr'],
      currentPrice: map['currentPrice'],
      currentPriceStr: map['currentPriceStr'],
      discount: map['discount'],
      tag: List<Tag>.from(map['tag']?.map((x) => Tag.fromMap(x)) ?? []),
      heatRank: map['heatRank'],
      pictures: List<String>.from(map['pictures'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreGoods.fromJson(String source) =>
      StoreGoods.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StoreGoods(id: $id, idolGoodsId: $idolGoodsId, picture: $picture, width: $width, height: $height, isSellOut: $isSellOut, isOffTheShelf: $isOffTheShelf, interestName: $interestName, supplierId: $supplierId, goodsName: $goodsName, originalPrice: $originalPrice, originalPriceStr: $originalPriceStr, currentPrice: $currentPrice, currentPriceStr: $currentPriceStr, discount: $discount, tag: $tag, heatRank: $heatRank, pictures: $pictures)';
  }
}
