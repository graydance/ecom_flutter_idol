import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:idol/models/spec_values.dart';

@immutable
class GoodsSpec {
  final int id;
  final String specName;
  final String createdAt;
  final String updatedAt;
  final List<SpecValues> specValues;

  const GoodsSpec({
    this.id = 0,
    this.specName = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.specValues = const [],
  });

  GoodsSpec copyWith({
    int id,
    String specName,
    String createdAt,
    String updatedAt,
    List<SpecValues> specValues,
  }) {
    return GoodsSpec(
      id: id ?? this.id,
      specName: specName ?? this.specName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specValues: specValues ?? this.specValues,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'specName': specName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'specValues': specValues?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory GoodsSpec.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsSpec(
      id: map['id'],
      specName: map['specName'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      specValues: List<SpecValues>.from(
          map['specValues']?.map((x) => SpecValues.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsSpec.fromJson(String source) =>
      GoodsSpec.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GoodsSpec &&
        o.id == id &&
        o.specName == specName &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        listEquals(o.specValues, specValues);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        specName.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        specValues.hashCode;
  }

  @override
  String toString() {
    return 'GoodsSpec(id: $id, specName: $specName, createdAt: $createdAt, updatedAt: $updatedAt, specValues: $specValues)';
  }
}
