import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/tutorialOverlay.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class FollowingGoodsListItem extends StatefulWidget {
  final GoodsDetail goodsDetail;
  final int idx;
  final OnProductAddedStoreListener onProductAddedStoreListener;

  const FollowingGoodsListItem(
      {Key key,
      this.idx,
      this.goodsDetail = const GoodsDetail(),
      this.onProductAddedStoreListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FollowingGoodsListItemState();
}

typedef OnProductAddedStoreListener = Function(GoodsDetail goodsDetail);

class _FollowingGoodsListItemState extends State<FollowingGoodsListItem> {
  double _messageBarHeight = 0;
  final _storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();

    timeago.setLocaleMessages('myEn', MyEnMessages());
    timeago.setDefaultLocale('myEn');
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   String step = await _storage.read(key: KeyStore.GUIDE_STEP);
    //   if (step == "3") {
    //     Future.delayed(Duration(milliseconds: 300), () {
    //       Global.tokPikAndSell.currentState.show();
    //     });
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    widget.goodsDetail.goods.forEach((element) {
      if (_isVideoSource(element)) {
        return;
      }
      precacheImage(
        CachedNetworkImageProvider(element),
        context,
      );
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductItemWidget >>> ' + widget.goodsDetail.toString());
    var updateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.goodsDetail.updateTime);

    return GestureDetector(
      onTap: () {
        AppEvent.shared.report(
          event: AnalyticsEvent.grid_click_b,
          parameters: {AnalyticsEventParameter.id: widget.goodsDetail.id},
        );
        StoreProvider.of<AppState>(context)
            .dispatch(ShowGoodsDetailAction(widget.goodsDetail));
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
                        StoreProvider.of<AppState>(context).dispatch(
                            ShowGoodsDetailAction(widget.goodsDetail));
                        // // Supplier detail
                        // IdolRoute.startSupplySupplierDetail(
                        //     context,
                        //     widget.goodsDetail.supplierId,
                        //     widget.goodsDetail.supplierName);
                      },
                      child: Text(
                        widget.goodsDetail.supplierName,
                        style: TextStyle(
                            color: Colours.color_393939,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
                height: MediaQuery.of(context).size.width - 20 * 2,
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.goodsDetail.goods.first),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Stack(
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: MessageBar(
                        height: _messageBarHeight,
                        onTap: () {
                          _hideMessageBar();
                          ShareManager.showShareGoodsDialog(
                              context, widget.goodsDetail.goods[0]);
                        },
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
                  '${timeago.format(updateTime)}',
                  style: TextStyle(color: Colours.color_C4C5CD, fontSize: 12),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            // Shopping description.
            Text(
              widget.goodsDetail.goodsName ?? '',
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
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: Global.getUser(context).monetaryUnit +
                                      widget.goodsDetail.earningPriceStr ??
                                  '0.00',
                              style: TextStyle(
                                  color: Colours.color_EA5228,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: 'Earnings Per Sale',
                              style: TextStyle(
                                color: Colours.color_C4C5CD,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: Global.getUser(context).monetaryUnit +
                                      widget.goodsDetail.suggestedPriceStr ??
                                  '0.00',
                              style: TextStyle(
                                color: Colours.color_0F1015,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: 'Suggested Price',
                              style: TextStyle(
                                color: Colours.color_C4C5CD,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 44,
                    child: widget.idx == 0
                        ? TutorialOverlay(
                            key: Global.tokPikAndSell,
                            bubbleText:
                                'Click to add first item to your listing.',
                            builder: (ctx) => IdolButton(
                                  widget.goodsDetail.inMyStore == 1
                                      ? 'Share to Earn'
                                      : 'Pick & Sell',
                                  status: IdolButtonStatus.enable,
                                  listener: (status) async {
                                    Global.tokPikAndSell.currentState.hide();
                                    String step = await _storage.read(
                                        key: KeyStore.GUIDE_STEP);
                                    if (status == IdolButtonStatus.enable) {
                                      AppEvent.shared.report(
                                          event: AnalyticsEvent.pick_share,
                                          parameters: {
                                            AnalyticsEventParameter.type:
                                                widget.goodsDetail.inMyStore ==
                                                        1
                                                    ? 'share'
                                                    : 'pick'
                                          });
                                      if (widget.goodsDetail.inMyStore == 1) {
                                        ShareManager.showShareGoodsDialog(
                                            context,
                                            widget.goodsDetail.goods[0]);
                                      } else {
                                        await _addProductToMyStore(
                                            widget.goodsDetail);
                                        if (step == "3") {
                                          Global.tokShopLink.currentState
                                              .show();
                                        }
                                      }
                                    }
                                  },
                                ))
                        : IdolButton(
                            widget.goodsDetail.inMyStore == 1
                                ? 'Share to Earn'
                                : 'Pick & Sell',
                            status: IdolButtonStatus.enable,
                            listener: (status) {
                              if (status == IdolButtonStatus.enable) {
                                if (widget.goodsDetail.inMyStore == 1) {
                                  ShareManager.showShareGoodsDialog(
                                      context, widget.goodsDetail.goods[0]);
                                } else {
                                  _addProductToMyStore(widget.goodsDetail);
                                }
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showMessageBar() {
    setState(() {
      _messageBarHeight = 60;
    });
    Future.delayed(Duration(seconds: 4)).then((value) {
      _hideMessageBar();
    });
  }

  _hideMessageBar() {
    setState(() {
      _messageBarHeight = 0;
    });
  }

  Future _addProductToMyStore(GoodsDetail goodsDetail) async {
    final completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(AddToStoreAction(
      goodsDetail,
      completer,
    ));
    completer.future.then((value) => _showMessageBar());
    // try {
    //   EasyLoading.show(status: 'Loading...');
    //   await DioClient.getInstance()
    //       .post(ApiPath.addStore, baseRequest: AddStoreRequest(goodsDetail.id));
    //   EasyLoading.dismiss();
    //   if (widget.onProductAddedStoreListener != null) {
    //     widget.onProductAddedStoreListener(goodsDetail);
    //   }
    //   _buttonText = 'Has been added to my store';
    //   _idolButtonStatus = IdolButtonStatus.normal;
    //   _idolButtonStatusKey.currentState.updateText(_buttonText);
    //   _idolButtonStatusKey.currentState.updateButtonStatus(_idolButtonStatus);
    // } catch (e) {
    //   EasyLoading.dismiss();
    //   debugPrint(e.toString());
    //   EasyLoading.showError(e.toString());
    // }
  }

  Widget _createItemMediaWidget(String sourceUrl) {
    debugPrint('_createItemMediaWidget >>> $sourceUrl');
    if (_isVideoSource(sourceUrl)) {
      return VideoPlayerWidget(
        url: sourceUrl,
      );
    } else {
      return CachedNetworkImage(
        placeholder: (context, _) => Image(
          image: R.image.goods_placeholder(),
          fit: BoxFit.cover,
        ),
        imageUrl: sourceUrl,
        fit: BoxFit.contain,
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

  // Timer _debounce;

  // void debounce(Function fn, [int t = 30]) {
  //   // return () {
  //   // 还在时间之内，抛弃上一次
  //   if (_debounce?.isActive ?? false) _debounce.cancel();
  //   _debounce = Timer(Duration(milliseconds: t), () {
  //     fn();
  //   });
  //   // };
  // }
}

class MessageBar extends StatefulWidget {
  final double height;
  final VoidCallback onTap;
  const MessageBar({
    Key key,
    this.height = 60,
    this.onTap,
  }) : super(key: key);

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.height,
      width: double.infinity,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colours.color_0F1015.withAlpha(200),
      ),
      curve: Curves.fastOutSlowIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Added to listing successfully',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onTap != null) widget.onTap();
              },
              child: Row(
                children: [
                  Text(
                    'Go to Share',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffEA5228),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 14,
                    color: Color(0xffEA5228),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyEnMessages extends timeago.EnMessages {
  @override
  String lessThanOneMinute(int seconds) => '$seconds seconds';

  @override
  String days(int days) => '$days days';

  @override
  String aboutAMonth(int days) => 'a month';

  @override
  String suffixFromNow() => '';
}
