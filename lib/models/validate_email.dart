import 'package:flutter/material.dart';

/**
 * 邮箱未传时:
    411, "email is empty!"

    邮箱不在白名单内:
    412, "Not on the whitelist!"

    邮箱在白名单内,邮箱未注册(新用户):
    413, "A new user!"

    邮箱在白名单内,邮箱已注册(老用户):
    414, "Old user!"
 */
@immutable
class ValidateEmail {
  final int status;
  final String msg;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const ValidateEmail({
    this.status,
    this.msg,
  });

  ValidateEmail copyWith({
    int status,
    String msg,
  }) {
    if ((status == null || identical(status, this.status)) &&
        (msg == null || identical(msg, this.msg))) {
      return this;
    }

    return ValidateEmail(
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }

  @override
  String toString() {
    return 'ValidateEmail{status: $status, msg: $msg}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValidateEmail &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          msg == other.msg);

  @override
  int get hashCode => status.hashCode ^ msg.hashCode;

  factory ValidateEmail.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return ValidateEmail(
      status: map[keyMapper('status')] as int,
      msg: map[keyMapper('msg')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('status'): this.status,
      keyMapper('msg'): this.msg,
    };
  }
}
