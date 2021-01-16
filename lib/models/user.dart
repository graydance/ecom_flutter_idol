import 'package:flutter/material.dart';

@immutable
class User {
  final String nickName;
  final String portrait;
  final int gender;
  final String aboutMe;
  final String bindPhone;
  final int availableBalance;
  final int lifetimeEarnings;
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

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const User({
    this.nickName = '',
    this.portrait = '',
    this.gender = 0,
    this.aboutMe = '',
    this.bindPhone = '',
    this.availableBalance = 0,
    this.lifetimeEarnings = 0,
    this.monetaryCountry = 'USD',
    this.monetaryUnit = '\$',
    this.shopStatus = 0,
    this.heatRank = 0,
    this.bioLink = '',
    this.id = '',
    this.email = '',
    this.updatedAt = '',
    this.createdAt = '',
    this.token = '',
  });

  User copyWith({
    bool isLoaded,
    String nickName,
    String portrait,
    int gender,
    String aboutMe,
    String bindPhone,
    int availableBalance,
    int lifetimeEarnings,
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
  }) {
    if ((nickName == null || identical(nickName, this.nickName)) &&
        (portrait == null || identical(portrait, this.portrait)) &&
        (gender == null || identical(gender, this.gender)) &&
        (aboutMe == null || identical(aboutMe, this.aboutMe)) &&
        (bindPhone == null || identical(bindPhone, this.bindPhone)) &&
        (availableBalance == null ||
            identical(availableBalance, this.availableBalance)) &&
        (lifetimeEarnings == null ||
            identical(lifetimeEarnings, this.lifetimeEarnings)) &&
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
        (token == null || identical(token, this.token))) {
      return this;
    }

    return User(
      nickName: nickName ?? this.nickName,
      portrait: portrait ?? this.portrait,
      gender: gender ?? this.gender,
      aboutMe: aboutMe ?? this.aboutMe,
      bindPhone: bindPhone ?? this.bindPhone,
      availableBalance: availableBalance ?? this.availableBalance,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
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
    );
  }

  @override
  String toString() {
    return 'User{nickName: $nickName, portrait: $portrait, gender: $gender, aboutMe: $aboutMe, bindPhone: $bindPhone, availableBalance: $availableBalance, lifetimeEarnings: $lifetimeEarnings, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit, shopStatus: $shopStatus, heatRank: $heatRank, bioLink: $bioLink, id: $id, email: $email, updatedAt: $updatedAt, createdAt: $createdAt, token: $token}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          nickName == other.nickName &&
          portrait == other.portrait &&
          gender == other.gender &&
          aboutMe == other.aboutMe &&
          bindPhone == other.bindPhone &&
          availableBalance == other.availableBalance &&
          lifetimeEarnings == other.lifetimeEarnings &&
          monetaryCountry == other.monetaryCountry &&
          monetaryUnit == other.monetaryUnit &&
          shopStatus == other.shopStatus &&
          heatRank == other.heatRank &&
          bioLink == other.bioLink &&
          id == other.id &&
          email == other.email &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt &&
          token == other.token);

  @override
  int get hashCode =>
      nickName.hashCode ^
      portrait.hashCode ^
      gender.hashCode ^
      aboutMe.hashCode ^
      bindPhone.hashCode ^
      availableBalance.hashCode ^
      lifetimeEarnings.hashCode ^
      monetaryCountry.hashCode ^
      monetaryUnit.hashCode ^
      shopStatus.hashCode ^
      heatRank.hashCode ^
      bioLink.hashCode ^
      id.hashCode ^
      email.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode ^
      token.hashCode;

  factory User.fromMap(
    Map<String, dynamic> map, {
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return User(
      nickName: map[keyMapper('nickName')] as String,
      portrait: map[keyMapper('portrait')] as String,
      gender: map[keyMapper('gender')] as int,
      aboutMe: map[keyMapper('aboutMe')] as String,
      bindPhone: map[keyMapper('bindPhone')] as String,
      availableBalance: map[keyMapper('availableBalance')] as int,
      lifetimeEarnings: map[keyMapper('lifetimeEarnings')] as int,
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
    );
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('nickName'): this.nickName,
      keyMapper('portrait'): this.portrait,
      keyMapper('gender'): this.gender,
      keyMapper('aboutMe'): this.aboutMe,
      keyMapper('bindPhone'): this.bindPhone,
      keyMapper('availableBalance'): this.availableBalance,
      keyMapper('lifetimeEarnings'): this.lifetimeEarnings,
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
    } as Map<String, dynamic>;
  }

//</editor-fold>

}