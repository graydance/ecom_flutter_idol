import 'package:flutter/material.dart';
import 'package:idol/models/goods.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/res/theme.dart';
import 'package:idol/utils/global.dart';

class SupplierGoodsListItem extends StatefulWidget {
  final Goods _goods;
  final OnItemClickCallback onItemClickCallback;
  final OnItemShareClickCallback onItemShareClickCallback;

  const SupplierGoodsListItem(this._goods,
      {this.onItemClickCallback, this.onItemShareClickCallback});

  @override
  State<StatefulWidget> createState() => _SupplierGoodsListItemState();
}

class _SupplierGoodsListItemState extends State<SupplierGoodsListItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: GestureDetector(
        onTap: () {
          if (widget.onItemClickCallback != null) {
            widget.onItemClickCallback();
          }
        },
        child: Container(
          color: Colours.white,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: Image(
                        image: NetworkImage(widget._goods.goodsPicture),
                        fit: BoxFit.cover,
                      )),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget._goods.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: Colours.color_555764, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: Global.getUser(context).monetaryUnit +
                              widget._goods.currentPriceStr,
                          style: TextStyle(
                              color: Colours.color_030406, fontSize: 16),
                        ),
                        TextSpan(
                          text: widget._goods.originalPriceStr ?? '',
                          style: TextStyle(
                              color: Colours.color_C3C4C4,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colours.color_C3C4C4,
                              fontSize: 12),
                        ),
                      ],
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 5,
                            children: widget._goods.tag == null ||
                                    widget._goods.tag.isEmpty
                                ? []
                                : widget._goods.tag.map((tag) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                        left: 2,
                                        right: 2,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colours.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          border: Border.all(
                                              color: HexColor(tag.color),
                                              width: 1)),
                                      child: Text(
                                        tag.interestName,
                                        style: TextStyle(
                                            color: HexColor(tag.color),
                                            fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.onItemShareClickCallback != null) {
                              widget.onItemShareClickCallback();
                            }
                          },
                          child: Image(
                            image: R.image.ic_goods_share(),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ...(widget._goods.discount == null ||
                      widget._goods.discount.isEmpty)
                  ? []
                  : [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 5, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colours.color_F68A51,
                              Colours.color_EA5228,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomRight: Radius.circular(100)),
                        ),
                        child: Text(
                          widget._goods.discount ?? '',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
            ],
          ),
        ),
      ),
    );
  }
}

typedef OnItemClickCallback = Function();
typedef OnItemShareClickCallback = Function();
