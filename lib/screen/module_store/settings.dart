import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Icon> _icons = <Icon>[
    Icon(
      Icons.share,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.group,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.email,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.vpn_key,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.contact_mail,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.star_rate,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.help,
      color: Colours.black,
      size: 20,
    ),
    Icon(
      Icons.privacy_tip,
      color: Colours.black,
      size: 20,
    ),
  ];

  List<Widget> _titles = <Widget>[
    Text(
      'Invite friends for extra earnings!',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Customer Success Manager',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Set Email',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Password',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Contact Us',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Rate Us',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'FAQ',
      style: TextStyle(color: Colours.black, fontSize: 16),
    ),
    Text(
      'Privacy Settings',
      style: TextStyle(color: Colours.black, fontSize: 16),
    )
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
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: index == 0 ? 10 : 0),
            color: Colours.white,
            child: ListTile(
              leading: _icons[index],
              title: Transform(
                transform: Matrix4.translationValues(-18, 0.0, 0.0),
                child: _titles[index],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colours.color_C3C4C4,
                size: 18,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              enabled: true,
              onTap: () {
                _onTap(index);
              },
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }

  //TextButton(onPressed: (){}, child: Text('Log Out', style: TextStyle(fontSize: 14, color: Colours.color_4E9AE3),))
  void _onTap(int index) {
    switch (index) {
      case 0:
        break;

      case 1:
        break;

      case 2:
        break;

      case 3:
        break;

      case 4:
        break;

      case 5:
        break;

      case 6:
        break;

      case 7:
        break;
    }
  }
}
