import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/ui.dart';
import '../../r.g.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Image> _icons = <Image>[
    Image(
      image: R.image.ic_settings_set_password(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
    Image(
      image: R.image.ic_settings_email(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
    Image(
      image: R.image.ic_settings_contact(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
    Image(
      image: R.image.ic_settings_rate_us(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
    Image(
      image: R.image.ic_settings_faq(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
    Image(
      image: R.image.ic_settings_privacy(),
      color: Colours.color_555764,
      width: 30,
      height: 30,
    ),
  ];

  static const TextStyle titleTextStyle = TextStyle(color: Colours.black, fontSize: 16);

  List<Widget> _titles = <Widget>[
    Text(
      'Set Password',
      style: titleTextStyle,
    ),
    Text(
      'Email Us',
      style: titleTextStyle,
    ),
    Text(
      'Stuff WatsApp',
      style: titleTextStyle,
    ),
    Text(
      'Rate Us',
      style: titleTextStyle,
    ),
    Text(
      'FAQ',
      style: titleTextStyle,
    ),
    Text(
      'Privacy Policy',
      style: titleTextStyle,
    ),
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
      default:

        break;
    }
  }
}
