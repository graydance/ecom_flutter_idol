import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryList {
  final List<GoodsCategory> categoryList;

  const CategoryList({
    this.categoryList = const [],
  });

  CategoryList copyWith({
    List<GoodsCategory> categoryList,
  }) {
    return CategoryList(
      categoryList: categoryList ?? this.categoryList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryList': categoryList?.map((x) => x.toMap())?.toList(),
    };
  }

  factory CategoryList.fromMap(Map<String, dynamic> map) {
    return CategoryList(
      categoryList: List<GoodsCategory>.from(
              map['categoryList']?.map((x) => GoodsCategory.fromMap(x))) ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryList.fromJson(String source) =>
      CategoryList.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryList(categoryList: $categoryList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryList &&
        listEquals(other.categoryList, categoryList);
  }

  @override
  int get hashCode => categoryList.hashCode;
}

@immutable
class GoodsCategory {
  final int id;
  final String name;
  final List<GoodsCategory> childrenList;

  const GoodsCategory({
    this.id = 0,
    this.name = '',
    this.childrenList = const [],
  });

  GoodsCategory copyWith({
    int id,
    String name,
    List<GoodsCategory> childrenList,
  }) {
    return GoodsCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      childrenList: childrenList ?? this.childrenList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'childrenList': childrenList?.map((x) => x.toMap())?.toList(),
    };
  }

  factory GoodsCategory.fromMap(Map<String, dynamic> map) {
    return GoodsCategory(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
      childrenList: map['childrenList'] != null
          ? List<GoodsCategory>.from(
                  map['childrenList']?.map((x) => GoodsCategory.fromMap(x))) ??
              []
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsCategory.fromJson(String source) =>
      GoodsCategory.fromMap(json.decode(source));

  @override
  String toString() =>
      'GoodsCategory(id: $id, name: $name, childrenList: $childrenList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoodsCategory &&
        other.id == id &&
        other.name == name &&
        listEquals(other.childrenList, childrenList);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ childrenList.hashCode;
}
