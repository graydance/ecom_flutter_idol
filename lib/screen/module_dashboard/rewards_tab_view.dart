import 'package:flutter/material.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/utils/global.dart';

class RewardsTabView extends StatefulWidget {
  final List<Reward> list;
  final ItemClickCallback onItemClick;
  final ItemClickCallback onCompleteRewardsClick;

  const RewardsTabView(
      this.list, this.onItemClick, this.onCompleteRewardsClick);

  @override
  State<StatefulWidget> createState() => _RewardsTabViewState(list);
}

class _RewardsTabViewState extends State<RewardsTabView>
    with AutomaticKeepAliveClientMixin<RewardsTabView> {
  final List<Reward> list;

  _RewardsTabViewState(this.list);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 24),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) {
            return Divider(
              height: 10,
              color: Colors.transparent,
            );
          },
          itemCount: list.length,
          itemBuilder: (context, index) {
            return RewardsItem(
                list[index], widget.onItemClick, widget.onCompleteRewardsClick);
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

typedef ItemClickCallback = Function(Reward reward);

class RewardsItem extends StatefulWidget {
  final Reward reward;
  final ItemClickCallback onItemClick;
  final ItemClickCallback onCompleteRewardsClick;

  const RewardsItem(this.reward, this.onItemClick, this.onCompleteRewardsClick);

  @override
  State<StatefulWidget> createState() => _RewardsItemState(reward);
}

class _RewardsItemState extends State<RewardsItem> {
  final Reward reward;

  _RewardsItemState(this.reward);

  bool _clickable() {
    return reward.rewardStatus == 1;
  }

  bool _unClickable() {
    return reward.rewardStatus == 2 || reward.rewardStatus == 3;
  }

  Color _cardBorderColor() {
    if (_clickable()) {
      return Colours.color_EA5228;
    }
    if (_unClickable()) {
      return Colours.color_EDEDF2;
    }
    return Colours.white;
  }

  Color _buttonBorderColor() {
    if (_unClickable()) {
      return Colours.color_EDEDF2;
    }
    return Colours.color_EA5228;
  }

  List<Color> _buttonLinearGradientColor() {
    if (_clickable()) {
      return [Colours.color_FA812B, Colours.color_F95453];
    }
    if (reward.rewardStatus == 0) {
      return [Colours.white, Colours.white];
    }
    return [Colours.color_EDEDF2, Colours.color_EDEDF2];
  }

  Color _buttonTextColor() {
    if (_clickable()) {
      return Colours.white;
    }
    if (reward.rewardStatus == 0) {
      return Colours.color_EA5228;
    }
    return Colours.color_B1B1B3;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onItemClick(reward),
      child: Card(
        color: _unClickable() ? Colours.color_EDEDF2 : Colours.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(
            color: _cardBorderColor(),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        // 抗锯齿
        elevation: 2,
        child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 10),
              child: Row(
                children: [
                  ..._clickable()
                      ? [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Image(image: R.image.ic_complete_rewards()),
                          ),
                        ]
                      : [],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.rewardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colours.color_555764,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reward.rewardDescription ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colours.color_979AA9,
                                ),
                              ),
                            ),
                            Text(
                              reward.progress??'',
                              style: TextStyle(
                                  color: Colours.color_EA5228, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.grey,
                    ),
                    margin: EdgeInsets.only(left: 36),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_clickable()) {
                        widget.onCompleteRewardsClick(reward);
                      }
                    },
                    child: Container(
                      child: Text(
                        Global.getUser(context).monetaryUnit + reward.rewardCoinsStr,
                        style: TextStyle(
                          color: _buttonTextColor(),
                          fontSize: 14,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(
                          left: 14, top: 4, right: 14, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: _buttonLinearGradientColor()),
                          border: Border.all(
                              color: _buttonBorderColor(), width: 1)),
                    ),
                  ),
                ],
              ),
            ),
            // 设置左上角Label
            ..._clickable()
                ? [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colours.color_F68A51,
                            Colours.color_EA5228,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(100)),
                      ),
                      child: Text(
                        'COLLECT',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ]
                : [],
          ],
        ),
      ),
    );
  }
}
