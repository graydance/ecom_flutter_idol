import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/models/models.dart';
import 'package:idol/models/upload.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/biolinks.dart';
import 'package:idol/net/request/store.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_store/image_crop.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';

class EditStoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final GlobalKey<IdolButtonState> _saveButtonKey =
      GlobalKey(debugLabel: '_saveButtonKey');
  IdolButtonStatus _saveButtonStatus = IdolButtonStatus.normal;
  TextEditingController _storeNameController;
  TextEditingController _userNameController;
  TextEditingController _storeDescController;
  FocusNode _storeNameFocusNode;
  FocusNode _userNameFocusNode;
  String _storeNameErrorText = '';
  String _userNameErrorText = '';
  String _storeDescErrorText = '';

  // 店招背景图Url
  String _storeBackground;

  // 店招背景Local File
  File _storeBackgroundFile;

  // 个人头像Url
  String _portrait;

  // 个人头像Local File
  File _portraitFile;

  // 图片选择器
  final _picker = ImagePicker();

  // 当前用户个人信息
  User _myInfo;

  // 店铺名称是否合法
  bool _storeNameValid = true;

  // 用户名是否合法
  bool _userNameValid = true;

  // 正在更新/保存
  bool _isUpdating = false;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _storeNameValid = Global.getUser(context).storeName != null &&
        Global.getUser(context).storeName.isNotEmpty;
    _userNameValid = Global.getUser(context).userName != null &&
        Global.getUser(context).userName.isNotEmpty;
    _storeNameController =
        TextEditingController(text: Global.getUser(context).storeName ?? '');
    _storeNameFocusNode = FocusNode(debugLabel: '_storeNameFocusNode');
    _storeNameFocusNode.addListener(() {
      if (!_storeNameFocusNode.hasFocus && !_isUpdating) {
        // checkName
        if (_storeNameController.text == null ||
            _storeNameController.text.trim().isEmpty ||
            _storeNameController.text.trim() == _myInfo?.storeName) {
          // 店铺名称为空或者未修改不进行查重
          debugPrint('StoreName is not modify, return.');
          return;
        }
        debounce(() {
          _checkName(
              CheckNameRequest(storeName: _storeNameController.text.trim()));
        }, 1000);
      }
    });
    _userNameController =
        TextEditingController(text: Global.getUser(context).userName ?? '');
    _userNameFocusNode = FocusNode(debugLabel: '_userNameFocusNode');
    _userNameFocusNode.addListener(() {
      if (!_userNameFocusNode.hasFocus && !_isUpdating) {
        if (_userNameController.text == null ||
            _userNameController.text.trim().isEmpty ||
            _userNameController.text.trim() == _myInfo?.userName) {
          // 用户名称为空或者未修改不进行查重
          debugPrint('UserName is not modify, return.');
          return;
        }
        // checkName
        debounce(() {
          _checkName(
              CheckNameRequest(userName: _userNameController.text.trim()));
        }, 1000);
      }
    });
    _storeDescController =
        TextEditingController(text: Global.getUser(context).aboutMe ?? '');
    _storeDescController.addListener(() {
      if (_storeDescController.text.trim() == _myInfo?.aboutMe) {
        debugPrint('Store description is not modify, return.');
        return;
      }
      _changeSaveButtonStatus();
    });
  }

  Future _checkName(CheckNameRequest checkNameRequest) async {
    try {
      await DioClient.getInstance()
          .post(ApiPath.checkName, baseRequest: checkNameRequest);
      setState(() {
        if (checkNameRequest.storeName != null &&
            checkNameRequest.storeName.isNotEmpty) {
          _storeNameValid = true;
        } else {
          _userNameValid = true;
        }
        _changeSaveButtonStatus();
        if (checkNameRequest.storeName != null &&
            checkNameRequest.storeName.isNotEmpty) {
          _storeNameErrorText = '';
        } else {
          _userNameErrorText = '';
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      setState(() {
        if (checkNameRequest.storeName != null &&
            checkNameRequest.storeName.isNotEmpty) {
          _storeNameValid = false;
          _storeNameErrorText = 'This name has already been taken.';
        } else {
          _userNameValid = false;
          _userNameErrorText = 'This name has already been taken.';
        }
      });
    }
  }

  void _changeSaveButtonStatus() {
    _saveButtonStatus = _storeNameController.text != null &&
            _storeNameController.text.trim().isNotEmpty &&
            _userNameController.text != null &&
            _userNameController.text.trim().isNotEmpty &&
            _storeNameValid &&
            _userNameValid &&
            _storeDescController.text != null &&
            _storeDescController.text.trim().isNotEmpty
        ? IdolButtonStatus.enable
        : IdolButtonStatus.disable;
    _saveButtonKey.currentState.updateButtonStatus(_saveButtonStatus);
    debugPrint("_saveButtonStatus >> $_saveButtonStatus");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('EditStoreScreen build...');
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onWillChange: (oldVM, newVM) {
        _onEditStoreStateChanged(
            newVM == null ? oldVM._editStoreState : newVM._editStoreState);
      },
      builder: (context, vm) {
        if (_myInfo == null && vm._myInfoState is MyInfoSuccess) {
          _myInfo = (vm._myInfoState as MyInfoSuccess).myInfo;
          _storeNameValid =
              _myInfo.storeName != null && _myInfo.storeName.isNotEmpty;
          _userNameValid =
              _myInfo.userName != null && _myInfo.userName.isNotEmpty;
          _storeBackground = _myInfo.storePicture;
          _portrait = _myInfo.portrait;
        }
        return Scaffold(
          //backgroundColor: Colours.white,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SingleChildScrollView(
            child: Container(
              //padding: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: Colours.white,
                image: DecorationImage(
                  image: _getStoreBackgroundImage(),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    elevation: 0,
                    title: Text(
                      'Edit Store',
                      style: TextStyle(color: Colours.white, fontSize: 16),
                    ),
                    centerTitle: true,
                    backgroundColor: Colours.transparent,
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colours.white,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 37,
                        color: Colours.white,
                      ),
                      onPressed: () {
                        _showImagePickerDialog(0);
                      }),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.only(top: 60, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colours.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Store Name',
                              style: TextStyle(
                                  color: Colours.color_3B3F42, fontSize: 14),
                            ),
                            TextField(
                              controller: _storeNameController,
                              focusNode: _storeNameFocusNode,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(
                                    RegExp(r"[a-zA-Z0-9]+|\s+|_")),
                              ],
                              maxLength: 50,
                              maxLines: 1,
                              cursorColor: Colours.color_EA5228,
                              decoration: InputDecoration(
                                errorText: _storeNameErrorText,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                              ),
                            ),
                            Text(
                              'UserName',
                              style: TextStyle(
                                  color: Colours.color_3B3F42, fontSize: 14),
                            ),
                            TextField(
                              controller: _userNameController,
                              focusNode: _userNameFocusNode,
                              maxLength: 128,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(
                                    RegExp(r"[a-zA-Z0-9]+|\s+|_")),
                              ],
                              maxLines: 1,
                              cursorColor: Colours.color_EA5228,
                              decoration: InputDecoration(
                                errorText: _userNameErrorText,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                              ),
                            ),
                            Text(
                              'Notice',
                              style: TextStyle(
                                  color: Colours.color_3B3F42, fontSize: 14),
                            ),
                            Text(
                              'Changing your username will automatically change the link to your store.',
                              style: TextStyle(
                                  color: Colours.color_B1B2B3, fontSize: 14),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Store Description',
                              style: TextStyle(
                                  color: Colours.color_3B3F42, fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _storeDescController,
                              maxLength: 512,
                              cursorColor: Colours.color_EA5228,
                              decoration: InputDecoration(
                                errorText: _storeDescErrorText,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colours.color_979797),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            IdolButton(
                              'Save',
                              key: _saveButtonKey,
                              status: _saveButtonStatus,
                              isPartialRefresh: true,
                              listener: (status) {
                                if (status == IdolButtonStatus.enable) {
                                  _isUpdating = true;
                                  _clearFocus();
                                  vm._editStore(
                                      storeName:
                                          _storeNameController.text.trim(),
                                      userName: _userNameController.text.trim(),
                                      aboutMe: _storeDescController.text.trim(),
                                      storePicture: _storeBackground,
                                      portrait: _portrait);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 26,
                        child: GestureDetector(
                          onTap: () => _showImagePickerDialog(1),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: _getPortrait(),
                                  ),
                                  border: Border.all(
                                      color: Colours.white, width: 1.0),
                                  color: Colours.color_F8F8F8,
                                ),
                              ),
                              Icon(
                                Icons.camera_alt,
                                size: 22,
                                color: Colours.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ImageProvider _getStoreBackgroundImage() {
    if (_storeBackgroundFile == null) {
      if (_myInfo != null &&
          _myInfo.storePicture != null &&
          _myInfo.storePicture.isNotEmpty) {
        return NetworkImage(_myInfo.storePicture);
      } else {
        return R.image.bg_header();
      }
    } else {
      return FileImage(_storeBackgroundFile);
    }
  }

  ImageProvider _getPortrait() {
    if (_portraitFile == null) {
      if (_myInfo != null &&
          _myInfo.portrait != null &&
          _myInfo.portrait.isNotEmpty) {
        return NetworkImage(_myInfo.portrait);
      } else {
        return R.image.default_portrait();
      }
    } else {
      return FileImage(_portraitFile);
    }
  }

  void _onEditStoreStateChanged(EditStoreState state) {
    if (state is EditStoreLoading) {
      EasyLoading.show(status: 'Updating...');
    } else if (state is EditStoreSuccess) {
      EasyLoading.showToast('Update successfully');
      IdolRoute.popWithCommand(context, Command.refreshMyInfo);
    } else if (state is EditStoreFailure) {
      EasyLoading.showError((state).message);
      _isUpdating = false;
    }
  }

  // 选择拍照/相册 type：0-店铺背景 1-头像
  void _showImagePickerDialog(int type) {
    _clearFocus();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  _getImage(ImageSource.camera, type);
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
                  _getImage(ImageSource.gallery, type);
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

  Future<Null> _getImage(ImageSource imageSource, int type) async {
    final pickedFile =
        await _picker.getImage(source: imageSource, imageQuality: 100);
    if (pickedFile != null) {
      debugPrint('select image path => ${pickedFile.path}');
      // 获取裁剪结果
      final result = await IdolRoute.startImageCrop(
          context,
          ImageCropArguments(pickedFile.path,
              cropType:
                  type == 0 ? CropType.storeBackground : CropType.avatar));
      if (result != null && result is Map) {
        if ((result)['isSuccess'] == true && (result)['filePath'] != null) {
          // File croppedFile = File( (result)['filePath']); Android7.0文件权限问题，会导致无法找到文件
          File croppedFile = File.fromUri(Uri.tryParse((result)['filePath']));
          _upload(croppedFile, type);
          // _upload2(croppedFile, type);
        }
      }
    } else {
      EasyLoading.showToast('No image selected.');
    }
  }

  void _upload2(File croppedFile, int type) async {
    var response = await DioClient.getInstance().upload(
        ApiPath.upload, File(croppedFile.path), onSendProgress: (send, total) {
      EasyLoading.showProgress(send / total, status: 'Uploading...');
    });
    debugPrint(response.toString());
    Upload upload = Upload.fromMap(response);
    if (upload != null && upload.list != null && upload.list.isNotEmpty) {
      EasyLoading.dismiss();
      // 上传成功...
      setState(() {
        debugPrint('setState refresh picture.');
        if (type == 0) {
          _storeBackground = upload.list[0].url;
          _storeBackgroundFile = croppedFile;
        } else {
          _portrait = upload.list[0].url;
          _portraitFile = croppedFile;
        }
      });
    }
  }

  void _upload(File croppedFile, int type) async {
    try {
      final data = await DioClient.getInstance()
          .upload(ApiPath.upload, File(croppedFile.path),
              onSendProgress: (send, total) {
        EasyLoading.showProgress(send.toDouble() / total.toDouble(),
            status: 'Uploading...');
      });

      Upload upload = Upload.fromMap(data);
      final String url = upload.list.first.url;
      if (url == null || url.isEmpty) {
        EasyLoading.dismiss();
        return EasyLoading.showError('Upload failed');
      }

      await DioClient.getInstance().post(ApiPath.updateUserInfo,
          baseRequest: UpdateUserInfoRequest(
            UpdateUserInfoFieldType.portrait,
            url,
          ));
      setState(() {
        if (type == 0) {
          _storeBackground = url;
          _storeBackgroundFile = croppedFile;
        } else {
          _portrait = url;
          _portraitFile = croppedFile;
        }
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _clearFocus();
    _storeNameFocusNode.dispose();
    _userNameFocusNode.dispose();
    _storeNameController.dispose();
    _storeDescController.dispose();
    _userNameController.dispose();
  }

  void _clearFocus() {
    _storeNameFocusNode.unfocus();
    _userNameFocusNode.unfocus();
  }

  Timer _debounce;

  Function debounce(Function fn, [int t = 30]) {
    return () {
      // 还在时间之内，抛弃上一次
      if (_debounce?.isActive ?? false) _debounce.cancel();

      _debounce = Timer(Duration(milliseconds: t), () {
        fn();
      });
    };
  }
}

class _ViewModel {
  final MyInfoState _myInfoState;
  final EditStoreState _editStoreState;
  final Function(
      {String storeName,
      String userName,
      String aboutMe,
      String storePicture,
      String portrait}) _editStore;

  _ViewModel(this._myInfoState, this._editStoreState, this._editStore);

  static _ViewModel fromStore(Store<AppState> store) {
    void _editStore({
      storeName,
      userName,
      aboutMe,
      storePicture,
      portrait,
    }) {
      store.dispatch(EditStoreAction(EditStoreRequest(
          storeName, userName, aboutMe,
          storePicture: storePicture, portrait: portrait)));
    }

    return _ViewModel(
        store.state.myInfoState, store.state.editStoreState, _editStore);
  }
}
