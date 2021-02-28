import 'package:flutter/material.dart';
import 'package:idol/models/biolinks.dart';
import 'package:idol/net/request/biolinks.dart';
import 'package:idol/res/colors.dart';

class BioLinksItemWidget extends StatefulWidget {
  final BioLink bioLink;
  final OnUpdateBioLinksCallback onUpdateBioLinksCallback;

  BioLinksItemWidget(this.bioLink, this.onUpdateBioLinksCallback);

  @override
  State<StatefulWidget> createState() => BioLinksItemWidgetState();
}

class BioLinksItemWidgetState extends State<BioLinksItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Row(children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(6),
                  ),
                  child: Image(
                    image: NetworkImage(widget.bioLink.linkIcon),
                    width: 55,
                    height: 55,
                  ),
                ),
                Column(
                  children: [
                    TextField(),
                    TextField(),
                  ],
                ),
                //Switch(value: value, onChanged: (){}),
              ],),
              Row(
                children: [
                  Container(color:Colours.color_A2A2A2,child: Icon(Icons.push_pin, color: Colours.color_F95453, size: 12,),),
                  SizedBox(width: 15,),
                  Container(color:Colours.color_A2A2A2,child: Icon(Icons.push_pin, color: Colours.color_F95453, size: 12,),),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

typedef OnUpdateBioLinksCallback = Function(EditLinksRequest request);
