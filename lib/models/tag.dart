import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Tag {
  final String id;
  final String name;
  final String interestName;
  final String interestPortrait;
  final String interestDescription;
  final int interestType;
  final String color;

  const Tag({
    this.id = '',
    this.name = '',
    this.interestName = '',
    this.interestPortrait = '',
    this.interestDescription = '',
    this.interestType = 0,
    this.color = '',
  });

  Tag copyWith({
    String id,
    String name,
    String interestName,
    String interestPortrait,
    String interestDescription,
    int interestType,
    String color,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
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
      name: name ?? this.name,
      interestName: interestName ?? this.interestName,
      interestPortrait: interestPortrait ?? this.interestPortrait,
      interestDescription: interestDescription ?? this.interestDescription,
      interestType: interestType ?? this.interestType,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, interestName: $interestName, interestPortrait: $interestPortrait, interestDescription: $interestDescription, interestType: $interestType, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
        other.id == id &&
        other.name == name &&
        other.interestName == interestName &&
        other.interestPortrait == interestPortrait &&
        other.interestDescription == interestDescription &&
        other.interestType == interestType &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        interestName.hashCode ^
        interestPortrait.hashCode ^
        interestDescription.hashCode ^
        interestType.hashCode ^
        color.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'interestName': interestName,
      'interestPortrait': interestPortrait,
      'interestDescription': interestDescription,
      'interestType': interestType,
      'color': color,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      interestName: map['interestName'],
      interestPortrait: map['interestPortrait'],
      interestDescription: map['interestDescription'],
      interestType: map['interestType'],
      color: map['color'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));
}
