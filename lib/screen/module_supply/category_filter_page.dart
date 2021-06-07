import 'package:flutter/material.dart';
import 'package:idol/models/models.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_supply/for_you_goods_tab_view.dart';

class CategoryFilterScreen extends StatefulWidget {
  CategoryFilterScreen({Key key}) : super(key: key);

  @override
  _CategoryFilterScreenState createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final GoodsCategory model = ModalRoute.of(context).settings.arguments;
    return Container(
      color: Colours.color_F8F8F8,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AppBar(
                elevation: 0,
                title: Text(
                  model.name,
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 20),
                ),
                centerTitle: true,
              ),
            ],
          ),
          // Expanded(child: Text('data')),
          Expanded(
            child: ForYouTabView(
              caterogy: model,
            ),
          ),
        ],
      ),
    );
  }
}
