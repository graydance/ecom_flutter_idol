import 'package:flutter/material.dart';

@immutable
class Upload {
  final List<UploadedFile> list;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Upload({
    this.list,
  });

  Upload copyWith({
    List<UploadedFile> list,
  }) {
    if ((list == null || identical(list, this.list))) {
      return this;
    }

    return Upload(
      list: list ?? this.list,
    );
  }

  @override
  String toString() {
    return 'Upload{list: $list}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Upload &&
          runtimeType == other.runtimeType &&
          list == other.list);

  @override
  int get hashCode => list.hashCode;

  factory Upload.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Upload(
      list: map[keyMapper('list')] != null ?  _convertUploadedFile(map[keyMapper('list')]): const [],
    );
  }

  static List<UploadedFile> _convertUploadedFile(List<dynamic> uploadedFileListJson) {
    List<UploadedFile> uploadedFileList = <UploadedFile>[];
    uploadedFileListJson.forEach((value) {
      uploadedFileList.add(UploadedFile.fromMap(value));
    });
    return uploadedFileList;
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('list'): this.list,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class UploadedFile{
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