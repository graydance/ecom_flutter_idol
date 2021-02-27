import 'package:flutter/material.dart';

/// list : [{"id":"link 的id","linkName":"link 名称","linkUrl":"link 的地址","linkIcon":"link 的图标","linkClick":100,"istop":0,"isPrivate":0}]
/// icon : [{"id":"icon id","iconUrl":"icon 地址"}]
@immutable
class BioLinks {
  final List<BioLink> list;
  final List<LinkIcon> icon;

  const BioLinks({
      this.list = const [],
      this.icon = const []});

  factory BioLinks.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return BioLinks(
      list: (map[keyMapper('list')] as List).map((e) => BioLink.fromMap(e as Map<String, dynamic>)).toList(),
      icon: (map[keyMapper('icon')] as List).map((e) => LinkIcon.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('list'): this.list,
      keyMapper('icon'): this.icon,
    };
  }
}

/// id : "icon id"
/// iconUrl : "icon 地址"
@immutable
class LinkIcon {
  final String id;
  final String iconUrl;

  const LinkIcon({
      this.id = '',
      this.iconUrl = ''});

  factory LinkIcon.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return LinkIcon(
      id: map[keyMapper('id')] as String,
      iconUrl: map[keyMapper('iconUrl')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('id'): this.id,
      keyMapper('iconUrl'): this.iconUrl,
    };
  }
}

/// id : "link 的id"
/// linkName : "link 名称"
/// linkUrl : "link 的地址"
/// linkIcon : "link 的图标"
/// linkClick : 100
/// istop : 0
/// isPrivate : 0

@immutable
class BioLink {
  final String id;
  final String linkName;
  final String linkUrl;
  final String linkIcon;
  final int linkClick;
  final int isTop;
  final int isPrivate;

  const BioLink({
      this.id = '',
      this.linkName = '',
      this.linkUrl = '',
      this.linkIcon = '',
      this.linkClick = 0,
      this.isTop = 0,
      this.isPrivate = 0});

  factory BioLink.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return BioLink(
      id: map[keyMapper('id')] as String,
      linkName: map[keyMapper('linkName')] as String,
      linkUrl: map[keyMapper('linkUrl')] as String,
      linkIcon: map[keyMapper('linkIcon')] as String,
      linkClick: map[keyMapper('linkClick')] as int,
      isTop: map[keyMapper('isTop')] as int,
      isPrivate: map[keyMapper('isPrivate')] as int,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('linkName'): this.linkName,
      keyMapper('linkUrl'): this.linkUrl,
      keyMapper('linkIcon'): this.linkIcon,
      keyMapper('linkClick'): this.linkClick,
      keyMapper('isTop'): this.isTop,
      keyMapper('isPrivate'): this.isPrivate,
    } as Map<String, dynamic>;
  }
}