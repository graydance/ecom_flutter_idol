import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Upload {
  final List<UploadedFile> list;

  const Upload({
    this.list = const [],
  });

  Upload copyWith({
    List<UploadedFile> list,
  }) {
    return Upload(
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'list': list?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Upload.fromMap(Map<String, dynamic> map) {
    return Upload(
      list: List<UploadedFile>.from(
          map['list']?.map((x) => UploadedFile.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Upload.fromJson(String source) => Upload.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Upload && listEquals(other.list, list);
  }

  @override
  int get hashCode => list.hashCode;

  @override
  String toString() => 'Upload(list: $list)';
}

@immutable
class UploadedFile {
  final String name;
  final int size;
  final String url;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const UploadedFile({
    this.name,
    this.size,
    this.url,
  });

  UploadedFile copyWith({
    String name,
    int size,
    String url,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (size == null || identical(size, this.size)) &&
        (url == null || identical(url, this.url))) {
      return this;
    }

    return UploadedFile(
      name: name ?? this.name,
      size: size ?? this.size,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    return 'UploadFile{name: $name, size: $size, url: $url}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UploadedFile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          size == other.size &&
          url == other.url);

  @override
  int get hashCode => name.hashCode ^ size.hashCode ^ url.hashCode;

  factory UploadedFile.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return UploadedFile(
      name: map[keyMapper('name')] as String,
      size: map[keyMapper('size')] as int,
      url: map[keyMapper('url')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('name'): this.name,
      keyMapper('size'): this.size,
      keyMapper('url'): this.url,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
