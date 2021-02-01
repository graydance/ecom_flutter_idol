import 'package:flutter/material.dart';
import 'package:idol/models/tag.dart';

/// id : "商品id"
/// goodsPicture : "商品头图"
/// discount : "商品折扣 ps: -20%"
/// description : "商品描述"
/// originalPrice : "商品原价"
/// originalPriceStr : "1.00"
/// currentPrice : "商品现价"
/// currentPriceStr : "0.80"
/// tag : [{"id":"标签id","interestName":"标签名称","interestPortrait":"标签图标","interestDescription":"标签描述","interestType":0}]
@immutable
class Goods {
  final String id;
  final String goodsName;
  final String goodsPicture;
  final String discount;
  final String description;
  final int originalPrice;
  final String originalPriceStr;
  final int currentPrice;
  final String currentPriceStr;

  // Following/For You接口返回的商品信息
  final String picture;
  final int width;
  final int height;
  final String interestName;

  // 0 未售罄，1 售罄
  final int isSellOut;
  // 0 未下架，1 下架
  final int isOffTheShelf;

  final List<Tag> tag;


//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Goods({
    this.id = '',
    this.goodsName = '',
    this.goodsPicture = '',
    this.discount = '',
    this.description = '',
    this.originalPrice = 0,
    this.originalPriceStr = '0.00',
    this.currentPrice = 0,
    this.currentPriceStr = '0.00',
    this.picture = '',
    this.width = 0,
    this.height = 0,
    this.interestName = '',
    this.isSellOut = 0,
    this.isOffTheShelf = 0,
    this.tag = const [],
  });

  Goods copyWith({
    String id,
    String goodsPicture,
    String discount,
    String description,
    String originalPrice,
    String originalPriceStr,
    String currentPrice,
    String currentPriceStr,
    String picture,
    int width,
    int height,
    String interestName,
    int isSellOut,
    int isOffTheShelf,
    List<Tag> tag,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (goodsName == null || identical(goodsName, this.goodsName)) &&
        (goodsPicture == null || identical(goodsPicture, this.goodsPicture)) &&
        (discount == null || identical(discount, this.discount)) &&
        (description == null || identical(description, this.description)) &&
        (originalPrice == null ||
            identical(originalPrice, this.originalPrice)) &&
        (originalPriceStr == null ||
            identical(originalPriceStr, this.originalPriceStr)) &&
        (currentPrice == null || identical(currentPrice, this.currentPrice)) &&
        (currentPriceStr == null ||
            identical(currentPriceStr, this.currentPriceStr)) &&
        (picture == null || identical(picture, this.picture)) &&
        (width == null || identical(width, this.width)) &&
        (height == null || identical(height, this.height)) &&
        (interestName == null || identical(interestName, this.interestName)) &&
        (isSellOut == null || identical(isSellOut, this.isSellOut)) &&
        (isOffTheShelf == null ||
            identical(isOffTheShelf, this.isOffTheShelf)) &&
        (tag == null || identical(tag, this.tag))) {
      return this;
    }

    return Goods(
      id: id ?? this.id,
      goodsName: goodsName ?? this.goodsName,
      goodsPicture: goodsPicture ?? this.goodsPicture,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      currentPrice: currentPrice ?? this.currentPrice,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
      picture: picture ?? this.picture,
      width: width ?? this.width,
      height: height ?? this.height,
      interestName: interestName ?? this.interestName,
      isSellOut: isSellOut ?? this.isSellOut,
      isOffTheShelf: isOffTheShelf ?? this.isOffTheShelf,
      tag: tag ?? this.tag,
    );
  }

  @override
  String toString() {
    return 'Goods{id: $id, goodsName: $goodsName, goodsPicture: $goodsPicture, discount: $discount, description: $description, originalPrice: $originalPrice, originalPriceStr: $originalPriceStr, currentPrice: $currentPrice, currentPriceStr: $currentPriceStr, picture: $picture, width: $width, height: $height, interestName: $interestName, isSellOut: $isSellOut, isOffTheShelf: $isOffTheShelf, tag: $tag}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goods &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          goodsName == other.goodsName &&
          goodsPicture == other.goodsPicture &&
          discount == other.discount &&
          description == other.description &&
          originalPrice == other.originalPrice &&
          originalPriceStr == other.originalPriceStr &&
          currentPrice == other.currentPrice &&
          currentPriceStr == other.currentPriceStr &&
          picture == other.picture &&
          width == other.width &&
          height == other.height &&
          interestName == other.interestName &&
          isSellOut == other.isSellOut &&
          isOffTheShelf == other.isOffTheShelf &&
          tag == other.tag);

  @override
  int get hashCode =>
      id.hashCode ^
      goodsName.hashCode ^
      goodsPicture.hashCode ^
      discount.hashCode ^
      description.hashCode ^
      originalPrice.hashCode ^
      originalPriceStr.hashCode ^
      currentPrice.hashCode ^
      currentPriceStr.hashCode ^
      picture.hashCode ^
      width.hashCode ^
      height.hashCode ^
      interestName.hashCode ^
      isSellOut.hashCode ^
      isOffTheShelf.hashCode ^
      tag.hashCode;

  factory Goods.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Goods(
      id: map[keyMapper('id')] as String,
      goodsName: map[keyMapper('goodsName')] as String,
      goodsPicture: map[keyMapper('goodsPicture')] as String,
      discount: map[keyMapper('discount')] as String,
      description: map[keyMapper('description')] as String,
      originalPrice: map[keyMapper('originalPrice')] as int,
      originalPriceStr: map[keyMapper('originalPriceStr')] as String,
      currentPrice: map[keyMapper('currentPrice')] as int,
      currentPriceStr: map[keyMapper('currentPriceStr')] as String,
      picture: map[keyMapper('picture')] as String,
      width: map[keyMapper('width')] as int,
      height: map[keyMapper('height')] as int,
      interestName: map[keyMapper('interestName')] as String,
      isSellOut: map[keyMapper('isSellOut')] as int,
      isOffTheShelf: map[keyMapper('isOffTheShelf')] as int,
      tag: (map[keyMapper('tag')] as List)
          .map((e) => Tag.fromMap((e as Map<String, dynamic>)))
          .toList(),
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
      keyMapper('discount'): this.discount,
      keyMapper('description'): this.description,
      keyMapper('originalPrice'): this.originalPrice,
      keyMapper('originalPriceStr'): this.originalPriceStr,
      keyMapper('currentPrice'): this.currentPrice,
      keyMapper('currentPriceStr'): this.currentPriceStr,
      keyMapper('picture'): this.picture,
      keyMapper('width'): this.width,
      keyMapper('height'): this.height,
      keyMapper('interestName'): this.interestName,
      keyMapper('isSellOut'): this.isSellOut,
      keyMapper('isOffTheShelf'): this.isOffTheShelf,
      keyMapper('tag'): this.tag,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
