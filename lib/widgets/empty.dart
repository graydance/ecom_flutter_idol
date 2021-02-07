import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';

class EmptyListWidget extends StatefulWidget{
  final String buttonText;
  final String tips;

  EmptyListWidget(this.buttonText, this.tips);

  @override
  State<StatefulWidget> createState() => _EmptyListWidget();

}

class _EmptyListWidget extends State<EmptyListWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Center(
        child: Column(
          children: [
            IdolButton(widget.buttonText, status: IdolButtonStatus.enable, listener: (status){

            },),
            SizedBox(height: 20,),
            Text(widget.tips, style: TextStyle(color: Colours.color_555764, fontSize: 14),),
          ],
        ),
      ),
    );
  }
}