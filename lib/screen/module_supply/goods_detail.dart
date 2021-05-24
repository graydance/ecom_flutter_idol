import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/models/goods_skus.dart';
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
import 'package:idol/widgets/product_attributes_bottom_sheet.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:intl/intl.dart';
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

  String _skuTitle = '';
  // String _selectedSkuDesc = '';
  GoodsSkus _selectedSku;
  ExpressTemplete _selectedExpress;

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
        _skuTitle = _goodsDetail.specList.isNotEmpty
            ? _goodsDetail.specList
                .map((e) => '${e.specName}(${e.specValues.length})')
                .join(', ')
            : '';
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

          if (mounted) {
            setState(() {
              _goodsDetail = goodsDetail;
              _skuTitle = _goodsDetail.specList.isNotEmpty
                  ? _goodsDetail.specList
                      .map((e) => '${e.specName}(${e.specValues.length})')
                      .join(', ')
                  : '';
              _selectedExpress = _goodsDetail.expressTemplete.first;
            });
          }
          debugPrint('_goodsDetail >>> $_goodsDetail');

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
                  _shareButtonTitle,
                  isOutlineStyle: _goodsDetail.inMyStore == 1,
                  status: _bottomButtonStatus,
                  listener: (status) {
                    _onTapShare();
                  },
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    if (_goodsDetail.goodsSkus.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          await _showSkuBottomSheet(
                            context,
                            model,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Variations',
                                      style: TextStyle(
                                        color: AppTheme.color0F1015,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _skuTitle,
                                            style: TextStyle(
                                              color: AppTheme.color0F1015,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 8,
                                        // ),
                                        // Expanded(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 8.0),
                                        //     child: Text(
                                        //       _selectedSkuDesc,
                                        //       maxLines: 2,
                                        //       textAlign: TextAlign.right,
                                        //       style: TextStyle(
                                        //         color: AppTheme.color555764,
                                        //         fontSize: 12,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: AppTheme.color555764,
                              ),
                            ],
                          ),
                        ),
                      ),
                    Divider(
                      color: AppTheme.colorE7E8EC,
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _showDeliveryBottomSheet(
                          context,
                          model,
                          _shareButtonTitle,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedExpress != null
                                        ? _selectedExpress.name +
                                            ' ' +
                                            _formatPrice(
                                                _selectedExpress.price,
                                                Global.getUser(context)
                                                    .monetaryUnit)
                                        : 'Free Shipping',
                                    style: TextStyle(
                                      color: AppTheme.color0F1015,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image(image: R.image.icon_airplane()),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            _formatShippingMessage(
                                              _goodsDetail.shippedFrom,
                                              _goodsDetail.shippedTo,
                                              _selectedExpress,
                                            ),
                                            style: TextStyle(
                                              color: AppTheme.color555764,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: AppTheme.color555764,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_goodsDetail.serviceConfigs.isNotEmpty)
                      Divider(
                        color: AppTheme.colorE7E8EC,
                        height: 1,
                      ),
                    if (_goodsDetail.serviceConfigs.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          await _showServiceBottomSheet(
                              context, model, _shareButtonTitle);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service',
                                      style: TextStyle(
                                        color: AppTheme.color0F1015,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _goodsDetail.serviceConfigs
                                                .map((e) => e.title)
                                                .join(', '),
                                            style: TextStyle(
                                              color: AppTheme.color555764,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: AppTheme.color555764,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
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
            ],
          ),
        ),
      ),
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

  Future<void> _showSkuBottomSheet(
      BuildContext context, _ViewModel viewModel) async {
    await showProductAttributesBottomSheet(
      context,
      ProductAttributesViewModel(
        currency: Global.getUser(context).monetaryUnit,
        model: _goodsDetail,
        quantity: 1,
        buttonTitle: _shareButtonTitle,
        selectedSku: _selectedSku,
        onSkuChanged: (sku) {
          _selectedSku = sku;
          // debugPrint('onSkuChanged >>> ${sku.toString()}');
          // List<String> skuSpecIds = _selectedSku.skuSpecIds.split('_');
          // if (skuSpecIds.length != _goodsDetail.specList.length) {
          //   return;
          // }

          // List<String> specDescs = [];
          // for (int i = 0; i < _goodsDetail.specList.length; i++) {
          //   final spec = _goodsDetail.specList[i];
          //   final specValue = spec.specValues.firstWhere(
          //     (e) => e.id.toString() == skuSpecIds[i],
          //     orElse: () => null,
          //   );
          //   if (specValue != null) {
          //     specDescs.add('${spec.specName}(${specValue.specValue})');
          //   }
          // }
          // setState(() {
          //   _selectedSkuDesc = specDescs.join(', ');
          // });
        },
        onTapAction: (skuSpecIds, isCustomiz, customiz) {
          _onTapShare();
        },
      ),
    );
  }

  Future<void> _showDeliveryBottomSheet(
      BuildContext context, _ViewModel viewModel, String buttonTitle) async {
    if (_goodsDetail.expressTemplete.isEmpty) {
      EasyLoading.showToast('No shipping');
      return;
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        builder: (context) {
          return _DeliveryOptionView(
            shippedFrom: _goodsDetail.shippedFrom,
            shippedTo: _goodsDetail.shippedTo,
            list: _goodsDetail.expressTemplete,
            onChanged: (value) {
              setState(() {
                _selectedExpress = value;
              });
            },
            onTapAddToCart: _onTapShare,
            defaultExpress: _selectedExpress,
            currency: Global.getUser(context).monetaryUnit,
            buttonTitle: buttonTitle,
          );
        },
        isDismissible: true);
  }

  Future<void> _showServiceBottomSheet(
      BuildContext context, _ViewModel viewModel, String buttonTitle) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        builder: (context) {
          return _ServiceView(
            list: _goodsDetail.serviceConfigs,
            onTapAddToCart: _onTapShare,
            buttonTitle: buttonTitle,
          );
        },
        isDismissible: true);
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

class _DeliveryOptionView extends StatefulWidget {
  final String shippedFrom;
  final String shippedTo;
  final List<ExpressTemplete> list;
  final Function(ExpressTemplete) onChanged;
  final String buttonTitle;
  final VoidCallback onTapAddToCart;
  final ExpressTemplete defaultExpress;
  final String currency;

  _DeliveryOptionView(
      {Key key,
      @required this.shippedFrom,
      @required this.shippedTo,
      @required this.list,
      @required this.onChanged,
      @required this.buttonTitle,
      @required this.onTapAddToCart,
      @required this.currency,
      this.defaultExpress})
      : super(key: key);

  @override
  __DeliveryOptionViewState createState() => __DeliveryOptionViewState();
}

class __DeliveryOptionViewState extends State<_DeliveryOptionView> {
  ExpressTemplete _expressGroupValue;

  @override
  void initState() {
    super.initState();
    _expressGroupValue = widget.defaultExpress ?? widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Delivery Opention',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.color0F1015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        primary: AppTheme.colorC4C5CD,
                        padding: EdgeInsets.all(1),
                      ),
                      child: Image(
                        image: R.image.icon_close(),
                        width: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final model = widget.list[index];
                final price = _formatPrice(model.price, widget.currency);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: RadioListTile(
                    value: model,
                    groupValue: _expressGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _expressGroupValue = value;
                      });
                      widget.onChanged(model);
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${model.name} $price',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.color0F1015,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      _formatShippingMessage(
                          widget.shippedFrom, widget.shippedTo, model),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.color555764,
                      ),
                    ),
                    activeColor: Color(0xFFFFA700),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: AppTheme.colorC4C5CD, height: 1);
              },
              itemCount:
                  widget.list.length, //view_model.expressTemplete.length,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: IdolButton(
                widget.buttonTitle,
                listener: (status) {
                  Navigator.of(context).pop();
                  widget.onTapAddToCart();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceView extends StatelessWidget {
  final List<ServiceConfig> list;
  final String buttonTitle;
  final VoidCallback onTapAddToCart;

  const _ServiceView({
    Key key,
    @required this.list,
    @required this.buttonTitle,
    @required this.onTapAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 210 / 375 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: R.image.icon_service(),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shop with Confidence',
                          style: TextStyle(
                            color: AppTheme.colorED8514,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'We provids guarantess to all Olaak purchases',
                          style: TextStyle(
                            color: AppTheme.colorED8514,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          primary: AppTheme.colorC4C5CD,
                          padding: EdgeInsets.all(1),
                        ),
                        child: Image(
                          image: R.image.icon_close(),
                          width: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildTile(list[index]);
              },
              itemCount: list.length,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: IdolButton(
                buttonTitle,
                listener: (status) {
                  Navigator.of(context).pop();
                  if (onTapAddToCart != null) {
                    onTapAddToCart();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ServiceConfig model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
      ),
    );
  }
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
