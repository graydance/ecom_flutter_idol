import 'package:flutter/material.dart';

@immutable
class Supply {
  final int totalPage;
  final int currentPage;
  final List<Product> list;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Supply({
    this.totalPage,
    this.currentPage,
    this.list,
  });

  Supply copyWith({
    int totalPage,
    int currentPage,
    List<Product> list,
  }) {
    if ((totalPage == null || identical(totalPage, this.totalPage)) &&
        (currentPage == null || identical(currentPage, this.currentPage)) &&
        (list == null || identical(list, this.list))) {
      return this;
    }

    return Supply(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'Supply{totalPage: $totalPage, currentPage: $currentPage, list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supply &&
          runtimeType == other.runtimeType &&
          totalPage == other.totalPage &&
          currentPage == other.currentPage &&
          list == other.list);

  @override
  int get hashCode => totalPage.hashCode ^ currentPage.hashCode ^ list.hashCode;

  factory Supply.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Supply(
      totalPage: map[keyMapper('totalPage')] as int,
      currentPage: map[keyMapper('currentPage')] as int,
      list: map[keyMapper('list')] != null
          ? _convertProductListJson(map[keyMapper('list')])
          : const [],
    );
  }

  static List<Product> _convertProductListJson(List<dynamic> productListJson) {
    List<Product> productList = <Product>[];
    productListJson.forEach((value) {
      productList.add(Product.fromMap(value));
    });
    return productList;
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('totalPage'): this.totalPage,
      keyMapper('currentPage'): this.currentPage,
      keyMapper('list'): this.list,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class Product {
  final String id;
  final String userId;
  final String portrait;
  final String nickName;
  final int isFollow;
  final String goodsDescription;
  final int earningPrice;
  final int suggestedPrice;
  final int shoppingCar;
  final int collectNum;
  final List<Tag> tag;
  final List<String> goods;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Product({
    this.id,
    this.userId,
    this.portrait,
    this.nickName,
    this.isFollow,
    this.goodsDescription,
    this.earningPrice,
    this.suggestedPrice,
    this.shoppingCar,
    this.collectNum,
    this.tag,
    this.goods,
  });

  Product copyWith({
    String id,
    String userId,
    String portrait,
    String nickName,
    int isFollow,
    String goodsDescription,
    int earningPrice,
    int suggestedPrice,
    int shoppingCar,
    int collectNum,
    List<Tag> tag,
    List<String> goods,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (userId == null || identical(userId, this.userId)) &&
        (portrait == null || identical(portrait, this.portrait)) &&
        (nickName == null || identical(nickName, this.nickName)) &&
        (isFollow == null || identical(isFollow, this.isFollow)) &&
        (goodsDescription == null ||
            identical(goodsDescription, this.goodsDescription)) &&
        (earningPrice == null || identical(earningPrice, this.earningPrice)) &&
        (suggestedPrice == null ||
            identical(suggestedPrice, this.suggestedPrice)) &&
        (shoppingCar == null || identical(shoppingCar, this.shoppingCar)) &&
        (collectNum == null || identical(collectNum, this.collectNum)) &&
        (tag == null || identical(tag, this.tag)) &&
        (goods == null || identical(goods, this.goods))) {
      return this;
    }

    return Product(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      portrait: portrait ?? this.portrait,
      nickName: nickName ?? this.nickName,
      isFollow: isFollow ?? this.isFollow,
      goodsDescription: goodsDescription ?? this.goodsDescription,
      earningPrice: earningPrice ?? this.earningPrice,
      suggestedPrice: suggestedPrice ?? this.suggestedPrice,
      shoppingCar: shoppingCar ?? this.shoppingCar,
      collectNum: collectNum ?? this.collectNum,
      tag: tag ?? this.tag,
      goods: goods ?? this.goods,
    );
  }

  @override
  String toString() {
    return 'Item{id: $id, userId: $userId, portrait: $portrait, nickName: $nickName, isFollow: $isFollow, goodsDescription: $goodsDescription, earningPrice: $earningPrice, suggestedPrice: $suggestedPrice, shoppingCar: $shoppingCar, collectNum: $collectNum, tag: $tag, goods: $goods}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          portrait == other.portrait &&
          nickName == other.nickName &&
          isFollow == other.isFollow &&
          goodsDescription == other.goodsDescription &&
          earningPrice == other.earningPrice &&
          suggestedPrice == other.suggestedPrice &&
          shoppingCar == other.shoppingCar &&
          collectNum == other.collectNum &&
          tag == other.tag &&
          goods == other.goods);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      portrait.hashCode ^
      nickName.hashCode ^
      isFollow.hashCode ^
      goodsDescription.hashCode ^
      earningPrice.hashCode ^
      suggestedPrice.hashCode ^
      shoppingCar.hashCode ^
      collectNum.hashCode ^
      tag.hashCode ^
      goods.hashCode;

  factory Product.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Product(
      id: map[keyMapper('id')] as String,
      userId: map[keyMapper('userId')] as String,
      portrait: map[keyMapper('portrait')] as String,
      nickName: map[keyMapper('nickName')] as String,
      isFollow: map[keyMapper('isFollow')] as int,
      goodsDescription: map[keyMapper('goodsDescription')] as String,
      earningPrice: map[keyMapper('earningPrice')] as int,
      suggestedPrice: map[keyMapper('suggestedPrice')] as int,
      shoppingCar: map[keyMapper('shoppingCar')] as int,
      collectNum: map[keyMapper('collectNum')] as int,
      tag: map[keyMapper('tag')] != null
          ? _convertTagListJson(map[keyMapper('tag')])
          : const [],
      goods: map[keyMapper('goods')] != null
          ? _convertGoodsJson(map[keyMapper('goods')])
          : const [],
    );
  }

  static List<Tag> _convertTagListJson(List<dynamic> tagListJson) {
    List<Tag> tagList = <Tag>[];
    tagListJson.forEach((value) {
      tagList.add(Tag.fromMap(value));
    });
    return tagList;
  }

  static List<String> _convertGoodsJson(List<dynamic> goodsJson) {
    List<String> goodsList = <String>[];
    goodsJson.forEach((element) {
      goodsList.add(element);
    });
    return goodsList;
    //return goodsJson.map((url) => url + "").toList();
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('userId'): this.userId,
      keyMapper('portrait'): this.portrait,
      keyMapper('nickName'): this.nickName,
      keyMapper('isFollow'): this.isFollow,
      keyMapper('goodsDescription'): this.goodsDescription,
      keyMapper('earningPrice'): this.earningPrice,
      keyMapper('suggestedPrice'): this.suggestedPrice,
      keyMapper('shoppingCar'): this.shoppingCar,
      keyMapper('collectNum'): this.collectNum,
      keyMapper('tag'): this.tag,
      keyMapper('goods'): this.goods,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class Tag {
  final String id;
  final String interestName;
  final String interestPortrait;
  final String interestDescription;
  final int interestType;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Tag({
    this.id,
    this.interestName,
    this.interestPortrait,
    this.interestDescription,
    this.interestType,
  });

  Tag copyWith({
    String id,
    String interestName,
    String interestPortrait,
    String interestDescription,
    int interestType,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (interestName == null || identical(interestName, this.interestName)) &&
        (interestPortrait == null ||
            identical(interestPortrait, this.interestPortrait)) &&
        (interestDescription == null ||
            identical(interestDescription, this.interestDescription)) &&
        (interestType == null || identical(interestType, this.interestType))) {
      return this;
    }

    return Tag(
      id: id ?? this.id,
      interestName: interestName ?? this.interestName,
      interestPortrait: interestPortrait ?? this.interestPortrait,
      interestDescription: interestDescription ?? this.interestDescription,
      interestType: interestType ?? this.interestType,
    );
  }

  @override
  String toString() {
    return 'Tag{id: $id, interestName: $interestName, interestPortrait: $interestPortrait, interestDescription: $interestDescription, interestType: $interestType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          interestName == other.interestName &&
          interestPortrait == other.interestPortrait &&
          interestDescription == other.interestDescription &&
          interestType == other.interestType);

  @override
  int get hashCode =>
      id.hashCode ^
      interestName.hashCode ^
      interestPortrait.hashCode ^
      interestDescription.hashCode ^
      interestType.hashCode;

  factory Tag.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Tag(
      id: map[keyMapper('id')] as String,
      interestName: map[keyMapper('interestName')] as String,
      interestPortrait: map[keyMapper('interestPortrait')] as String,
      interestDescription: map[keyMapper('interestDescription')] as String,
      interestType: map[keyMapper('interestType')] as int,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('interestName'): this.interestName,
      keyMapper('interestPortrait'): this.interestPortrait,
      keyMapper('interestDescription'): this.interestDescription,
      keyMapper('interestType'): this.interestType,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
