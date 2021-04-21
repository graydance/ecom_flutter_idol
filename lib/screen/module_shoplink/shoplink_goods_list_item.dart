import 'package:flutter/material.dart';
import 'package:idol/models/models.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/utils/global.dart';

class ShopLinkGoodsListItem extends StatefulWidget {
  final int index;
  final StoreGoods _goods;
  final OnItemClickCallback onItemClickCallback;
  final OnItemLongPressCallback onItemLongPressCallback;

  const ShopLinkGoodsListItem(this.index, this._goods,
      {this.onItemClickCallback, this.onItemLongPressCallback});

  @override
  State<StatefulWidget> createState() => _ShopLinkGoodsListItemState();
}

class _ShopLinkGoodsListItemState extends State<ShopLinkGoodsListItem> {
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
        onLongPress: () {
          if (widget.onItemLongPressCallback != null) {
            widget.onItemLongPressCallback();
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
                  Stack(
                    children: [
                      AspectRatio(
                        // aspectRatio: widget.index % 2 != 0 ? 1.0 : 10 / 15,
                        aspectRatio: widget.index == 0 ? 1 : 167 / 210,
                        child: Image(
                          image: NetworkImage(widget._goods.picture),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Row(
                          children: [
                            Image(
                              image: R.image.ic_pv(),
                            ),
                            Text(
                              _formatHeatRank(widget._goods.heatRank) ?? '0',
                              style: TextStyle(
                                color: Colours.white,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0.2, 0.2),
                                    blurRadius: 3.0,
                                    color: Colours.color_B1B2B3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                                              Radius.circular(2)),
                                          border: Border.all(
                                              color: Colours.color_ED8514,
                                              width: 1)),
                                      child: Text(
                                        tag.interestName,
                                        style: TextStyle(
                                            color: Colours.color_ED8514,
                                            fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
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
                            left: 6, top: 4, right: 20, bottom: 4),
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

  String _formatHeatRank(int heatRank) {
    if (heatRank >= 10000) {
      return (heatRank / 10000).toStringAsFixed(1) + "w";
    } else if (heatRank >= 1000) {
      return (heatRank / 1000).toStringAsFixed(1) + "k";
    } else {
      return heatRank.toString();
    }
  }
}

typedef OnItemClickCallback = Function();
typedef OnItemLongPressCallback = Function();
