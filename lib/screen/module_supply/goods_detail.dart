import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:idol/event/app_event.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/res/theme.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/video_player_widget.dart';

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

    AppEvent.shared.report(event: AnalyticsEvent.product_view_b);
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
      onInit: (store) {
        _goodsDetail = store.state.goodsDetailPage;
      },
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
          body: _buildBodyWidget(vm),
        );
      },
    );
  }

  Widget _buildBodyWidget(_ViewModel model) {
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
          _goodsDetail = goodsDetail;

          if (mounted) setState(() {});

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
                        color: Colors.white,
                        child: Stack(
                          children: [
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
                                        activeColor: Colours.white,
                                      )),
                                  itemCount: _goodsDetail.goods.length,
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
                                    context,
                                    _goodsDetail.goods,
                                    _goodsDetail.shareText,
                                  );
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
                                      color: HexColor(tag.color), width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  tag.interestName,
                                  style: TextStyle(
                                      color: HexColor(tag.color), fontSize: 12),
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
                    SelectableText(
                      _goodsDetail.goodsName,
                      // maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
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
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: IdolButton(
                  _shareButtonTitle,
                  isOutlineStyle: _goodsDetail.inMyStore == 1,
                  status: _bottomButtonStatus,
                  listener: (status) {
                    _onTapShare();
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        'Specifications and models',
                        style: TextStyle(
                          color: AppTheme.color0F1015,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        final model = _goodsDetail.specList[i];
                        final allSpecString =
                            model.specValues.map((e) => e.specValue).join(', ');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.specName,
                              style: TextStyle(
                                color: AppTheme.color0F1015,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              allSpecString,
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: _goodsDetail.specList.length,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        'Different delivery opention',
                        style: TextStyle(
                          color: AppTheme.color0F1015,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        final model = _goodsDetail.expressTemplete[i];
                        final desc = _formatShippingMessage(
                            _goodsDetail.shippedFrom,
                            _goodsDetail.shippedTo,
                            model);
                        final price = _formatPrice(
                            model.price, Global.getUser(context).monetaryUnit);

                        final index = _goodsDetail.expressTemplete.length > 1
                            ? '${i + 1}. '
                            : '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$index${model.name} $price',
                              style: TextStyle(
                                color: AppTheme.color0F1015,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              desc,
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: _goodsDetail.expressTemplete.length,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        'Service',
                        style: TextStyle(
                          color: AppTheme.color0F1015,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        final model = _goodsDetail.serviceConfigs[i];
                        return _buildServiceTile(model);
                      },
                      separatorBuilder: (ctx, index) {
                        return SizedBox(
                          height: 16,
                        );
                      },
                      itemCount: _goodsDetail.serviceConfigs.length,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colours.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: AppTheme.color0F1015,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuContainer<String>(
                      items: [
                        PopupMenuItem(value: 'Copy', child: Text('Copy'))
                      ],
                      onItemSelected: (value) {
                        Clipboard.setData(
                          ClipboardData(
                            text: _removeAllHtmlTags(
                              _goodsDetail.goodsDescription,
                            ),
                          ),
                        );
                      },
                      child: Html(
                        data: _goodsDetail.goodsDescription,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              _goodsDetail.recommend != null &&
                      _goodsDetail.recommend.isNotEmpty
                  ? Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: SimilarProducts(
                          recommends: _goodsDetail.recommend,
                          currency: Global.getUser(context).monetaryUnit),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTile(ServiceConfig model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: model.icon,
          width: 30,
          height: 30,
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: TextStyle(
                  color: AppTheme.color0F1015,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                model.content,
                style: TextStyle(
                  color: AppTheme.color555764,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _shareButtonTitle => _goodsDetail.inMyStore == null
      ? '--'
      : (_goodsDetail.inMyStore == 0 ? 'Pick & Sell' : 'Share to Earn');

  void _onTapShare() {
    AppEvent.shared.report(
        event: AnalyticsEvent.detail_pick_share,
        parameters: {
          AnalyticsEventParameter.type:
              _goodsDetail.inMyStore == 1 ? 'share' : 'pick'
        });

    if (_goodsDetail.inMyStore == 1) {
      ShareManager.showShareGoodsDialog(
        context,
        _goodsDetail.goods,
        _goodsDetail.shareText,
      );
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
  }

  String _removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
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

class SimilarProducts extends StatelessWidget {
  final List<GoodsItem> recommends;
  final String currency;
  const SimilarProducts({
    Key key,
    @required this.recommends,
    @required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Text(
            'Recommended items',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.color0F1015,
            ),
          ),
        ),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 4),
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemBuilder: (context, index) {
            final model = recommends[index];
            return GoodsTile(currency, model, _getSize(context, model));
          },
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          itemCount: recommends.length,
        ),
      ],
    );
  }

  TileImageSize _getSize(BuildContext context, GoodsItem item) {
    debugPrint('GoodsItem >>> ' + item.toString());
    var screenWidth = (MediaQuery.of(context).size.width - 16 * 2 - 4 * 4) / 2;
    var height = item.height / item.width * screenWidth;

    final size = TileImageSize(screenWidth, height);
    return size;
  }
}

class TileImageSize {
  const TileImageSize(this.width, this.height);

  final double width;
  final double height;
}

class GoodsTile extends StatelessWidget {
  const GoodsTile(this.currency, this.model, this.size);

  final String currency;
  final GoodsItem model;
  final TileImageSize size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(GoodsDetailAction(
            GoodsDetailRequest(model.supplierId, model.id), completer));

        EasyLoading.show();
        try {
          final goodsDetail = await completer.future;
          EasyLoading.dismiss();
          StoreProvider.of<AppState>(context)
              .dispatch(ShowGoodsDetailAction(goodsDetail));
        } catch (error) {
          EasyLoading.dismiss();
          EasyLoading.showError(error.toString());
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height,
              child: Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      placeholder: (context, _) => Image(
                        image: R.image.goods_placeholder(),
                        fit: BoxFit.cover,
                      ),
                      imageUrl: model.picture,
                      fit: BoxFit.contain,
                      memCacheHeight: size.height.ceil(),
                    ),
                  ),
                  if (model.discount.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 6,
                          top: 4,
                          right: 14,
                          bottom: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF68A51),
                              Color(0xFFEA5228),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomRight: Radius.circular(100)),
                        ),
                        child: Text(
                          '${model.discount} off',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.goodsName}',
                    style: TextStyle(
                      color: AppTheme.color555764,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        '$currency${model.currentPriceStr}',
                        style: TextStyle(
                          color: Color(0xff0F1015),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '$currency${model.originalPriceStr}',
                        style: TextStyle(
                          color: AppTheme.color979AA9,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                    ],
                  ),
                  if (model.tag.isNotEmpty)
                    SizedBox(
                      height: 4,
                    ),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: model.tag
                        .map(
                          (tag) => Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor(tag.color), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text(
                              tag.name,
                              style: TextStyle(
                                  color: HexColor(tag.color), fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
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
      fit: BoxFit.contain,
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

String _formatShippingMessage(
    String shippedFrom, String shippedTo, ExpressTemplete model) {
  if (model == null) {
    return '';
  }
  final earlyDate = DateTime.now().add(Duration(days: model.min));
  final earlyDateString = DateFormat('MM/dd').format(earlyDate);
  final theShippedTo = shippedTo.trim().isEmpty ? 'United States' : shippedTo;
  if (shippedFrom.isEmpty) {
    return 'Shipped to $theShippedTo\nEstimated delivery as early as $earlyDateString';
  }
  return 'Shipped from $shippedFrom To $theShippedTo\nEstimated delivery as early as $earlyDateString';
}

String _formatPrice(String price, String currency) {
  return double.tryParse(price) != 0 ? currency + price : 'Free';
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

class PopupMenuContainer<T> extends StatefulWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;
  final void Function(T) onItemSelected;

  PopupMenuContainer(
      {@required this.child,
      @required this.items,
      @required this.onItemSelected,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PopupMenuContainerState<T>();
}

class PopupMenuContainerState<T> extends State<PopupMenuContainer<T>> {
  Offset _tapDownPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          _tapDownPosition = details.globalPosition;
        },
        onLongPress: () async {
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject();

          T value = await showMenu<T>(
            context: context,
            items: widget.items,
            position: RelativeRect.fromLTRB(
              _tapDownPosition.dx,
              _tapDownPosition.dy,
              overlay.size.width - _tapDownPosition.dx,
              overlay.size.height - _tapDownPosition.dy,
            ),
          );

          widget.onItemSelected(value);
        },
        child: widget.child);
  }
}
