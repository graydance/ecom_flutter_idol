import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  final void Function() onInit;
  InboxPage({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return InboxPageState();
  }
}

class InboxPageState extends State<InboxPage> {
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
