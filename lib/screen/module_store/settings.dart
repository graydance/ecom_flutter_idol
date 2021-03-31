import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/conf.dart';
import 'package:idol/env.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const TextStyle titleTextStyle =
      TextStyle(color: Colours.black, fontSize: 16);
  var settingDatas = [
    // {
    //   "key": "set_password",
    //   "image": Image(
    //     image: R.image.ic_settings_set_password(),
    //     color: Colours.color_555764,
    //     width: 30,
    //     height: 30,
    //   ),
    //   "widget": Text(
    //     'Set Password',
    //     style: titleTextStyle,
    //   )
    // },
    {
      "key": 1,
      "image": Image(
        image: R.image.ic_settings_email(),
        color: Colours.color_555764,
        width: 30,
        height: 30,
      ),
      "widget": Text(
        'Email Us',
        style: titleTextStyle,
      ),
    },
    {
      "key": 2,
      "image": Image(
        image: R.image.ic_settings_contact(),
        color: Colours.color_555764,
        width: 30,
        height: 30,
      ),
      "widget": Text(
        'Stuff WhatsApp',
        style: titleTextStyle,
      ),
    },
    {
      "key": 3,
      "image": Image(
        image: R.image.ic_settings_rate_us(),
        color: Colours.color_555764,
        width: 30,
        height: 30,
      ),
      "widget": Text(
        'Rate Us',
        style: titleTextStyle,
      ),
    },
    {
      "key": 4,
      "image": Image(
        image: R.image.ic_settings_faq(),
        color: Colours.color_555764,
        width: 30,
        height: 30,
      ),
      "widget": Text(
        'FAQ',
        style: titleTextStyle,
      ),
    },
    {
      "key": 5,
      "image": Image(
        image: R.image.ic_settings_privacy(),
        color: Colours.color_555764,
        width: 30,
        height: 30,
      ),
      "widget": Text(
        'Privacy Policy',
        style: titleTextStyle,
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdolUI.appBar(context, 'Settings'),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return Container(
      color: Colours.color_F8F8F8,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: index == 0 ? 10 : 0),
                color: Colours.white,
                child: ListTile(
                  leading: settingDatas[index]['image'],
                  title: Transform(
                    transform: Matrix4.translationValues(-18, 0.0, 0.0),
                    child: settingDatas[index]['widget'],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colours.color_C3C4C4,
                    size: 15,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  enabled: true,
                  onTap: () {
                    _onTap(settingDatas[index]['key']);
                  },
                ),
              );
            },
            itemCount: settingDatas.length,
          ),
          GestureDetector(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 8,
                ),
                padding: EdgeInsets.only(top: 16, bottom: 16),
                color: Colours.white,
                child: Text(
                  'Log Out',
                  style: titleTextStyle,
                ),
              ),
              onTap: () {
                IdolRoute.logOut(context);
              }),
        ],
      ),
    );
  }

  //TextButton(onPressed: (){}, child: Text('Log Out', style: TextStyle(fontSize: 14, color: Colours.color_4E9AE3),))
  void _onTap(int index) {
    switch (index) {
      case 0:
        IdolRoute.startSetPassword(context);
        break;
      case 1:
        Global.launchURL(emailUsUri,
            'Please check whether you have email application installed');
        break;
      case 2:
        Global.launchWhatsApp();
        break;
      case 3:
        LaunchReview.launch(androidAppId: androidAppId, iOSAppId: iosAppId);
        break;
      case 4:
        IdolRoute.startInnerWebView(
            context, InnerWebViewArguments('FAQ', faqUri));
        break;
      case 5:
        IdolRoute.startInnerWebView(
            context, InnerWebViewArguments('Privacy Policy', privacyPolicyUri));
        break;
      default:
        break;
    }
  }
}
