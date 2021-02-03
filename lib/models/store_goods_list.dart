import 'package:flutter/material.dart';

/// totalPage : 1
/// currentPage : 1
/// list : [{"id":"eLRGN8Bw","idolGoodsId":"红人商品id","picture":"https://www.baidu.com1","width":1,"height":1,"isSellOut":1,"isOffTheShelf":1},{"id":"OZ8MpEbg","idolGoodsId":"红人商品id","picture":"","width":1,"height":1,"isSellOut":1,"isOffTheShelf":1}]
@immutable
class StoreGoodsList {
  final int totalPage;
  final int currentPage;
  final List<StoreGoods> list;

  const StoreGoodsList({
    this.totalPage,
    this.currentPage,
    this.list,
  });

  StoreGoodsList copyWith({
    int totalPage,
    int currentPage,
    List<StoreGoods> list,
  }) {
    if ((totalPage == null || identical(totalPage, this.totalPage)) &&
        (currentPage == null || identical(currentPage, this.currentPage)) &&
        (list == null || identical(list, this.list))) {
      return this;
    }

    return StoreGoodsList(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'StoreGoodsList{totalPage: $totalPage, currentPage: $currentPage, list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreGoodsList &&
          runtimeType == other.runtimeType &&
          totalPage == other.totalPage &&
          currentPage == other.currentPage &&
          list == other.list);

  @override
  int get hashCode => totalPage.hashCode ^ currentPage.hashCode ^ list.hashCode;

  factory StoreGoodsList.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return StoreGoodsList(
      totalPage: map[keyMapper('totalPage')] as int,
      currentPage: map[keyMapper('currentPage')] as int,
      list: (map[keyMapper('list')] as List)
          .map((e) => StoreGoods.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('totalPage'): this.totalPage,
      keyMapper('currentPage'): this.currentPage,
      keyMapper('list'): this.list,
    };
  }
}

/// id : "eLRGN8Bw"
/// idolGoodsId : "红人商品id"
/// picture : "https://www.baidu.com1"
/// width : 1
/// height : 1
/// isSellOut : 1
/// isOffTheShelf : 1
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

  const StoreGoods(
      {this.id = '',
      this.idolGoodsId = '',
      this.picture = '',
      this.width = 0,
      this.height = 0,
      this.isSellOut = 0,
      this.isOffTheShelf = 0,
      this.interestName = '',
      this.supplierId = ''});

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
    );
  }

  @override
  String toString() {
    return 'StoreGoods{id: $id, idolGoodsId: $idolGoodsId, picture: $picture, width: $width, height: $height, isSellOut: $isSellOut, isOffTheShelf: $isOffTheShelf, interestName: $interestName, supplierId:$supplierId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreGoods &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          idolGoodsId == other.idolGoodsId &&
          picture == other.picture &&
          width == other.width &&
          height == other.height &&
          isSellOut == other.isSellOut &&
          interestName == other.interestName &&
          supplierId == other.supplierId &&
          isOffTheShelf == other.isOffTheShelf);

  @override
  int get hashCode =>
      id.hashCode ^
      idolGoodsId.hashCode ^
      picture.hashCode ^
      width.hashCode ^
      height.hashCode ^
      isSellOut.hashCode ^
      interestName.hashCode ^
      supplierId.hashCode ^
      isOffTheShelf.hashCode;

  factory StoreGoods.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return StoreGoods(
      id: map[keyMapper('id')] as String,
      idolGoodsId: map[keyMapper('idolGoodsId')] as String,
      picture: map[keyMapper('picture')] as String,
      width: map[keyMapper('width')] as int,
      height: map[keyMapper('height')] as int,
      isSellOut: map[keyMapper('isSellOut')] as int,
      interestName: map[keyMapper('interestName')] as String,
      isOffTheShelf: map[keyMapper('isOffTheShelf')] as int,
      supplierId: map[keyMapper('supplierId')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('id'): this.id,
      keyMapper('idolGoodsId'): this.idolGoodsId,
      keyMapper('picture'): this.picture,
      keyMapper('width'): this.width,
      keyMapper('height'): this.height,
      keyMapper('isSellOut'): this.isSellOut,
      keyMapper('interestName'): this.interestName,
      keyMapper('isOffTheShelf'): this.isOffTheShelf,
      keyMapper('supplierId'): this.supplierId,
    };
  }
}
