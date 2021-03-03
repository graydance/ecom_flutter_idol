import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:idol/net/request/store.dart';
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
  List<StoreGoods> _storeGoodsList = const [];
  RefreshController _refreshController;
  int _currentPage = 1;
  bool _enablePullUp = false;
  String _userName;
  String _avatar;
  TextEditingController _shopDescController;
  final _picker = ImagePicker();
  bool _editState = false;

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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(MyInfoGoodsListAction(
            MyInfoGoodsListRequest(Global.getUser(context).id, 0, 1)));
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        debugPrint(
            '>>>>>>>>>>>>>>>>>>>ShopLink onWillChange<<<<<<<<<<<<<<<<<<<');
        _onStateChanged(newVM == null ? oldVM : newVM);
      },
      builder: (context, vm) {
        debugPrint('>>>>>>>>>>>>>>>>>>>ShopLink build<<<<<<<<<<<<<<<<<<<');
        return Container(
          color: Colours.color_F8F8F8,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                title: Text('${Global.getUser(context).userName}\'s Shop'),
                centerTitle: true,
                elevation: 0,
                primary: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colours.color_444648,
                    size: 20,
                  ),
                  onPressed: () => IdolRoute.startSettings(context),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      if (_editState) {
                        vm._editStore(_userName,
                            _shopDescController.text.trim(), _avatar);
                      }
                      setState(() {
                        _editState = !_editState;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 16),
                      height: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _editState ? 'Done' : 'Edit Page',
                        style: TextStyle(
                            color: Colours.color_0F1015, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
        );
      },
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(
            _avatar,
          ),
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
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  color: Colours.color_white50,
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text('Link：'),
                          GestureDetector(
                            onTap: () {
                              if (_editState) {
                                _showEditUserNameDialog();
                              }
                            },
                            child: Text(
                              '$linkDomain$_userName',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colours.color_0F1015,
                                  fontSize: 14),
                            ),
                          ),
                          Visibility(
                            visible: _editState,
                            child: GestureDetector(
                              child: Image(
                                image: R.image.ic_edit(),
                                width: 15,
                                height: 15,
                              ),
                              onTap: () {
                                if (_editState) {
                                  _showEditUserNameDialog();
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                      ..._editState
                          ? []
                          : [
                              GestureDetector(
                                onTap: () {
                                  ShareManager.showShareLinkDialog(
                                      context, '$linkDomain$_userName');
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: Colours.color_48B6EF,
                                  ),
                                  child: Text(
                                    'Copy',
                                    style: TextStyle(
                                        color: Colours.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            ]
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
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(_avatar),
                            ),
                            border:
                                Border.all(color: Colours.white, width: 1.0),
                            color: Colours.color_F8F8F8,
                          ),
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
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _shopDescController,
                          maxLength: 512,
                          maxLines: 2,
                          enabled: _editState,
                          style: TextStyle(
                              color: Colours.color_0F1015, fontSize: 12),
                          cursorColor: Colours.color_EA5228,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            counterText: '',
                            filled: _editState,
                            fillColor: Colours.white,
                            hintText: 'Tap to add a shop description',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colours.white),
                            ),
                            disabledBorder: InputBorder.none,
                          ),
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
            _checkName(CheckNameRequest(userName: newUserName));
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
          child: _storeGoodsList == null || _storeGoodsList.isEmpty
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
    return StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(15),
        itemCount: _storeGoodsList.length,
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        staggeredTileBuilder: (int index) {
          // return StaggeredTile.count(1, 1.5);
          return StaggeredTile.count(1, index == 0 ? 1.55 : 1.8);
        },
        //physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ShopLinkGoodsListItem(
            index,
            _storeGoodsList[index],
            onItemClickCallback: () {
              // goods detail
              IdolRoute.startGoodsDetail(context,
                  _storeGoodsList[index].supplierId, _storeGoodsList[index].id);
            },
            onItemLongPressCallback: () {
              _shareOrRemoveGoods(vm, _storeGoodsList[index]);
            },
          );
        });
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
                IdolRoute.sendArguments<HomeTabArguments>(
                    context, HomeTabArguments(tabIndex: 0));
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
                vm._deleteGoods(storeGoods.idolGoodsId);
                break;
              default:
                break;
            }
          },
        );
      },
    );
  }

  void _onStateChanged(_ViewModel vm) {
    if (_ViewModel.actionType == ActionType.goodsList) {
      if (vm._myInfoGoodsListState is MyInfoGoodsListSuccess) {
        MyInfoGoodsListSuccess state = vm._myInfoGoodsListState;
        if ((state).storeGoodsList.currentPage == 1) {
          _storeGoodsList = (state).storeGoodsList.list;
        } else {
          _storeGoodsList.addAll((state).storeGoodsList.list);
        }
        _currentPage = (state).storeGoodsList.currentPage;
        _enablePullUp = (state).storeGoodsList.currentPage !=
                (state).storeGoodsList.totalPage &&
            (state).storeGoodsList.totalPage != 0;
        if (_currentPage == 1) {
          _refreshController.refreshCompleted(resetFooterState: true);
        } else {
          _refreshController.loadComplete();
        }
      } else if (vm._myInfoGoodsListState is MyInfoGoodsListFailure) {
        if (_currentPage == 1) {
          _refreshController.refreshCompleted(resetFooterState: true);
        } else {
          _refreshController.loadComplete();
        }
        EasyLoading.showError(
            (vm._myInfoGoodsListState as MyInfoGoodsListFailure).message);
      }
    } else if (_ViewModel.actionType == ActionType.editStore) {
      if (vm._editStoreState is EditStoreSuccess) {
        vm._fetchMyInfo();
      } else if (vm._editStoreState is EditStoreFailure) {
        EasyLoading.showError(
            (vm._editStoreState as UpdateUserInfoFailure).message);
      }
    } else if (_ViewModel.actionType == ActionType.deleteGoods) {
      if (vm._deleteGoodsState is DeleteGoodsSuccess) {
        debugPrint('vm._deleteGoodsState is DeleteGoodsSuccess');
      } else if (vm._deleteGoodsState is DeleteGoodsFailure) {
        EasyLoading.showError(
            (vm._deleteGoodsState as DeleteGoodsFailure).message);
      }
    } else if (_ViewModel.actionType == ActionType.fetchMyInfo) {
      if (vm._myInfoState is MyInfoSuccess) {
        debugPrint('vm._myInfoState is MyInfoSuccess');
      } else if (vm._myInfoState is MyInfoFailure) {
        EasyLoading.showError((vm._myInfoState as MyInfoFailure).message);
      }
    }
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

  @override
  bool get wantKeepAlive => true;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _myInfoState == other._myInfoState &&
          _myInfoGoodsListState == other._myInfoGoodsListState &&
          _deleteGoodsState == other._deleteGoodsState &&
          _editStoreState == other._editStoreState &&
          _fetchMyInfo == other._fetchMyInfo &&
          _editStore == other._editStore &&
          _loadGoods == other._loadGoods &&
          _deleteGoods == other._deleteGoods;

  @override
  int get hashCode =>
      _myInfoState.hashCode ^
      _myInfoGoodsListState.hashCode ^
      _deleteGoodsState.hashCode ^
      _editStoreState.hashCode ^
      _fetchMyInfo.hashCode ^
      _editStore.hashCode ^
      _loadGoods.hashCode ^
      _deleteGoods.hashCode;
}

enum ActionType {
  goodsList,
  deleteGoods,
  checkUserName,
  editStore,
  fetchMyInfo,
}
