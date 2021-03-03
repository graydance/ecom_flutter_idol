import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/ui.dart';
import 'package:idol/widgets/video_player_widget.dart';
import 'package:redux/redux.dart';
import 'package:idol/widgets/loading.dart';

/// 产品详情页
class GoodsDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsDetailScreenState();
}

class _GoodsDetailScreenState extends State<GoodsDetailScreen> {
  String _bottomButtonText = 'Add to my store & share';
  String _goodsId;
  String _supplierId = '';
  String _supplierName = '';
  IdolButtonStatus _bottomButtonStatus = IdolButtonStatus.normal;
  GlobalKey<IdolButtonState> _idolButtonStatusKey = GlobalKey();
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
          appBar:
          IdolUI.appBar(context, 'Details'),
          body: _buildBodyWidget(vm),
          extendBody: true,
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
          ? 'Add to my store & share'
          : 'Share';
      return SingleChildScrollView(
        child: Container(
          color: Colours.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5,
                            children: goodsDetail.tag.map((tag) {
                              return Container(
                                padding: EdgeInsets.only(left: 1, right: 1),
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          goodsDetail.updateTime??'',
                          style: TextStyle(
                              color: Colours.color_C4C5CD, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      goodsDetail.goodsName ?? '',
                      style:
                          TextStyle(color: Colours.color_555764, fontSize: 12),
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
                                    goodsDetail.suggestedPriceStr ??
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
                    SizedBox(height: 10,),
                    IdolButton(
                      _bottomButtonText,
                      status: _bottomButtonStatus,
                      key: _idolButtonStatusKey,
                      listener: (status) {
                        if(status == IdolButtonStatus.enable){
                          if(_bottomButtonText == 'Share'){

                          }else{
                            _addProductToMyStore(goodsDetail);
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        goodsDetail.goodsDescription,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }


  Future _addProductToMyStore(GoodsDetail goodsDetail) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await DioClient.getInstance()
          .post(ApiPath.addStore, baseRequest: AddStoreRequest(goodsDetail.id));
      EasyLoading.dismiss();
      _bottomButtonText = 'Share';
      _idolButtonStatusKey.currentState.updateText(_bottomButtonText);
      _idolButtonStatusKey.currentState.updateButtonStatus(_bottomButtonStatus);
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
}

class _ViewModel {
  final GoodsDetailState _goodsDetailState;
  final Function(String, String) _goodsDetail;

  _ViewModel(this._goodsDetailState, this._goodsDetail);

  static _ViewModel fromStore(Store<AppState> store) {
    void _goodsDetail(String supplierId, String goodsId) {
      store
          .dispatch(GoodsDetailAction(GoodsDetailRequest(supplierId, goodsId)));
    }
    return _ViewModel(
        store.state.goodsDetailState, _goodsDetail);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _goodsDetailState == other._goodsDetailState &&
          _goodsDetail == other._goodsDetail;

  @override
  int get hashCode => _goodsDetailState.hashCode ^ _goodsDetail.hashCode;
}
