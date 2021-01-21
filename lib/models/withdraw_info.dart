import 'package:flutter/material.dart';

/// availableBalance : 100
/// lifetimeEarnings : 90
/// withdraw : 50
/// freeze : 40
/// FAQ : ""
/// withdrawType : [{"id":"1","payName":"提现方式的名称","portrait":"图标","serviceFee":3}]
@immutable
class WithdrawInfo {
  final int availableBalance;
  final int lifetimeEarnings;
  final int withdraw;
  final int freeze;
  final String faq;
  final List<WithdrawType> withdrawType;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const WithdrawInfo({
    this.availableBalance = 0,
    this.lifetimeEarnings = 0,
    this.withdraw = 0,
    this.freeze = 0,
    this.faq = '',
    this.withdrawType = const [],
  });

  WithdrawInfo copyWith({
    int availableBalance,
    int lifetimeEarnings,
    String monetaryCountry,
    String monetaryUnit,
    int withdraw,
    int freeze,
    String faq,
    List<WithdrawType> withdrawType,
  }) {
    if ((availableBalance == null ||
            identical(availableBalance, this.availableBalance)) &&
        (lifetimeEarnings == null ||
            identical(lifetimeEarnings, this.lifetimeEarnings)) &&
        (withdraw == null || identical(withdraw, this.withdraw)) &&
        (freeze == null || identical(freeze, this.freeze)) &&
        (faq == null || identical(faq, this.faq)) &&
        (withdrawType == null || identical(withdrawType, this.withdrawType))) {
      return this;
    }

    return WithdrawInfo(
      availableBalance: availableBalance ?? this.availableBalance,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
      withdraw: withdraw ?? this.withdraw,
      freeze: freeze ?? this.freeze,
      faq: faq ?? this.faq,
      withdrawType: withdrawType ?? this.withdrawType,
    );
  }

  @override
  String toString() {
    return 'WithdrawInfo{availableBalance: $availableBalance, lifetimeEarnings: $lifetimeEarnings, withdraw: $withdraw, freeze: $freeze, faq: $faq, withdrawType: $withdrawType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithdrawInfo &&
          runtimeType == other.runtimeType &&
          availableBalance == other.availableBalance &&
          lifetimeEarnings == other.lifetimeEarnings &&
          withdraw == other.withdraw &&
          freeze == other.freeze &&
          faq == other.faq &&
          withdrawType == other.withdrawType);

  @override
  int get hashCode =>
      availableBalance.hashCode ^
      lifetimeEarnings.hashCode ^
      withdraw.hashCode ^
      freeze.hashCode ^
      faq.hashCode ^
      withdrawType.hashCode;

  factory WithdrawInfo.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return WithdrawInfo(
      availableBalance: map[keyMapper('availableBalance')] ?? 0,
      lifetimeEarnings: map[keyMapper('lifetimeEarnings')] ?? 0,
      withdraw: map[keyMapper('withdraw')] ?? 0,
      freeze: map[keyMapper('freeze')] ?? 0,
      faq: map[keyMapper('faq')] ?? '',
      withdrawType: map[keyMapper('withdrawType')] != null
          ? _convertWithdrawTypeListJson(map[keyMapper('withdrawType')])
          : const [],
    );
  }

  static List<WithdrawType> _convertWithdrawTypeListJson(
      List<dynamic> withdrawTypeListJson) {
    List<WithdrawType> withdrawTypeList = <WithdrawType>[];
    withdrawTypeListJson.forEach((value) {
      withdrawTypeList.add(WithdrawType.fromMap(value));
    });
    return withdrawTypeList;
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('availableBalance'): this.availableBalance,
      keyMapper('lifetimeEarnings'): this.lifetimeEarnings,
      keyMapper('withdraw'): this.withdraw,
      keyMapper('freeze'): this.freeze,
      keyMapper('faq'): this.faq,
      keyMapper('withdrawType'): this.withdrawType,
    } as Map<String, dynamic>;
  }

//</editor-fold>
}

/// id : "1"
/// payName : "提现方式的名称"
/// portrait : "图标"
/// serviceFee : 3
@immutable
class WithdrawType {
  final String id;
  final String payName;
  final String portrait;
  final int serviceFee;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["payName"] = payName;
    map["portrait"] = portrait;
    map["serviceFee"] = serviceFee;
    return map;
  }

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const WithdrawType({
    this.id = '',
    this.payName = '',
    this.portrait = '',
    this.serviceFee = 0,
  });

  WithdrawType copyWith({
    String id,
    String payName,
    String portrait,
    int serviceFee,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (payName == null || identical(payName, this.payName)) &&
        (portrait == null || identical(portrait, this.portrait)) &&
        (serviceFee == null || identical(serviceFee, this.serviceFee))) {
      return this;
    }

    return WithdrawType(
      id: id ?? this.id,
      payName: payName ?? this.payName,
      portrait: portrait ?? this.portrait,
      serviceFee: serviceFee ?? this.serviceFee,
    );
  }

  @override
  String toString() {
    return 'WithdrawType{id: $id, payName: $payName, portrait: $portrait, serviceFee: $serviceFee}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithdrawType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          payName == other.payName &&
          portrait == other.portrait &&
          serviceFee == other.serviceFee);

  @override
  int get hashCode =>
      id.hashCode ^ payName.hashCode ^ portrait.hashCode ^ serviceFee.hashCode;

  factory WithdrawType.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return WithdrawType(
      id: map[keyMapper('id')] ?? '',
      payName: map[keyMapper('payName')] ?? '',
      portrait: map[keyMapper('portrait')] ?? '',
      serviceFee: map[keyMapper('serviceFee')] ?? 0,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('payName'): this.payName,
      keyMapper('portrait'): this.portrait,
      keyMapper('serviceFee'): this.serviceFee,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
