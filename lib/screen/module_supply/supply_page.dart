import 'package:flutter/material.dart';

class SupplyPage extends StatefulWidget {
  final void Function() onInit;
  SupplyPage({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return SupplyPageState();
  }
}

class SupplyPageState extends State<SupplyPage> {
  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('SupplyPage'),
    );
  }
}
