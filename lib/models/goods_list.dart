import 'package:flutter/material.dart';
import 'package:idol/models/goods.dart';

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
      list: (map[keyMapper('list')] as List).map((e) => Goods.fromMap((e as Map<String, dynamic>))).toList(),
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
//</editor-fold>

}
