import 'dart:io';
import 'package:idol/conf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    if ((vm._forYouState is ForYouInitial ||
        vm._forYouState is ForYouLoading)) {
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
            itemCount:
                (vm._forYouState as ForYouSuccess).goodsDetailList.list.length,
            itemBuilder: (context, index) => FollowingGoodsListItem(
              goodsDetail: (vm._forYouState as ForYouSuccess)
                  .goodsDetailList
                  .list[index],
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
    showModalBottomSheet(
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
}

class _ViewModel {
  final ForYouState _forYouState;
  final Function(int) _load;

  _ViewModel(this._forYouState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int page) {
      store.dispatch(ForYouAction(FollowingForYouRequest(1, page, limit: 10)));
    }

    print('************************************** reload from store');

    return _ViewModel(store.state.forYouState, _load);
  }
}
