import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/video_player_widget.dart';

class FollowingGoodsListItem extends StatefulWidget {
  final GoodsDetail goodsDetail;
  final OnProductAddedStoreListener onProductAddedStoreListener;

  const FollowingGoodsListItem(
      {Key key,
      this.goodsDetail = const GoodsDetail(),
      this.onProductAddedStoreListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FollowingGoodsListItemState();
}

typedef OnProductAddedStoreListener = Function(GoodsDetail goodsDetail);

class _FollowingGoodsListItemState extends State<FollowingGoodsListItem> {
  String buttonText = 'Add to my store';

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductItemWidget >>> ' + widget.goodsDetail.toString());
    return GestureDetector(
      onTap: () {
        // GoodsDetail
        IdolRoute.startGoodsDetail(context, widget.goodsDetail.supplierId, widget.goodsDetail.id);
      },
      child: Container(
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
                    GestureDetector(
                      onTap: () {
                        // Supplier detail
                        IdolRoute.startSupplySupplierDetail(
                            context,
                            widget.goodsDetail.supplierId,
                            widget.goodsDetail.supplierName);
                      },
                      child: Text(
                        widget.goodsDetail.supplierName,
                        style: TextStyle(
                            color: Colours.color_393939, fontSize: 16),
                      ),
                    ),
                    ...(widget.goodsDetail.followStatus == 0)
                        ? [
                            Text(
                              ' · ',
                              style: TextStyle(
                                  color: Colours.color_48B6EF, fontSize: 16),
                            ),
                            FollowButton(
                              widget.goodsDetail.supplierId,
                              defaultFollowStatus: FollowStatus.unFollow,
                              buttonStyle: FollowButtonStyle.text,
                              fontSize: 16.0
                            ),
                          ]
                        : [],
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
                                  widget.goodsDetail.goods[index]);
                            },
                            pagination: SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                  activeSize: 6,
                                  size: 5,
                                  color: Colours.color_50D8D8D8,
                                  activeColor: Colours.white,
                                )),
                            itemCount: widget.goodsDetail.goods.length,
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
                              EasyLoading.showToast(
                                  '${widget.goodsDetail.collectNum} Liked');
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
                                    _formatNum(widget.goodsDetail.collectNum),
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
                              EasyLoading.showToast(
                                  '${widget.goodsDetail.soldNum} Sold');
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
                                    _formatNum(widget.goodsDetail.soldNum),
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
              children: widget.goodsDetail.tag.map((tag) {
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
              widget.goodsDetail.goodsDescription,
              style: TextStyle(
                color: Colours.color_555764,
                fontSize: 14,
              ),
              strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  height: 1,
                  leading: 0.2,
                  fontSize: 14),
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
                            widget.goodsDetail.earningPrice / 100),
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
                            widget.goodsDetail.suggestedPrice / 100),
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
              buttonText,
              status: IdolButtonStatus.enable,
              listener: (status) {
                _addProductToMyStore(widget.goodsDetail);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addProductToMyStore(GoodsDetail goodsDetail) {
    DioClient.getInstance()
        .post(ApiPath.addStore, baseRequest: AddStoreRequest(goodsDetail.id))
        .then((data) {
      if (widget.onProductAddedStoreListener != null) {
        widget.onProductAddedStoreListener(goodsDetail);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      EasyLoading.showError(err.toString());
    });
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
