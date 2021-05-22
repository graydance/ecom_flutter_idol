import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ExpressTemplete {
  final int id;
  final String name;
  final int min;
  final int max;
  final String price;

  const ExpressTemplete({
    this.id = 0,
    this.name = '',
    this.min = 0,
    this.max = 0,
    this.price = '',
  });

  ExpressTemplete copyWith({
    int id,
    String name,
    int min,
    int max,
    String price,
  }) {
    return ExpressTemplete(
      id: id ?? this.id,
      name: name ?? this.name,
      min: min ?? this.min,
      max: max ?? this.max,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'min': min,
      'max': max,
      'price': price,
    };
  }

  factory ExpressTemplete.fromMap(Map<String, dynamic> map) {
    return ExpressTemplete(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      min: map['min'] ?? 0,
      max: map['max'] ?? 0,
      price: map['price'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressTemplete.fromJson(String source) =>
      ExpressTemplete.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExpressTemplete(id: $id, name: $name, min: $min, max: $max, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpressTemplete &&
        other.id == id &&
        other.name == name &&
        other.min == min &&
        other.max == max &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        min.hashCode ^
        max.hashCode ^
        price.hashCode;
  }
}
