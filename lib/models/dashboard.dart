import 'package:flutter/material.dart';

@immutable
class Dashboard {
  final bool isLoaded;
  final int availableBalance;
  final int lifetimeEarnings;
  final String monetaryCountry;
  final String monetaryUnit;
  final List<Reward> rewardList;
  final List<PastSales> pastSales;

  const Dashboard({
    this.isLoaded = false,
    this.availableBalance = 0,
    this.lifetimeEarnings = 0,
    this.monetaryCountry = 'USD',
    this.monetaryUnit = '\$',
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
        (monetaryCountry == null ||
            identical(monetaryCountry, this.monetaryCountry)) &&
        (monetaryUnit == null || identical(monetaryUnit, this.monetaryUnit)) &&
        (rewardList == null || identical(rewardList, this.rewardList)) &&
        (pastSales == null || identical(pastSales, this.pastSales))) {
      return this;
    }

    return Dashboard(
      availableBalance: availableBalance ?? this.availableBalance,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      rewardList: rewardList ?? this.rewardList,
      pastSales: pastSales ?? this.pastSales,
    );
  }

  @override
  String toString() {
    return 'Dashboard{availableBalance: $availableBalance, lifetimeEarnings: $lifetimeEarnings, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit, rewardList: $rewardList, pastSales: $pastSales}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dashboard &&
          runtimeType == other.runtimeType &&
          availableBalance == other.availableBalance &&
          lifetimeEarnings == other.lifetimeEarnings &&
          monetaryCountry == other.monetaryCountry &&
          monetaryUnit == other.monetaryUnit &&
          rewardList == other.rewardList &&
          pastSales == other.pastSales);

  @override
  int get hashCode =>
      availableBalance.hashCode ^
      lifetimeEarnings.hashCode ^
      monetaryCountry.hashCode ^
      monetaryUnit.hashCode ^
      rewardList.hashCode ^
      pastSales.hashCode;

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      isLoaded: true,
      availableBalance: map['availableBalance'] ?? 0,
      lifetimeEarnings: map['lifetimeEarnings'] ?? 0,
      monetaryCountry: map['monetaryCountry'] ?? 'USD',
      monetaryUnit: map['monetaryUnit'] ?? '\$',
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
      pastSales.add(PastSales.fromJson(value));
    });
    return pastSales;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableBalance'] = this.availableBalance;
    data['lifetimeEarnings'] = this.lifetimeEarnings;
    data['monetaryCountry'] = this.monetaryCountry;
    data['monetaryUnit'] = this.monetaryUnit;
    if (this.rewardList != null) {
      data['rewardList'] = this.rewardList.map((v) => v.toMap()).toList();
    }
    if (this.pastSales != null) {
      data['pastSales'] = this.pastSales.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@immutable
class Reward {
  final int rewardStatus;
  final String rewardTitle;
  final String rewardDescription;
  final int rewardCoins;
  final String monetaryCountry;
  final String monetaryUnit;

  const Reward(
      {this.rewardStatus = -1,
      this.rewardTitle = '',
      this.rewardDescription = '',
      this.rewardCoins = 0,
      this.monetaryCountry = 'USD',
      this.monetaryUnit = '\$'});

  Reward copyWith(
      {int rewardStatus,
      String rewardTitle,
      String rewardDescription,
      String rewardCoins,
      String monetaryCountry,
      String monetaryUnit}) {
    return Reward(
      rewardStatus: rewardStatus ?? this.rewardStatus,
      rewardTitle: rewardTitle ?? this.rewardTitle,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
    );
  }

  @override
  String toString() {
    return 'Reward{rewardStatus: $rewardStatus, rewardTitle: $rewardTitle, rewardDescription: $rewardDescription, rewardCoins: $rewardCoins, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reward &&
          runtimeType == other.runtimeType &&
          rewardStatus == other.rewardStatus &&
          rewardTitle == other.rewardTitle &&
          rewardDescription == other.rewardDescription &&
          rewardCoins == other.rewardCoins &&
          monetaryCountry == other.monetaryCountry &&
          monetaryUnit == other.monetaryUnit);

  @override
  int get hashCode =>
      rewardStatus.hashCode ^
      rewardTitle.hashCode ^
      rewardDescription.hashCode ^
      rewardCoins.hashCode ^
      monetaryCountry.hashCode ^
      monetaryUnit.hashCode;

  factory Reward.fromMap(Map<String, dynamic> json) {
    return Reward(
      rewardStatus: json['rewardStatus'] ?? -1,
      rewardTitle: json['rewardTitle'] ?? '',
      rewardDescription: json['rewardDescription'] ?? '',
      rewardCoins: json['rewardCoins'] ?? 0,
      monetaryCountry: json['monetaryCountry'] ?? 'USD',
      monetaryUnit: json['monetaryUnit'] ?? '\$',
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rewardStatus'] = this.rewardStatus;
    data['rewardTitle'] = this.rewardTitle;
    data['rewardDescription'] = this.rewardDescription;
    data['rewardCoins'] = this.rewardCoins;
    data['monetaryCountry'] = this.monetaryCountry;
    data['monetaryUnit'] = this.monetaryUnit;
    return data;
  }
}

@immutable
class PastSales {
  final String date;
  final String monetaryCountry;
  final String monetaryUnit;
  final int monthSales;
  final List<int> dailySales;

  const PastSales({
    this.date = '',
    this.monetaryCountry = 'USD',
    this.monetaryUnit = '\$',
    this.monthSales = 0,
    this.dailySales = const [],
  });

  PastSales copyWith({
    String date,
    String monetaryCountry,
    String monetaryUnit,
    int monthSales,
    List<int> dailySales,
  }) {
    return PastSales(
      date: date ?? this.date,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
      monthSales: monthSales ?? this.monthSales,
      dailySales: dailySales ?? this.dailySales,
    );
  }

  @override
  String toString() {
    return 'PastSales{date: $date, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit, monthSales: $monthSales, dailySales: $dailySales}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PastSales &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          monetaryCountry == other.monetaryCountry &&
          monetaryUnit == other.monetaryUnit &&
          monthSales == other.monthSales &&
          dailySales == other.dailySales);

  @override
  int get hashCode =>
      date.hashCode ^
      monetaryCountry.hashCode ^
      monetaryUnit.hashCode ^
      monthSales.hashCode ^
      dailySales.hashCode;

  factory PastSales.fromJson(Map<String, dynamic> json) {
    return PastSales(
        date: json['date'],
        monetaryCountry: json['monetaryCountry'] ?? 'USD',
        monetaryUnit: json['monetaryUnit'] ?? '\$',
        monthSales: json['monthSales'] ?? 0,
        dailySales: json['dailySales'] == null ? const [] : json['dailySales'].cast<int>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['monetaryCountry'] = this.monetaryCountry;
    data['monetaryUnit'] = this.monetaryUnit;
    data['monthSales'] = this.monthSales;
    data['dailySales'] = this.dailySales;
    return data;
  }
}
