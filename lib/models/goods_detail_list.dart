import 'package:flutter/material.dart';
import 'package:idol/models/goods_detail.dart';

@immutable
class GoodsDetailList {
  final int totalPage;
  final int currentPage;
  final List<GoodsDetail> list;

  const GoodsDetailList({
    this.totalPage,
    this.currentPage,
    this.list,
  });

  GoodsDetailList copyWith({
    int totalPage,
    int currentPage,
    List<GoodsDetail> list,
  }) {
    if ((totalPage == null || identical(totalPage, this.totalPage)) &&
        (currentPage == null || identical(currentPage, this.currentPage)) &&
        (list == null || identical(list, this.list))) {
      return this;
    }

    return GoodsDetailList(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'GoodsDetailList{totalPage: $totalPage, currentPage: $currentPage, list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsDetailList &&
          runtimeType == other.runtimeType &&
          totalPage == other.totalPage &&
          currentPage == other.currentPage &&
          list == other.list);

  @override
  int get hashCode => totalPage.hashCode ^ currentPage.hashCode ^ list.hashCode;

  factory GoodsDetailList.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return GoodsDetailList(
      totalPage: map[keyMapper('totalPage')] as int,
      currentPage: map[keyMapper('currentPage')] as int,
      list: map[keyMapper('list')] != null
                ? (map[keyMapper('list')] as List).map((e) => GoodsDetail.fromMap(e as Map<String, dynamic>)).toList()
                : const [],
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