import 'package:flutter/material.dart';

@immutable
class GoodsList {
  final int totalPage;
  final int currentPage;
  final List<Goods> list;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GoodsList({
    this.totalPage,
    this.currentPage,
    this.list,
  });

  GoodsList copyWith({
    int totalPage,
    int currentPage,
    List<Goods> list,
  }) {
    if ((totalPage == null || identical(totalPage, this.totalPage)) &&
        (currentPage == null || identical(currentPage, this.currentPage)) &&
        (list == null || identical(list, this.list))) {
      return this;
    }

    return GoodsList(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'GoodsList{totalPage: $totalPage, currentPage: $currentPage, list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsList &&
          runtimeType == other.runtimeType &&
          totalPage == other.totalPage &&
          currentPage == other.currentPage &&
          list == other.list);

  @override
  int get hashCode => totalPage.hashCode ^ currentPage.hashCode ^ list.hashCode;

  factory GoodsList.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return GoodsList(
      totalPage: map[keyMapper('totalPage')] as int,
      currentPage: map[keyMapper('currentPage')] as int,
      list: map[keyMapper('list')] != null ? _convertGoodsJson(map[keyMapper('list')]) : const [],
    );
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

  static List<Goods> _convertGoodsJson(map) {
    List<Goods> goodsList = <Goods>[];
    map.forEach((value) {
      goodsList.add(Goods.fromMap(value));
    });
    return goodsList;
  }

//</editor-fold>

}

@immutable
class Goods {
  final String id;
  final String picture;
  final int width;
  final int height;
  final String interestName;
  // 0 未售罄，1 售罄
  final int isSellOut;
  // 0 未下架，1 下架
  final int isOffTheShelf;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Goods({
    this.id,
    this.picture,
    this.width,
    this.height,
    this.interestName,
    this.isSellOut,
    this.isOffTheShelf,
  });

  Goods copyWith({
    String id,
    String picture,
    int width,
    int height,
    String interestName,
    int isSellOut,
    int isOffTheShelf,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (picture == null || identical(picture, this.picture)) &&
        (width == null || identical(width, this.width)) &&
        (height == null || identical(height, this.height)) &&
        (interestName == null || identical(interestName, this.interestName)) &&
        (isSellOut == null || identical(isSellOut, this.isSellOut)) &&
        (isOffTheShelf == null ||
            identical(isOffTheShelf, this.isOffTheShelf))) {
      return this;
    }

    return Goods(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      width: width ?? this.width,
      height: height ?? this.height,
      interestName: interestName ?? this.interestName,
      isSellOut: isSellOut ?? this.isSellOut,
      isOffTheShelf: isOffTheShelf ?? this.isOffTheShelf,
    );
  }

  @override
  String toString() {
    return 'Goods{id: $id, picture: $picture, width: $width, height: $height, interestName: $interestName, isSellOut: $isSellOut, isOffTheShelf: $isOffTheShelf}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goods &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          picture == other.picture &&
          width == other.width &&
          height == other.height &&
          interestName == other.interestName &&
          isSellOut == other.isSellOut &&
          isOffTheShelf == other.isOffTheShelf);

  @override
  int get hashCode =>
      id.hashCode ^
      picture.hashCode ^
      width.hashCode ^
      height.hashCode ^
      interestName.hashCode ^
      isSellOut.hashCode ^
      isOffTheShelf.hashCode;

  factory Goods.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Goods(
      id: map[keyMapper('id')] as String,
      picture: map[keyMapper('picture')] as String,
      width: map[keyMapper('width')] as int,
      height: map[keyMapper('height')] as int,
      interestName: map[keyMapper('interestName')] as String,
      isSellOut: map[keyMapper('isSellOut')] as int,
      isOffTheShelf: map[keyMapper('isOffTheShelf')] as int,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('picture'): this.picture,
      keyMapper('width'): this.width,
      keyMapper('height'): this.height,
      keyMapper('interestName'): this.interestName,
      keyMapper('isSellOut'): this.isSellOut,
      keyMapper('isOffTheShelf'): this.isOffTheShelf,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
