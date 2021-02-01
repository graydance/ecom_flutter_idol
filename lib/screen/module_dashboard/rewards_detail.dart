import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/rewards_detail.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/ui.dart';

/// 任务详情
class RewardsDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RewardsDetailScreenState();
}

class _RewardsDetailScreenState extends State<RewardsDetailScreen> {
  RewardsDetailArguments rewardsDetailArguments;

  @override
  void initState() {
    super.initState();
    rewardsDetailArguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .rewardsDetailArguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          IdolUI.appBar(context, rewardsDetailArguments.reward?.rewardTitle),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                rewardsDetailArguments.reward?.rewardTitle,
                style: TextStyle(color: Colours.color_3B3F42, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  rewardsDetailArguments.reward?.rewardDescription,
                  style: TextStyle(color: Colours.color_3B3F42, fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
