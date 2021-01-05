import 'package:flutter/material.dart';

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
      child: Text('StorePage'),
    );
  }
}
