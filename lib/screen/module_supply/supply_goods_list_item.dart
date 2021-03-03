import 'dart:async';
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
  String _buttonText = 'Add to my store & Share';
  final GlobalKey<IdolButtonState> _idolButtonStatusKey = GlobalKey();
  IdolButtonStatus _idolButtonStatus = IdolButtonStatus.enable;

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductItemWidget >>> ' + widget.goodsDetail.toString());
    return GestureDetector(
      onTap: () {
        // GoodsDetail
        IdolRoute.startGoodsDetail(
            context, widget.goodsDetail.supplierId, widget.goodsDetail.id);
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
                            color: Colours.color_393939, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Tag
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    children: widget.goodsDetail.tag.map((tag) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colours.color_ED8514, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          tag.interestName,
                          style: TextStyle(
                              color: Colours.color_ED8514, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Text(
                  widget.goodsDetail.updateTime ?? '',
                  style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            // Shopping description.
            Text(
              widget.goodsDetail.goodsName??'',
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
                    style: TextStyle(color: Colours.color_EA5228, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'Earnings Per Sale',
                    style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colours.color_0F1015, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'Suggested Price',
                    style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Add to my store.
            IdolButton(
              _buttonText,
              key: _idolButtonStatusKey,
              status: _idolButtonStatus,
              isPartialRefresh: true,
              listener: (status) {
                if (status == IdolButtonStatus.enable) {
                  debounce(() {
                    _addProductToMyStore(widget.goodsDetail);
                  }, 1000);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _addProductToMyStore(GoodsDetail goodsDetail) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await DioClient.getInstance()
          .post(ApiPath.addStore, baseRequest: AddStoreRequest(goodsDetail.id));
      EasyLoading.dismiss();
      if (widget.onProductAddedStoreListener != null) {
        widget.onProductAddedStoreListener(goodsDetail);
      }
      _buttonText = 'Has been added to my store';
      _idolButtonStatus = IdolButtonStatus.normal;
      _idolButtonStatusKey.currentState.updateText(_buttonText);
      _idolButtonStatusKey.currentState.updateButtonStatus(_idolButtonStatus);
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      EasyLoading.showError(e.toString());
    }
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

  Timer _debounce;

  void debounce(Function fn, [int t = 30]) {
    // return () {
    // 还在时间之内，抛弃上一次
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: t), () {
      fn();
    });
    // };
  }
}
