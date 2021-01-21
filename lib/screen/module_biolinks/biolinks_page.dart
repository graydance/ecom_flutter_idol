import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class BioLinksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BioLinksPageState();
}

class _BioLinksPageState extends State<BioLinksPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colours.color_EA5228, Colours.color_FEAC1B],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AppBar(
                backgroundColor: Colours.transparent,
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colours.color_444648,
                      ),
                      onPressed: () => {}),
                ],
                elevation: 0,
                title: Text('Manage BioLinks'),
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
