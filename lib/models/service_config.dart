import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ServiceConfig {
  final int id;
  final String icon;
  final String title;
  final String content;

  const ServiceConfig({
    this.id,
    this.icon,
    this.title,
    this.content,
  });

  ServiceConfig copyWith({
    int id,
    String icon,
    String title,
    String content,
  }) {
    return ServiceConfig(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'content': content,
    };
  }

  factory ServiceConfig.fromMap(Map<String, dynamic> map) {
    return ServiceConfig(
      id: map['id'],
      icon: map['icon'],
      title: map['title'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceConfig.fromJson(String source) =>
      ServiceConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceConfig(id: $id, icon: $icon, title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceConfig &&
        other.id == id &&
        other.icon == icon &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^ icon.hashCode ^ title.hashCode ^ content.hashCode;
  }
}
