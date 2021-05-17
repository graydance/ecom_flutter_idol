import 'package:flutter/material.dart';

/// id : "标签id"
/// interestName : "标签名称"
/// interestPortrait : "标签图标"
/// interestDescription : "标签描述"
/// interestType : 0

@immutable
class Tag {
  final String id;
  final String name;
  final String interestName;
  final String interestPortrait;
  final String interestDescription;
  final int interestType;

  const Tag({
    this.id = '',
    this.name = '',
    this.interestName = '',
    this.interestPortrait = '',
    this.interestDescription = '',
    this.interestType = 0,
  });

  Tag copyWith({
    String id,
    String name,
    String interestName,
    String interestPortrait,
    String interestDescription,
    int interestType,
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
    );
  }

  @override
  String toString() {
    return 'Tag{id: $id, name: $name, interestName: $interestName, interestPortrait: $interestPortrait, interestDescription: $interestDescription, interestType: $interestType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          interestName == other.interestName &&
          interestPortrait == other.interestPortrait &&
          interestDescription == other.interestDescription &&
          interestType == other.interestType;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
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
      name: map[keyMapper('name')] as String,
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
      keyMapper('name'): this.name,
      keyMapper('interestName'): this.interestName,
      keyMapper('interestPortrait'): this.interestPortrait,
      keyMapper('interestDescription'): this.interestDescription,
      keyMapper('interestType'): this.interestType,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
