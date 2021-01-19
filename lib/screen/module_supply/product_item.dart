import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/models/product.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:idol/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class ProductItemWidget extends StatefulWidget {
  final Product product;

  const ProductItemWidget({Key key, this.product = const Product()})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('ProductItemWidget >>> ' + widget.product.toString());
    return Container(
      padding: EdgeInsets.all(15),
      color: Colours.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text(
                    widget.product.nickName,
                    style: TextStyle(color: Colours.color_393939, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO Follow
                    },
                    child: Text(
                      '·Follow',
                      style:
                          TextStyle(color: Colours.color_48B6EF, fontSize: 16),
                    ),
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colours.color_575859,
                  ),
                  onPressed: () => {
                        // TODO
                        EasyLoading.showToast("More menu"),
                      }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Image|Video source.
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            child: Container(
              color: Colours.black,
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 345 / 376,
                    child: Stack(
                      children: [
                        Swiper(
                          itemBuilder: (context, index) {
                            return _createItemMediaWidget(
                                widget.product.goods[index]);
                          },
                          pagination: SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                activeSize: 6,
                                size: 5,
                                color: Colours.color_50D8D8D8,
                                activeColor: Colours.white,
                              )),
                          itemCount: widget.product.goods.length,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: Colours.white,
                                ),
                                Text(
                                  _formatNum(widget.product.collectNum),
                                  style: TextStyle(
                                      color: Colours.white, fontSize: 8),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colours.color_black20,
                            ),
                            //padding: EdgeInsets.all(5),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.whatshot,
                                  size: 20,
                                  color: Colours.white,
                                ),
                                Text(
                                  _formatNum(widget.product.shoppingCar),
                                  style: TextStyle(
                                      color: Colours.white, fontSize: 8),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colours.color_black20,
                            ),
                            // padding: EdgeInsets.all(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Tag
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 5,
            children: widget.product.tag.map((tag) {
              return Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colours.color_48B6EF, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  tag.interestName,
                  style: TextStyle(color: Colours.color_48B6EF, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: 5,
          ),
          // Shopping description.
          Text(
            widget.product.goodsDescription,
            style: TextStyle(
              color: Colours.color_555764,
              fontSize: 14,
            ),
            strutStyle: StrutStyle(
                forceStrutHeight: true, height: 1, leading: 0.2, fontSize: 14),
          ),
          SizedBox(
            height: 4,
          ),
          // Current Price
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '\$' +
                      TextUtil.formatDoubleComma3(
                          widget.product.earningPrice / 100),
                  style: TextStyle(color: Colours.color_EA5228, fontSize: 20),
                ),
                TextSpan(text: ' '),
                TextSpan(
                  text: 'Earnings Per Sale',
                  style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12),
                ),
              ],
            ),
          ),
          // Suggested Price.
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '\$' +
                      TextUtil.formatDoubleComma3(
                          widget.product.suggestedPrice / 100),
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
                ),
                TextSpan(text: ' '),
                TextSpan(
                  text: 'Suggested Price',
                  style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          // Add to my store.
          IdolButton(
            'Add to my store',
            status: IdolButtonStatus.enable,
            listener: (status) {
              // TODO onTap()
            },
          ),
        ],
      ),
    );
  }

  Widget _createItemMediaWidget(String sourceUrl) {
    debugPrint('_createItemMediaWidget >>> $sourceUrl');
    if (_isVideoSource(sourceUrl)) {
      return VideoPlayerWidget(
        url: sourceUrl,
      );
    } else {
      return Image.network(
        sourceUrl,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      );
    }
  }

  String _formatNum(int num) {
    if (num < 1000) {
      return num.toString();
    } else if (num < 1000) {
      return (num / 1000).toStringAsFixed(1) + 'k';
    } else {
      return (num / 10000).toStringAsFixed(1) + "w";
    }
  }

  bool _isVideoSource(String url) {
    if (url.isEmpty) {
      return false;
    }
    url = url.toLowerCase();
    return (url.contains('.mp4') ||
        url.contains('.avi') ||
        url.contains('.mov') ||
        url.contains('.rmvb') ||
        url.contains('.rm') ||
        url.contains('.flv') ||
        url.contains('.3gp') ||
        url.contains('.wmv') ||
        url.contains('.mkv'));
  }
}
