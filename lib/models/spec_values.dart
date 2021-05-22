import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class SpecValues {
  final int id;
  final String specValue;
  final String createdAt;
  final String updatedAt;

  const SpecValues({
    this.id = 0,
    this.specValue = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  SpecValues copyWith({
    int id,
    String specValue,
    String createdAt,
    String updatedAt,
  }) {
    return SpecValues(
      id: id ?? this.id,
      specValue: specValue ?? this.specValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'specValue': specValue,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SpecValues.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SpecValues(
      id: map['id'],
      specValue: map['specValue'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecValues.fromJson(String source) =>
      SpecValues.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SpecValues(id: $id, specValue: $specValue, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SpecValues &&
        o.id == id &&
        o.specValue == specValue &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        specValue.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
