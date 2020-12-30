import 'dart:async';

import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed('/home'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('http://oss.wqiang.fun/thumb/cover.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
