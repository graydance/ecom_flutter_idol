import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:idol/conf.dart';
import 'package:idol/env.dart';
import 'package:idol/models/models.dart';
import 'package:idol/models/upload.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/biolinks.dart';
import 'package:idol/net/request/store.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_shoplink/shoplink_goods_list_item.dart';
import 'package:idol/screen/module_store/image_crop.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/dialog_bottom_sheet.dart';
import 'package:idol/widgets/dialog_change_username.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class ShopLinkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopLinkPageState();
}

class _ShopLinkPageState extends State<ShopLinkPage>
    with AutomaticKeepAliveClientMixin<ShopLinkPage> {
  RefreshController _refreshController;
  int _currentPage = 1;
  bool _enablePullUp = false;
  String _userName;
  String _avatar;
  TextEditingController _shopDescController;
  final _shopDescFocusNode = FocusNode();
  final _picker = ImagePicker();
  bool _editState = true;
  bool _shopDescIsEditing = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('Following build complete.');
    });
    _userName = Global.getUser(context).userName;
    _avatar = Global.getUser(context).portrait;
    _shopDescController =
        TextEditingController(text: Global.getUser(context).aboutMe ?? '');
    _shopDescFocusNode.addListener(() {
      setState(() {
        _shopDescIsEditing = _shopDescFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        debugPrint('>>>>>>>>>>>>>>>>>>>ShopLink build<<<<<<<<<<<<<<<<<<<');
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: Colours.color_F8F8F8,
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                AppBar(
                  title: Text('${Global.getUser(context).userName}\'s Shop'),
                  centerTitle: true,
                  elevation: 0,
                  primary: true,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colours.color_444648,
                        size: 20,
                      ),
                      onPressed: () => IdolRoute.startSettings(context),
                    ),
                  ],
                ),
                /*Expanded(child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildHeaderWidget(),
                    ),
                    SliverToBoxAdapter(
                      child: _buildWidget(vm),
                    ),
                  ],
                ),),*/
                _buildHeaderWidget(),
                Expanded(
                  child: _buildWidget(vm),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: _avatar != null && _avatar.length > 0
              ? NetworkImage(
                  _avatar,
                )
              : AssetImage('assets/images/avatar.png'),
          fit: BoxFit.fitWidth,
        ),
        border: Border.all(color: Colours.white, width: 1.0),
        color: Colours.color_F8F8F8,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  color: Colours.color_white50,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            IdolRoute.startInnerWebView(
                                context,
                                InnerWebViewArguments(
                                    '${Global.getUser(context).userName}\'s Shop',
                                    '$linkDomain$_userName'));
                          },
                          child: Text(
                            '$linkDomain$_userName',
                            style: TextStyle(
                              color: Colours.color_0F1015,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _editState,
                        child: GestureDetector(
                          child: Image(
                            image: R.image.ic_edit(),
                            width: 25,
                            height: 15,
                          ),
                          onTap: () {
                            if (_editState) {
                              _showEditUserNameDialog();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          ShareManager.showShareLinkDialog(
                              context, '$linkDomain$_userName');
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Colours.color_48B6EF,
                          ),
                          child: Text(
                            'Copy',
                            style:
                                TextStyle(color: Colours.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_editState) {
                            _showImagePickerDialog();
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: _avatar != null && _avatar.length > 0
                                      ? NetworkImage(_avatar)
                                      : AssetImage('assets/images/avatar.png'),
                                ),
                                border: Border.all(
                                    color: Colours.white, width: 1.0),
                                color: Colours.color_F8F8F8,
                              ),
                              child: _avatar != null && _avatar.length > 0
                                  ? null
                                  : Center(
                                      child: Text(
                                      _userName != null && _userName.isNotEmpty
                                          ? _userName[0].toUpperCase()
                                          : '',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white60),
                                    )),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Image(
                                image: R.image.edit_avatar(),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '@$_userName',
                        style: TextStyle(
                          color: Colours.white,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Colours.color_575859),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 24.0,
                          maxHeight: 84.0,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 30,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: _shopDescIsEditing
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _shopDescController,
                          focusNode: _shopDescFocusNode,
                          maxLength: 512,
                          style: TextStyle(
                            color: _shopDescIsEditing
                                ? Colours.color_0F1015
                                : Colors.white,
                            fontSize: 12,
                            shadows: _shopDescIsEditing
                                ? []
                                : [
                                    Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Colours.color_575859),
                                  ],
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Tap to add a shop description',
                            hintStyle: TextStyle(
                              color: _shopDescIsEditing
                                  ? Colours.color_black45
                                  : Colors.white,
                            ),
                          ).copyWith(counterText: ''),
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            StoreProvider.of<AppState>(context)
                                .dispatch(EditStoreAction(EditStoreRequest(
                              _userName,
                              _userName,
                              _shopDescController.text.trim(),
                            )));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserNameDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ChangeUserNameDialog(_userName, linkDomain, () {
            IdolRoute.pop(context);
          }, (newUserName) {
            // _checkName(CheckNameRequest(userName: newUserName));
            _changeName(UpdateUserInfoRequest(
                UpdateUserInfoFieldType.userName, newUserName));
          });
        });
  }

  Future _checkName(CheckNameRequest checkNameRequest) async {
    EasyLoading.show(status: 'Check UserName...');
    try {
      await DioClient.getInstance()
          .post(ApiPath.checkName, baseRequest: checkNameRequest);
      setState(() {
        _userName = checkNameRequest.userName;
      });
      EasyLoading.dismiss();
      IdolRoute.pop(context);
    } on DioError catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(e.toString());
    }
  }

  Future _changeName(UpdateUserInfoRequest request) async {
    EasyLoading.show(status: 'Update UserName...');
    try {
      await DioClient.getInstance()
          .post(ApiPath.updateUserInfo, baseRequest: request);
      setState(() {
        _userName = request.value;
      });
      EasyLoading.dismiss();
      IdolRoute.pop(context);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Widget _buildWidget(_ViewModel vm) {
    if (vm._myInfoGoodsListState is MyInfoGoodsListInitial ||
        vm._myInfoGoodsListState is MyInfoGoodsListLoading) {
      return IdolLoadingWidget();
    } else if (vm._myInfoGoodsListState is MyInfoGoodsListFailure) {
      return IdolErrorWidget(() {
        vm._loadGoods(Global.getUser(context).id, 1);
      });
    } else {
      return Container(
        color: Colours.color_F8F8F8,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          header: MaterialClassicHeader(
            color: Colours.color_EA5228,
          ),
          child: (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
                      .storeGoodsList
                      .list
                      .length ==
                  0
              ? _emptyGoodsWidget()
              : _hasGoodsWidget(vm),
          onRefresh: () async {
            await Future(() {
              vm._loadGoods(Global.getUser(context).id, 1);
            });
          },
          onLoading: () async {
            await Future(() {
              vm._loadGoods(Global.getUser(context).id, _currentPage + 1);
            });
          },
          controller: _refreshController,
        ),
      );
    }
  }

  Widget _hasGoodsWidget(_ViewModel vm) {
    final models = (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
        .storeGoodsList
        .list;
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(16),
      itemCount: (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
          .storeGoodsList
          .list
          .length,
      crossAxisCount: 4,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      itemBuilder: (context, index) => _Tile(
        currency: Global.getUser(context).monetaryUnit,
        model: models[index],
        size: _getSize(models[index]),
        onTap: () async {
          final completer = Completer();
          StoreProvider.of<AppState>(context).dispatch(GoodsDetailAction(
              GoodsDetailRequest(
                  (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
                      .storeGoodsList
                      .list[index]
                      .supplierId,
                  (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
                      .storeGoodsList
                      .list[index]
                      .id),
              completer));

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
        onLongPress: () {
          _shareOrRemoveGoods(
              vm,
              (vm._myInfoGoodsListState as MyInfoGoodsListSuccess)
                  .storeGoodsList
                  .list[index]);
        },
      ),
    );
  }

  Widget _emptyGoodsWidget() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) {
        return Divider(
          height: 10,
          color: Colors.transparent,
        );
      },
      itemCount: 1,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: R.image.bg_default_empty_goods_webp(),
              width: 170,
              height: 195,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You don\'t have any goods to display.',
              style: TextStyle(color: Colours.color_0F1015, fontSize: 16),
            ),
            SizedBox(
              height: 28,
            ),
            IdolButton(
              'Add and share',
              status: IdolButtonStatus.enable,
              listener: (status) {
                // go supply.
                StoreProvider.of<AppState>(context)
                    .dispatch(ChangeHomePageAction(0));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareOrRemoveGoods(_ViewModel vm, StoreGoods storeGoods) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSheetDialog(
          ['Share Product', 'Remove'],
          onItemClick: (index) {
            switch (index) {
              case 0:
                ShareManager.showShareGoodsDialog(context, storeGoods.picture);
                break;
              case 1:
                vm._deleteGoods(storeGoods.id);
                break;
              default:
                break;
            }
          },
        );
      },
    );
  }

  // 选择拍照/相册
  void _showImagePickerDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  _getImage(ImageSource.camera);
                  IdolRoute.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    'Camera',
                    style: TextStyle(color: Colours.black, fontSize: 18),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _getImage(ImageSource.gallery);
                  IdolRoute.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    'Gallery',
                    style: TextStyle(color: Colours.black, fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<Null> _getImage(ImageSource imageSource) async {
    final pickedFile =
        await _picker.getImage(source: imageSource, imageQuality: 100);
    if (pickedFile != null) {
      debugPrint('select image path => ${pickedFile.path}');
      // 获取裁剪结果
      final result = await IdolRoute.startImageCrop(context,
          ImageCropArguments(pickedFile.path, cropType: CropType.avatar));
      if (result != null && result is Map) {
        if ((result)['isSuccess'] == true && (result)['filePath'] != null) {
          // File croppedFile = File( (result)['filePath']); Android7.0文件权限问题，会导致无法找到文件
          File croppedFile = File.fromUri(Uri.tryParse((result)['filePath']));
          _upload(croppedFile);
        }
      }
    } else {
      EasyLoading.showToast('No image selected.');
    }
  }

  void _upload(File croppedFile) {
    DioClient.getInstance().upload(ApiPath.upload, File(croppedFile.path),
        onSendProgress: (send, total) {
      EasyLoading.showProgress(send / total, status: 'Uploading...');
    }).then((data) {
      debugPrint('upload success >>> $data');
      Upload upload = Upload.fromMap(data);
      if (upload != null && upload.list != null && upload.list.isNotEmpty) {
        debugPrint('setState refresh picture.');
        // 上传成功...
        setState(() {
          _avatar = upload.list[0].url;
        });
      }
    }).catchError((err) {
      EasyLoading.showError(err.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  _Size _getSize(StoreGoods item) {
    var screenWidth = (MediaQuery.of(context).size.width - 16 * 2 - 4 * 4) / 2;
    var height = item.height / item.width * screenWidth;
    return _Size(screenWidth, height);
  }

  @override
  bool get wantKeepAlive => true;
}

class _Size {
  const _Size(this.width, this.height);

  final double width;
  final double height;
}

class _Tile extends StatelessWidget {
  const _Tile({
    this.currency,
    this.model,
    this.size,
    this.onTap,
    this.onLongPress,
  });

  final String currency;
  final StoreGoods model;
  final _Size size;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
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
                  CachedNetworkImage(
                    placeholder: (context, _) => Image(
                      image: R.image.goods_placeholder(),
                      fit: BoxFit.cover,
                    ),
                    imageUrl: model.picture,
                    fit: BoxFit.cover,
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
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Row(
                      children: [
                        Image(
                          image: R.image.ic_pv(),
                          width: 12,
                          height: 8,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          _formatHeatRank(model.heatRank) ?? '0',
                          style: TextStyle(
                            color: Colours.white,
                            fontSize: 10,
                            shadows: [
                              Shadow(
                                offset: Offset(0.2, 0.2),
                                blurRadius: 3.0,
                                color: Colours.color_B1B2B3,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  // 已知问题：web无法同时支持maxLines和ellipsis，详见 https://github.com/flutter/flutter/issues/44802#issuecomment-555707104
                  Text(
                    '${model.goodsName}',
                    style: TextStyle(
                      color: Color(0xFF555764),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
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
                        width: 8,
                      ),
                      Text(
                        '$currency${model.originalPriceStr}',
                        style: TextStyle(
                          color: Color(0xFF979AA9),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                    ],
                  ),
                  if (model.tag.isNotEmpty)
                    SizedBox(
                      height: 8,
                    ),
                  Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: model.tag
                        .map(
                          (e) => TagView(
                            text: e.name.toUpperCase(),
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

  String _formatHeatRank(int heatRank) {
    if (heatRank >= 10000) {
      return (heatRank / 10000).toStringAsFixed(1) + "w";
    } else if (heatRank >= 1000) {
      return (heatRank / 1000).toStringAsFixed(1) + "k";
    } else {
      return heatRank.toString();
    }
  }
}

class TagView extends StatelessWidget {
  final String text;
  const TagView({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFED8514), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFED8514),
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final MyInfoState _myInfoState;
  final MyInfoGoodsListState _myInfoGoodsListState;
  final DeleteGoodsState _deleteGoodsState;
  final EditStoreState _editStoreState;
  final Function _fetchMyInfo;

  final Function(String, String, String) _editStore;
  final Function(String, int) _loadGoods;
  final Function(String) _deleteGoods;
  static ActionType actionType = ActionType.goodsList;

  _ViewModel(
    this._fetchMyInfo,
    this._editStore,
    this._loadGoods,
    this._deleteGoods,
    this._myInfoState,
    this._editStoreState,
    this._myInfoGoodsListState,
    this._deleteGoodsState,
  );

  static _ViewModel fromStore(Store<AppState> store) {
    void _loadGoods(String userId, int page) {
      actionType = ActionType.goodsList;
      store.dispatch(
          MyInfoGoodsListAction(MyInfoGoodsListRequest(userId, 0, page)));
    }

    /*void _checkUserName(String userName) {
      actionType = ActionType.checkUserName;
      store.dispatch()
    }*/

    void _editStore(String userName, String storeDesc, String portrait) {
      actionType = ActionType.editStore;
      store.dispatch(EditStoreAction(
          EditStoreRequest(userName, userName, storeDesc, portrait: portrait)));
    }

    void _fetchMyInfo() {
      actionType = ActionType.fetchMyInfo;
      store.dispatch(MyInfoAction(BaseRequestImpl()));
    }

    void _deleteGoods(String goodsId) {
      actionType = ActionType.deleteGoods;
      store.dispatch(DeleteGoodsAction(DeleteGoodsRequest(goodsId)));
    }

    return _ViewModel(
        _fetchMyInfo,
        _editStore,
        _loadGoods,
        _deleteGoods,
        store.state.myInfoState,
        store.state.editStoreState,
        store.state.myInfoGoodsListState,
        store.state.deleteGoodsState);
  }
}

enum ActionType {
  goodsList,
  deleteGoods,
  checkUserName,
  editStore,
  fetchMyInfo,
}
