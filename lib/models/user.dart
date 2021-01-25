import 'package:flutter/material.dart';

@immutable
class User {
  final String storeName;
  final String storePicture;
  final String portrait;
  final int gender;
  final String aboutMe;
  final String bindPhone;
  final int availableBalance;
  final String availableBalanceStr;
  final int lifetimeEarnings;
  final String lifetimeEarningsStr;
  final String monetaryCountry;
  final String monetaryUnit;
  final int shopStatus;
  final int heatRank;
  final String bioLink;
  final String id;
  final String email;
  final String updatedAt;
  final String createdAt;
  final String token;
  final int followers;
  final int followings;
  final int products;
  // 当前用户是否关注 1关注 0未关注
  final int followStatus;
  final int isOfficial;
  final String userName;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const User({
    this.storeName = "",
    this.storePicture = "",
    this.portrait = "",
    this.gender = 0,
    this.aboutMe = "",
    this.bindPhone = "",
    this.availableBalance = 0,
    this.availableBalanceStr = "0.00",
    this.lifetimeEarnings = 0,
    this.lifetimeEarningsStr = "0.00",
    this.monetaryCountry = "USD",
    this.monetaryUnit = "\$",
    this.shopStatus = 0,
    this.heatRank = 0,
    this.bioLink = "",
    this.id = "",
    this.email = "",
    this.updatedAt ="",
    this.createdAt = "",
    this.token = "",
    this.followers = 0,
    this.followings = 0,
    this.products = 0,
    this.followStatus = 0,
    this.isOfficial = 0,
    this.userName = "",
  });

  User copyWith({
    String storeName,
    String storePicture,
    String portrait,
    int gender,
    String aboutMe,
    String bindPhone,
    int availableBalance,
    String availableBalanceStr,
    int lifetimeEarnings,
    String lifetimeEarningsStr,
    String monetaryCountry,
    String monetaryUnit,
    int shopStatus,
    int heatRank,
    String bioLink,
    String id,
    String email,
    String updatedAt,
    String createdAt,
    String token,
    int followers,
    int followings,
    int products,
    int followStatus,
    int isOfficial,
    String userName,
  }) {
    if ((storeName == null || identical(storeName, this.storeName)) &&
        (storePicture == null || identical(storePicture, this.storePicture)) &&
        (portrait == null || identical(portrait, this.portrait)) &&
        (gender == null || identical(gender, this.gender)) &&
        (aboutMe == null || identical(aboutMe, this.aboutMe)) &&
        (bindPhone == null || identical(bindPhone, this.bindPhone)) &&
        (availableBalance == null ||
            identical(availableBalance, this.availableBalance)) &&
        (availableBalanceStr == null ||
            identical(availableBalanceStr, this.availableBalanceStr)) &&
        (lifetimeEarnings == null ||
            identical(lifetimeEarnings, this.lifetimeEarnings)) &&
        (lifetimeEarningsStr == null ||
            identical(lifetimeEarningsStr, this.lifetimeEarningsStr)) &&
        (monetaryCountry == null ||
            identical(monetaryCountry, this.monetaryCountry)) &&
        (monetaryUnit == null || identical(monetaryUnit, this.monetaryUnit)) &&
        (shopStatus == null || identical(shopStatus, this.shopStatus)) &&
        (heatRank == null || identical(heatRank, this.heatRank)) &&
        (bioLink == null || identical(bioLink, this.bioLink)) &&
        (id == null || identical(id, this.id)) &&
        (email == null || identical(email, this.email)) &&
        (updatedAt == null || identical(updatedAt, this.updatedAt)) &&
        (createdAt == null || identical(createdAt, this.createdAt)) &&
        (token == null || identical(token, this.token)) &&
        (followers == null || identical(followers, this.followers)) &&
        (followings == null || identical(followings, this.followings)) &&
        (products == null || identical(products, this.products)) &&
        (followStatus == null || identical(followStatus, this.followStatus)) &&
        (isOfficial == null || identical(isOfficial, this.isOfficial)) &&
        (userName == null || identical(userName, this.userName))) {
      return this;
    }

    return User(
      storeName: storeName ?? this.storeName,
      storePicture: storePicture ?? this.storePicture,
      portrait: portrait ?? this.portrait,
      gender: gender ?? this.gender,
      aboutMe: aboutMe ?? this.aboutMe,
      bindPhone: bindPhone ?? this.bindPhone,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceStr: availableBalanceStr ?? this.availableBalanceStr,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
      lifetimeEarningsStr: lifetimeEarningsStr ?? this.lifetimeEarningsStr,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
      shopStatus: shopStatus ?? this.shopStatus,
      heatRank: heatRank ?? this.heatRank,
      bioLink: bioLink ?? this.bioLink,
      id: id ?? this.id,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      products: products ?? this.products,
      followStatus: followStatus ?? this.followStatus,
      isOfficial: isOfficial ?? this.isOfficial,
      userName: userName ?? this.userName,
    );
  }

  factory User.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return User(
      storeName: map[keyMapper('storeName')] as String,
      storePicture: map[keyMapper('storePicture')] as String,
      portrait: map[keyMapper('portrait')] as String,
      gender: map[keyMapper('gender')] as int,
      aboutMe: map[keyMapper('aboutMe')] as String,
      bindPhone: map[keyMapper('bindPhone')] as String,
      availableBalance: map[keyMapper('availableBalance')] as int,
      availableBalanceStr: map[keyMapper('availableBalanceStr')] as String,
      lifetimeEarnings: map[keyMapper('lifetimeEarnings')] as int,
      lifetimeEarningsStr: map[keyMapper('lifetimeEarningsStr')] as String,
      monetaryCountry: map[keyMapper('monetaryCountry')] as String,
      monetaryUnit: map[keyMapper('monetaryUnit')] as String,
      shopStatus: map[keyMapper('shopStatus')] as int,
      heatRank: map[keyMapper('heatRank')] as int,
      bioLink: map[keyMapper('bioLink')] as String,
      id: map[keyMapper('id')] as String,
      email: map[keyMapper('email')] as String,
      updatedAt: map[keyMapper('updatedAt')] as String,
      createdAt: map[keyMapper('createdAt')] as String,
      token: map[keyMapper('token')] as String,
      followers: map[keyMapper('followers')] as int,
      followings: map[keyMapper('followings')] as int,
      products: map[keyMapper('products')] as int,
      followStatus: map[keyMapper('followStatus')] as int,
      isOfficial: map[keyMapper('isOfficial')] as int,
      userName: map[keyMapper('userName')] as String,
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('storeName'): this.storeName,
      keyMapper('storePicture'): this.storePicture,
      keyMapper('portrait'): this.portrait,
      keyMapper('gender'): this.gender,
      keyMapper('aboutMe'): this.aboutMe,
      keyMapper('bindPhone'): this.bindPhone,
      keyMapper('availableBalance'): this.availableBalance,
      keyMapper('availableBalanceStr'): this.availableBalanceStr,
      keyMapper('lifetimeEarnings'): this.lifetimeEarnings,
      keyMapper('lifetimeEarningsStr'): this.lifetimeEarningsStr,
      keyMapper('monetaryCountry'): this.monetaryCountry,
      keyMapper('monetaryUnit'): this.monetaryUnit,
      keyMapper('shopStatus'): this.shopStatus,
      keyMapper('heatRank'): this.heatRank,
      keyMapper('bioLink'): this.bioLink,
      keyMapper('id'): this.id,
      keyMapper('email'): this.email,
      keyMapper('updatedAt'): this.updatedAt,
      keyMapper('createdAt'): this.createdAt,
      keyMapper('token'): this.token,
      keyMapper('followers'): this.followers,
      keyMapper('followings'): this.followings,
      keyMapper('products'): this.products,
      keyMapper('followStatus'): this.followStatus,
      keyMapper('isOfficial'): this.isOfficial,
      keyMapper('userName'): this.userName,
    } as Map<String, dynamic>;
  }
}