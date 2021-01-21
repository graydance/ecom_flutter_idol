import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class InboxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AppBar(
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colours.color_444648,
                      ),
                      onPressed: () => {}),
                ],
                elevation: 0,
                title: Text('InBox'),
                centerTitle: false,
              ),
            ],
          ),
          // Expanded(child: Text('data')),
          Expanded(
            child: Text('Content'
            ),
          ),
        ],
      ),
    );
  }
}
