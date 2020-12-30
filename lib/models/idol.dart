import 'package:flutter/cupertino.dart';

@immutable
class Idol {
  final bool following;
  final String id;
  final String name;
  final String description;
  final String avatar;

  Idol(this.id, this.following, this.name, this.description, this.avatar);

  Idol copyWith(
      {bool following,
      String id,
      String name,
      String description,
      String avatar}) {
    return Idol(id ?? this.id, following ?? this.following, name ?? this.name,
        description ?? this.description, avatar ?? this.avatar);
  }

  @override
  int get hashCode =>
      following.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      avatar.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Idol &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          following == other.following &&
          name == other.name &&
          description == other.description &&
          avatar == other.avatar;

  @override
  String toString() {
    return 'Idol{following: $following, id: $id, name: $name, description: $description avatar: $avatar}';
  }
}
