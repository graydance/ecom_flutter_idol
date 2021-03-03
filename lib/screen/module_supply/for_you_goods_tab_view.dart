import 'dart:io';
import 'package:idol/conf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/env.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/widgets/dialog_share.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:idol/screen/module_supply/supply_goods_list_item.dart';

class ForYouTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForYouTabViewState();
}

class _ForYouTabViewState extends State<ForYouTabView>
    with AutomaticKeepAliveClientMixin<ForYouTabView> {
  List<GoodsDetail> _goodsDetailList = const [];
  RefreshController _refreshController;
  int _currentPage = 1;
  bool _enablePullUp = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(ForYouAction(FollowingForYouRequest(1, 1)));
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onFollowingStateChanged(
            newVM == null ? oldVM._forYouState : newVM._forYouState);
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    if ((vm._forYouState is ForYouInitial ||
            vm._forYouState is ForYouLoading) &&
        _goodsDetailList.isEmpty) {
      return IdolLoadingWidget();
    } else if (vm._forYouState is ForYouFailure) {
      return IdolErrorWidget(() {
        vm._load(1);
      });
    } else {
      return Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          header: MaterialClassicHeader(
            color: Colours.color_EA5228,
          ),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) {
              return Divider(
                height: 10,
                color: Colors.transparent,
              );
            },
            itemCount: _goodsDetailList.length,
            itemBuilder: (context, index) => FollowingGoodsListItem(
              goodsDetail: _goodsDetailList[index],
              onProductAddedStoreListener: (goodsDetail) {
                // setState(() {
                //_goodsDetailList.removeAt(index);
                // });
                _showShareGoodsDialog(goodsDetail);
              },
            ),
          ),
          onRefresh: () async {
            await Future(() {
              vm._load(1);
            });
          },
          onLoading: () async {
            await Future(() {
              vm._load(_currentPage + 1);
            });
          },
          controller: _refreshController,
        ),
      );
    }
  }

  void _showShareGoodsDialog(GoodsDetail goodsDetail) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShareDialog(
            'Share great posts in feed',
            goodsDetail.goods[0],
            'The product is now available in your store.\n share the news with your fans on social media to make money!',
            ShareType.goods,
            (shareChannel) {
              IdolRoute.pop(context);
              _createSaveDownloadPicturePath(goodsDetail.id).then((savePath) {
                DioClient.getInstance()
                    .download(
                  goodsDetail.goods[0],
                  savePath,
                )
                    .then((path) {
                  _showGuideDialog(
                    videoUrls[0],
                    shareChannel,
                    savePath,
                  );
                });
              });
            },
            tips:
                'Tips: Share your own pictures with product can increase 38% Sales.',
          );
        });
  }

  Future<String> _createSaveDownloadPicturePath(String id) async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path + id + '.jpg';
  }

  void _showGuideDialog(
      String guideVideoUrl, String shareChannel, String pictureLocalPath) {
    showDialog(
        context: context,
        builder: (context) {
          return ShareDialog(
            'How to share in $shareChannel',
            guideVideoUrl,
            '1. Go to my account in $shareChannel\n 2. Edit profile\n 3. Paste your shop link into Website',
            ShareType.guide,
            (sChannel) {
              Ecomshare.shareTo(
                  Ecomshare.MEDIA_TYPE_IMAGE, shareChannel, pictureLocalPath);
            },
            shareChannel: shareChannel,
          );
        });
  }

  void _onFollowingStateChanged(ForYouState state) {
    if (state is ForYouSuccess) {
      setState(() {
        if ((state).goodsDetailList.currentPage == 1) {
          _goodsDetailList = (state).goodsDetailList.list;
        } else {
          _goodsDetailList.addAll((state).goodsDetailList.list);
        }
        _currentPage = (state).goodsDetailList.currentPage;
        _enablePullUp = (state).goodsDetailList.currentPage !=
                (state).goodsDetailList.totalPage &&
            (state).goodsDetailList.totalPage != 0;
        if (_currentPage == 1) {
          _refreshController.refreshCompleted(resetFooterState: true);
        } else {
          _refreshController.loadComplete();
        }
      });
    } else if (state is ForYouFailure) {
      if (_currentPage == 1) {
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        _refreshController.loadComplete();
      }
      EasyLoading.showToast((state).message);
    }
  }
}

class _ViewModel {
  final ForYouState _forYouState;
  final Function(int) _load;

  _ViewModel(this._forYouState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int page) {
      store.dispatch(ForYouAction(FollowingForYouRequest(1, page, limit: 10)));
    }

    return _ViewModel(store.state.forYouState, _load);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _forYouState == other._forYouState;

  @override
  int get hashCode => _forYouState.hashCode;
}
