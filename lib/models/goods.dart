import 'package:flutter/cupertino.dart';

@immutable
class Goods {
  final String id;
  final String idolName;
  final String idolAvatar;
  final String name;
  final String media;
  final String description;
  final List<String> tags;
  final double originPrice;
  final double price;

  Goods(this.id, this.idolName, this.idolAvatar, this.name, this.media,
      this.description, this.tags, this.originPrice, this.price);

  Goods copyWith(
      {bool following,
      String id,
      String name,
      String description,
      String avatar}) {
    return Goods(
      id ?? this.id,
      idolName ?? this.idolName,
      idolAvatar ?? this.idolAvatar,
      name ?? this.name,
      media ?? this.media,
      description ?? this.description,
      tags ?? this.tags,
      originPrice ?? this.originPrice,
      price ?? this.price,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      idolName.hashCode ^
      idolAvatar.hashCode ^
      name.hashCode ^
      media.hashCode ^
      description.hashCode ^
      tags.hashCode ^
      originPrice.hashCode ^
      price.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goods &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          idolName == other.idolName &&
          idolAvatar == other.idolAvatar &&
          name == other.name &&
          media == other.media &&
          description == other.description &&
          tags == other.tags &&
          originPrice == other.originPrice &&
          price == other.price;

  @override
  String toString() {
    return 'Goods{id: $id, idolName: $idolName, idolAvatar: $idolAvatar name: $name media: $media description: $description tags: $tags originPrice: $originPrice price: $price}';
  }
}
