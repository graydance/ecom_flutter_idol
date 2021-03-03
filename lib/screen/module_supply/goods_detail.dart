import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:redux/redux.dart';
import 'package:idol/widgets/loading.dart';

/// 产品详情页
class GoodsDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsDetailScreenState();
}

class _GoodsDetailScreenState extends State<GoodsDetailScreen> {
  String _bottomButtonText = 'Add to my store';
  String _goodsId;
  String _supplierId = '';
  String _supplierName = '';
  IdolButtonStatus _bottomButtonStatus = IdolButtonStatus.normal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        GoodsDetailArguments arguments = store.state.goodsDetailArguments;
        if (arguments.goodsId == null) {
          EasyLoading.showToast('SupplierId is null.');
          IdolRoute.pop(context);
        } else {
          _goodsId = arguments.goodsId;
          _supplierId = arguments.supplierId;
          store.dispatch(
              GoodsDetailAction(GoodsDetailRequest(_supplierId, _goodsId)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onGoodsDetailStateChanged(
            newVM == null ? oldVM._goodsDetailState : newVM._goodsDetailState);
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            actions: [
              ...(vm._goodsDetailState is GoodsDetailSuccess)
                  ? [
                      FollowButton(
                        _supplierId,
                        defaultFollowStatus:
                            (vm._goodsDetailState as GoodsDetailSuccess)
                                        .goodsDetail
                                        .followStatus ==
                                    0
                                ? FollowStatus.unFollow
                                : FollowStatus.following,
                        buttonStyle: FollowButtonStyle.text,
                      ),
                    ]
                  : [],
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colours.color_444648,
                ),
                onPressed: () => IdolRoute.startSupplySearch(context),
              )
            ],
            title: Text(
              _supplierName,
              style: TextStyle(fontSize: 16, color: Colours.color_29292B),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colours.color_444648,
                size: 16,
              ),
              onPressed: () => IdolRoute.pop(context),
            ),
          ),
          body: _buildBodyWidget(vm),
          bottomNavigationBar: // Add to my store.
              IdolButton(
            _bottomButtonText,
            status: _bottomButtonStatus,
            listener: (status) {
              vm._addToMyStore(_goodsId);
            },
          ),
        );
      },
    );
  }

  void _onGoodsDetailStateChanged(GoodsDetailState state) {
    if (state is GoodsDetailFailure) {
      EasyLoading.showError((state).message);
    } else if (state is GoodsDetailSuccess) {
      EasyLoading.dismiss();
    }
  }

  Widget _buildBodyWidget(_ViewModel vm) {
    if (vm._goodsDetailState is GoodsDetailInitial ||
        vm._goodsDetailState is GoodsDetailLoading) {
      return IdolLoadingWidget();
    } else if (vm._goodsDetailState is GoodsDetailFailure) {
      return IdolErrorWidget(() {
        // Retry supplierInfo.
        vm._goodsDetail(_supplierId, _goodsId);
      });
    } else {
      GoodsDetail goodsDetail =
          (vm._goodsDetailState as GoodsDetailSuccess).goodsDetail;
      _supplierId = goodsDetail.supplierId;
      _supplierName = goodsDetail.supplierName;
      _bottomButtonStatus = goodsDetail.inMyStore == 0
          ? IdolButtonStatus.enable
          : IdolButtonStatus.disable;
      _bottomButtonText = goodsDetail.inMyStore == 0
          ? 'Add to my store'
          : 'Has been added to my store';
      return SingleChildScrollView(
        child: Container(
          //padding: EdgeInsets.all(15),
          color: Colours.color_F8F8F8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image|Video source.
              Container(
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
                                  goodsDetail.goods[index]);
                            },
                            pagination: SwiperPagination(
                                alignment: Alignment.bottomLeft,
                                builder: FractionPaginationBuilder(
                                  activeFontSize: 10,
                                  fontSize: 10,
                                  color: Colours.white,
                                  activeColor: Colours.white,
                                )),
                            itemCount: goodsDetail.goods.length,
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
                                  '${goodsDetail.collectNum} Liked');
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
                                    _formatNum(goodsDetail.collectNum),
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
                                  '${goodsDetail.soldNum} Sold');
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
                                    _formatNum(goodsDetail.soldNum),
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
                padding: EdgeInsets.all(15),
                color: Colours.white,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 5,
                      children: goodsDetail.tag.map((tag) {
                        return Container(
                          padding: EdgeInsets.only(left: 1, right: 1),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colours.color_48B6EF, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            tag.interestName,
                            style: TextStyle(
                                color: Colours.color_48B6EF, fontSize: 12),
                          ),
                        );
                      }).toList(),
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
                                    goodsDetail.earningPriceStr ??
                                '0.00',
                            style: TextStyle(
                                color: Colours.color_EA5228, fontSize: 20),
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
                                    goodsDetail.suggestedPriceStr ??
                                '0.00',
                            style: TextStyle(
                                color: Colours.color_0F1015, fontSize: 14),
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
              SizedBox(
                height: 10,
              ),

              Container(
                color: Colours.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Product Description',
                      style: TextStyle(
                        color: Colours.color_030406,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Shopping description.
                    Html(
                        data: goodsDetail.goodsDescription,
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
      );
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

class _ViewModel {
  final GoodsDetailState _goodsDetailState;
  final Function(String, String) _goodsDetail;
  final Function(String) _addToMyStore;

  _ViewModel(this._goodsDetailState, this._goodsDetail, this._addToMyStore);

  static _ViewModel fromStore(Store<AppState> store) {
    void _goodsDetail(String supplierId, String goodsId) {
      store
          .dispatch(GoodsDetailAction(GoodsDetailRequest(supplierId, goodsId)));
    }

    void _addToMyStore(String goodsId) {
      store.dispatch(AddStoreRequest(goodsId));
    }

    return _ViewModel(
        store.state.goodsDetailState, _goodsDetail, _addToMyStore);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _goodsDetailState == other._goodsDetailState;

  @override
  int get hashCode => _goodsDetailState.hashCode;
}
