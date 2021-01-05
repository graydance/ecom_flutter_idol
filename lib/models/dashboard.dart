class Dashboard {
  double availableBalance;
  double lifetimeEarnings;
  String monetaryUnit;
  List<Reward> rewardList;
  List<PastSales> pastSales;

  Dashboard(
      {this.availableBalance,
      this.lifetimeEarnings,
      this.monetaryUnit,
      this.rewardList,
      this.pastSales});

  Dashboard.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance'];
    lifetimeEarnings = json['lifetime_earnings'];
    monetaryUnit = json['monetary_unit'];
    if (json['reward_list'] != null) {
      // ignore: deprecated_member_use
      rewardList = new List<Reward>();
      json['reward_list'].forEach((v) {
        rewardList.add(new Reward.fromJson(v));
      });
    }
    if (json['past_sales'] != null) {
      // ignore: deprecated_member_use
      pastSales = new List<PastSales>();
      json['past_sales'].forEach((v) {
        pastSales.add(new PastSales.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_balance'] = this.availableBalance;
    data['lifetime_earnings'] = this.lifetimeEarnings;
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
  int rewardStatus;
  String rewardTitle;
  String rewardDescription;
  String rewardCoins;

  Reward(
      {this.rewardStatus,
      this.rewardTitle,
      this.rewardDescription,
      this.rewardCoins});

  Reward.fromJson(Map<String, dynamic> json) {
    rewardStatus = json['reward_status'];
    rewardTitle = json['reward_title'];
    rewardDescription = json['reward_description'];
    rewardCoins = json['reward_coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reward_status'] = this.rewardStatus;
    data['reward_title'] = this.rewardTitle;
    data['reward_description'] = this.rewardDescription;
    data['reward_coins'] = this.rewardCoins;
    return data;
  }
}

class PastSales {
  int date;
  String monetaryUnit;
  double monthSales;
  List<double> dailySales;

  PastSales({this.date, this.monetaryUnit, this.monthSales, this.dailySales});

  PastSales.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    monetaryUnit = json['monetary_unit'];
    monthSales = json['month_sales'];
    dailySales = json['daily_sales'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['monetary_unit'] = this.monetaryUnit;
    data['month_sales'] = this.monthSales;
    data['daily_sales'] = this.dailySales;
    return data;
  }
}
