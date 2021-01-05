import 'package:flutter/material.dart';

class BioLinksPage extends StatefulWidget {
  final void Function() onInit;
  BioLinksPage({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return BioLinksPageState();
  }
}

class BioLinksPageState extends State<BioLinksPage> {
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
