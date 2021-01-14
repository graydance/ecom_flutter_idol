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
      availableBalance: map['available_balance'] as int,
      lifetimeEarnings: map['lifetime_earnings'] as int,
      monetaryCountry: map['monetary_country'] as String,
      monetaryUnit: map['monetary_unit'] as String,
      rewardList: map['reward_list'] != null
          ? _convertRewardListJson(map['reward_list'])
          : const [],
      pastSales: map['past_sales'] != null
          ? _convertPastSalesListJson(map['past_sales'])
          : const [],
    );
  }

  static List<Reward> _convertRewardListJson(List<dynamic> rewardListJson) {
    List<Reward> rewardList = <Reward>[];
    rewardListJson.forEach((value) {
      rewardList.add(Reward.fromJson(value));
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
    data['available_balance'] = this.availableBalance;
    data['lifetime_earnings'] = this.lifetimeEarnings;
    data['monetary_country'] = this.monetaryCountry;
    data['monetary_unit'] = this.monetaryUnit;
    if (this.rewardList != null) {
      data['reward_list'] = this.rewardList.map((v) => v.toJson()).toList();
    }
    if (this.pastSales != null) {
      data['past_sales'] = this.pastSales.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      rewardStatus: json['reward_status'],
      rewardTitle: json['reward_title'],
      rewardDescription: json['reward_description'],
      rewardCoins: json['reward_coins'],
      monetaryCountry: json['monetary_country'],
      monetaryUnit: json['monetary_unit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reward_status'] = this.rewardStatus;
    data['reward_title'] = this.rewardTitle;
    data['reward_description'] = this.rewardDescription;
    data['reward_coins'] = this.rewardCoins;
    data['monetary_country'] = this.monetaryCountry;
    data['monetary_unit'] = this.monetaryUnit;
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
        monetaryCountry: json['monetary_country'],
        monetaryUnit: json['monetary_unit'],
        monthSales: json['month_sales'],
        dailySales: json['daily_sales'].cast<int>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['monetary_country'] = this.monetaryCountry;
    data['monetary_unit'] = this.monetaryUnit;
    data['month_sales'] = this.monthSales;
    data['daily_sales'] = this.dailySales;
    return data;
  }
}
