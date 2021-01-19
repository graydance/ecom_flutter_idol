import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';

class StorePage extends StatefulWidget {
  final void Function() onInit;
  StorePage({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return StorePageState();
  }
}

class StorePageState extends State<StorePage> {
  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3e2833),
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
                        Icons.settings,
                        color: Colours.white,
                      ),
                      onPressed: () => {}),
                ],
                elevation: 0,
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
