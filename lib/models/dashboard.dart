import 'package:flutter/material.dart';

@immutable
class Dashboard {
  final int availableBalance;
  final int lifetimeEarnings;
  final List<Reward> rewardList;
  final List<PastSales> pastSales;

  const Dashboard({
    this.availableBalance = 0,
    this.lifetimeEarnings = 0,
    this.rewardList = const [],
    this.pastSales = const [],
  });

  Dashboard copyWith({
    int availableBalance,
    int lifetimeEarnings,
    String monetaryCountry,
    String monetaryUnit,
    List<Reward> rewardList,
    List<PastSales> pastSales,
  }) {
    if ((availableBalance == null ||
            identical(availableBalance, this.availableBalance)) &&
        (lifetimeEarnings == null ||
            identical(lifetimeEarnings, this.lifetimeEarnings)) &&
        (rewardList == null || identical(rewardList, this.rewardList)) &&
        (pastSales == null || identical(pastSales, this.pastSales))) {
      return this;
    }

    return Dashboard(
      availableBalance: availableBalance ?? this.availableBalance,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
      rewardList: rewardList ?? this.rewardList,
      pastSales: pastSales ?? this.pastSales,
    );
  }

  @override
  String toString() {
    return 'Dashboard{availableBalance: $availableBalance, lifetimeEarnings: $lifetimeEarnings, rewardList: $rewardList, pastSales: $pastSales}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dashboard &&
          runtimeType == other.runtimeType &&
          availableBalance == other.availableBalance &&
          lifetimeEarnings == other.lifetimeEarnings &&
          rewardList == other.rewardList &&
          pastSales == other.pastSales);

  @override
  int get hashCode =>
      availableBalance.hashCode ^
      lifetimeEarnings.hashCode ^
      rewardList.hashCode ^
      pastSales.hashCode;

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      availableBalance: map['availableBalance'] ?? 0,
      lifetimeEarnings: map['lifetimeEarnings'] ?? 0,
      rewardList: map['rewardList'] != null
          ? _convertRewardListJson(map['rewardList'])
          : const [],
      pastSales: map['pastSales'] != null
          ? _convertPastSalesListJson(map['pastSales'])
          : const [],
    );
  }

  static List<Reward> _convertRewardListJson(List<dynamic> rewardListJson) {
    List<Reward> rewardList = <Reward>[];
    rewardListJson.forEach((value) {
      rewardList.add(Reward.fromMap(value));
    });
    return rewardList;
  }

  static List<PastSales> _convertPastSalesListJson(
      List<dynamic> pastSalesJson) {
    List<PastSales> pastSales = <PastSales>[];
    pastSalesJson.forEach((value) {
      pastSales.add(PastSales.fromMap(value));
    });
    return pastSales;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableBalance'] = this.availableBalance;
    data['lifetimeEarnings'] = this.lifetimeEarnings;
    if (this.rewardList != null) {
      data['rewardList'] = this.rewardList.map((v) => v.toMap()).toList();
    }
    if (this.pastSales != null) {
      data['pastSales'] = this.pastSales.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

@immutable
class Reward {
  final String id;
  final int rewardStatus;
  final String rewardTitle;
  final String rewardDescription;
  final int rewardCoins;
  final String rewardCoinsStr;
  final String monetaryCountry;
  final String monetaryUnit;
  final String progress;

//<editor-fold desc="Data Methods" defaultstate="collapsed">
  const Reward(
      {this.id,
      this.rewardStatus = -1,
      this.rewardTitle = '',
      this.rewardDescription = '',
      this.rewardCoins = 0,
      this.rewardCoinsStr = '',
      this.monetaryCountry = 'USD',
      this.monetaryUnit = '\$',
      this.progress = ''});

  Reward copyWith({
    String id,
    int rewardStatus,
    String rewardTitle,
    String rewardDescription,
    int rewardCoins,
    String rewardCoinsStr,
    String monetaryCountry,
    String monetaryUnit,
    String progress,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (rewardStatus == null || identical(rewardStatus, this.rewardStatus)) &&
        (rewardTitle == null || identical(rewardTitle, this.rewardTitle)) &&
        (rewardDescription == null ||
            identical(rewardDescription, this.rewardDescription)) &&
        (rewardCoins == null || identical(rewardCoins, this.rewardCoins)) &&
        (rewardCoinsStr == null ||
            identical(rewardCoinsStr, this.rewardCoinsStr)) &&
        (monetaryCountry == null ||
            identical(monetaryCountry, this.monetaryCountry)) &&
        (monetaryUnit == null || identical(monetaryUnit, this.monetaryUnit)) &&
        (progress == null || identical(progress, this.progress))) {
      return this;
    }

    return Reward(
      id: id ?? this.id,
      rewardStatus: rewardStatus ?? this.rewardStatus,
      rewardTitle: rewardTitle ?? this.rewardTitle,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardCoinsStr: rewardCoinsStr ?? this.rewardCoinsStr,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
      progress: progress ?? this.progress,
    );
  }

  @override
  String toString() {
    return 'Reward{id: $id, rewardStatus: $rewardStatus, rewardTitle: $rewardTitle, rewardDescription: $rewardDescription, rewardCoins: $rewardCoins, rewardCoinsStr: $rewardCoinsStr, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit, progress: $progress}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reward &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rewardStatus == other.rewardStatus &&
          rewardTitle == other.rewardTitle &&
          rewardDescription == other.rewardDescription &&
          rewardCoins == other.rewardCoins &&
          rewardCoinsStr == other.rewardCoinsStr &&
          monetaryCountry == other.monetaryCountry &&
          monetaryUnit == other.monetaryUnit &&
          progress == other.progress);

  @override
  int get hashCode =>
      id.hashCode ^
      rewardStatus.hashCode ^
      rewardTitle.hashCode ^
      rewardDescription.hashCode ^
      rewardCoins.hashCode ^
      rewardCoinsStr.hashCode ^
      monetaryCountry.hashCode ^
      monetaryUnit.hashCode ^
      progress.hashCode;

  factory Reward.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return Reward(
      id: map[keyMapper('id')] as String,
      rewardStatus: map[keyMapper('rewardStatus')] as int,
      rewardTitle: map[keyMapper('rewardTitle')] as String,
      rewardDescription: map[keyMapper('rewardDescription')] as String,
      rewardCoins: map[keyMapper('rewardCoins')] as int,
      rewardCoinsStr: map[keyMapper('rewardCoinsStr')] as String,
      monetaryCountry: map[keyMapper('monetaryCountry')] as String,
      monetaryUnit: map[keyMapper('monetaryUnit')] as String,
      progress: map[keyMapper('progress')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('id'): this.id,
      keyMapper('rewardStatus'): this.rewardStatus,
      keyMapper('rewardTitle'): this.rewardTitle,
      keyMapper('rewardDescription'): this.rewardDescription,
      keyMapper('rewardCoins'): this.rewardCoins,
      keyMapper('rewardCoinsStr'): this.rewardCoinsStr,
      keyMapper('monetaryCountry'): this.monetaryCountry,
      keyMapper('monetaryUnit'): this.monetaryUnit,
      keyMapper('progress'): this.progress,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class PastSales {
  final String date;
  final int monthSales;
  final String monthSalesStr;
  final List<String> dailySales;

  const PastSales({
    this.date = '',
    this.monthSales = 0,
    this.monthSalesStr,
    this.dailySales = const [],
  });

  PastSales copyWith({
    String date,
    int monthSales,
    String monthSalesStr,
    List<String> dailySales,
  }) {
    if ((date == null || identical(date, this.date)) &&
        (monthSales == null || identical(monthSales, this.monthSales)) &&
        (monthSalesStr == null ||
            identical(monthSalesStr, this.monthSalesStr)) &&
        (dailySales == null || identical(dailySales, this.dailySales))) {
      return this;
    }

    return PastSales(
      date: date ?? this.date,
      monthSales: monthSales ?? this.monthSales,
      monthSalesStr: monthSalesStr ?? this.monthSalesStr,
      dailySales: dailySales ?? this.dailySales,
    );
  }

  factory PastSales.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return PastSales(
      date: map[keyMapper('date')] as String,
      monthSales: map[keyMapper('monthSales')] as int,
      monthSalesStr: map[keyMapper('monthSalesStr')] as String,
      dailySales: map['dailySales'] == null
          ? const []
          : map['dailySales'].cast<String>(),
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('date'): this.date,
      keyMapper('monthSales'): this.monthSales,
      keyMapper('monthSalesStr'): this.monthSalesStr,
      keyMapper('dailySales'): this.dailySales,
    } as Map<String, dynamic>;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastSales &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          monthSales == other.monthSales &&
          monthSalesStr == other.monthSalesStr &&
          dailySales == other.dailySales;

  @override
  int get hashCode =>
      date.hashCode ^
      monthSales.hashCode ^
      monthSalesStr.hashCode ^
      dailySales.hashCode;
}
