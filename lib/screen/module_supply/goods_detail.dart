import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:timeago/timeago.dart' as timeago;

/// 产品详情页
class GoodsDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsDetailScreenState();
}

class _GoodsDetailScreenState extends State<GoodsDetailScreen> {
  GoodsDetail _goodsDetail = GoodsDetail();
  bool _showLikeAndSold = false;
  double _messageBarHeight = 0;
  IdolButtonStatus _bottomButtonStatus = IdolButtonStatus.normal;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _goodsDetail.goods.forEach((element) {
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
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) => _goodsDetail = store.state.goodsDetailPage,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            // actions: [
            //   IconButton(
            //     icon: Icon(
            //       Icons.more_vert,
            //       color: Colours.color_444648,
            //     ),
            //     onPressed: () => IdolRoute.startSupplySearch(context),
            //   )
            // ],
            title: Text(
              _goodsDetail.supplierName,
              style: TextStyle(
                fontSize: 20,
                color: Colours.color_0F1015,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colours.color_0F1015,
                size: 20,
              ),
              onPressed: () => IdolRoute.pop(context),
            ),
          ),
          body: _buildBodyWidget(),
        );
      },
    );
  }

  Widget _buildBodyWidget() {
    print('商品个数');
    print(_goodsDetail.goods.length);
    print('商品个数');
    var updateTime =
        DateTime.fromMillisecondsSinceEpoch(_goodsDetail.updateTime);
    _bottomButtonStatus = IdolButtonStatus.enable;
    // _bottomButtonText =
    //     goodsDetail.inMyStore == 0 ? 'Add to my store & Share' : 'Share';
    return SmartRefresher(
      controller: _refreshController,
      header: MaterialClassicHeader(
        color: Colours.color_EA5228,
      ),
      onRefresh: () async {
        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(GoodsDetailAction(
            GoodsDetailRequest(_goodsDetail.supplierId, _goodsDetail.id),
            completer));

        try {
          final goodsDetail = await completer.future;
          setState(() {
            _goodsDetail = goodsDetail;
          });
          _refreshController.refreshCompleted();
        } catch (error) {
          _refreshController.refreshFailed();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          //padding: EdgeInsets.all(15),
          color: Colours.color_F8F8F8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image|Video source.
              Container(
                height: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      child: Container(
                        child: Stack(
                          children: [
                            // AspectRatio(
                            //   aspectRatio: 376 / 345,
                            //   child:
                            Stack(
                              children: [
                                Swiper(
                                  itemBuilder: (context, index) {
                                    return _createItemMediaWidget(
                                        _goodsDetail.goods[index]);
                                  },
                                  pagination: SwiperPagination(
                                      alignment: Alignment.bottomCenter,
                                      builder: DotSwiperPaginationBuilder(
                                        activeSize: 6,
                                        size: 5,
                                        color: Colours.color_50D8D8D8,
                                        activeColor: Colours.black,
                                      )),
                                  itemCount: _goodsDetail.goods.length,
                                ),
                              ],
                            ),
                            // ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: MessageBar(
                                height: _messageBarHeight,
                                onTap: () {
                                  _hideMessageBar();
                                  ShareManager.showShareGoodsDialog(
                                      context, _goodsDetail.goods[0]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showLikeAndSold)
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                EasyLoading.showToast(
                                    '${_goodsDetail.collectNum} Liked');
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
                                      _formatNum(_goodsDetail.collectNum),
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
                                    '${_goodsDetail.soldNum} Sold');
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
                                      _formatNum(_goodsDetail.soldNum),
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
              Container(
                padding: const EdgeInsets.all(16),
                color: Colours.white,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5,
                            children: _goodsDetail.tag.map((tag) {
                              return Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colours.color_ED8514, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  tag.interestName,
                                  style: TextStyle(
                                      color: Colours.color_ED8514,
                                      fontSize: 12),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          '${timeago.format(updateTime)}',
                          style: TextStyle(
                              color: Colours.color_C4C5CD, fontSize: 12),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _goodsDetail.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colours.color_555764,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: Global.getUser(context).monetaryUnit +
                                    _goodsDetail.earningPriceStr ??
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
                                color: Colours.color_C4C5CD, fontSize: 12),
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
                            text: Global.getUser(context).monetaryUnit +
                                    _goodsDetail.suggestedPriceStr ??
                                '0.00',
                            style: TextStyle(
                                color: Colours.color_0F1015,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: 'Suggested Price',
                            style: TextStyle(
                                color: Colours.color_C4C5CD, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IdolButton(
                  _goodsDetail.inMyStore == null
                      ? '--'
                      : (_goodsDetail.inMyStore == 0
                          ? 'Pick & Sell'
                          : 'Share to Earn'),
                  status: _bottomButtonStatus,
                  listener: (status) {
                    if (_goodsDetail.inMyStore == 1) {
                      ShareManager.showShareGoodsDialog(
                          context, _goodsDetail.goods[0]);
                    } else {
                      final completer = Completer();
                      completer.future.then((value) {
                        setState(() {
                          _goodsDetail = _goodsDetail.copyWith(inMyStore: 1);
                        });
                      }).catchError((error) {
                        print(error);
                      });
                      StoreProvider.of<AppState>(context)
                          .dispatch(AddToStoreAction(_goodsDetail, completer));

                      completer.future.then((value) => _showMessageBar());
                    }
                  },
                ),
              ),
              Container(
                color: Colours.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Html(
                        data: _goodsDetail.goodsDescription,
                        onLinkTap: (String url) {}),
                    // Text(
                    //   goodsDetail.goodsDescription,
                    //   style: TextStyle(
                    //     color: Colours.color_555764,
                    //     fontSize: 14,
                    //   ),
                    //   strutStyle: StrutStyle(
                    //       forceStrutHeight: true,
                    //       height: 1,
                    //       leading: 0.2,
                    //       fontSize: 14),
                    // ),
                  ],
                ),
              ),
            ],
          ),
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
}

Widget _createItemMediaWidget(String sourceUrl) {
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

class _ViewModel {
  GoodsDetail detail;
  _ViewModel(this.detail);
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.goodsDetailPage);
  }
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
