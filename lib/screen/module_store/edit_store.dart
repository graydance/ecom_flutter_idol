import 'dart:io';
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
  IdolButtonStatus _saveButtonStatus = IdolButtonStatus.normal;
  TextEditingController _storeNameController;
  TextEditingController _userNameController;
  TextEditingController _storeDescController;
  FocusNode _storeNameFocusNode;
  FocusNode _userNameFocusNode;
  FocusNode _storeDescFocusNode;
  String _storeBackground;
  File _storeBackgroundFile;
  String _portrait;
  File _portraitFile;
  final _picker = ImagePicker();
  User _myInfo;
  String _storeNameErrorText = '';
  String _userNameErrorText = '';
  String _storeDescErrorText = '';
  bool _storeNameValid = false;
  bool _userNameValid = false;
  bool _updating = false;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _storeNameController =
        TextEditingController(text: Global.getUser(context).storeName ?? '');
    _storeNameFocusNode = FocusNode(debugLabel: '_storeNameFocusNode');
    _storeNameFocusNode.addListener(() {
      if (!_storeNameFocusNode.hasFocus && !_updating) {
        // checkName
        if (_storeNameController.text == null ||
            _storeNameController.text.isEmpty) {
          return;
        }
        _checkName(CheckNameRequest(storeName: _storeNameController.text));
      }
    });
    _userNameController =
        TextEditingController(text: Global.getUser(context).userName ?? '');
    _userNameFocusNode = FocusNode(debugLabel: '_userNameFocusNode');
    _userNameFocusNode.addListener(() {
      if (!_storeNameFocusNode.hasFocus && !_updating) {
        if (_userNameController.text == null ||
            _userNameController.text.isEmpty) {
          return;
        }
        // checkName
        _checkName(CheckNameRequest(storeName: _userNameController.text));
      }
    });
    _storeDescController =
        TextEditingController(text: Global.getUser(context).aboutMe ?? '');
    _storeDescFocusNode = FocusNode(debugLabel: '_storeDescFocusNode');
    _storeDescFocusNode.addListener(() {
      if (!_storeDescFocusNode.hasFocus) {
        _changeSaveButtonStatus();
      }
    });
  }

  void _checkName(CheckNameRequest checkNameRequest) {
    DioClient.getInstance()
        .post(ApiPath.checkName, baseRequest: checkNameRequest)
        .whenComplete(() => null)
        .then((data) {
      if (checkNameRequest.storeName != null &&
          checkNameRequest.storeName.isNotEmpty) {
        _storeNameValid = true;
      } else {
        _userNameValid = true;
      }
      setState(() {
        _changeSaveButtonStatus();
      });
    }).catchError((err) {
      print(err.toString());
      setState(() {
        if (checkNameRequest.storeName != null &&
            checkNameRequest.storeName.isNotEmpty) {
          _storeNameErrorText = 'This name has already been taken.';
        } else {
          _userNameErrorText = 'This name has already been taken.';
        }
      });
    });
  }

  void _changeSaveButtonStatus() {
    _saveButtonStatus = _storeNameController.text != null &&
            _storeNameController.text.isNotEmpty &&
            _userNameController.text != null &&
            _userNameController.text.isNotEmpty &&
            _storeNameValid &&
            _userNameValid &&
            _storeDescController.text != null &&
            _storeDescController.text.isNotEmpty
        ? IdolButtonStatus.enable
        : IdolButtonStatus.disable;
  }

  @override
  Widget build(BuildContext context) {
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
                              focusNode: _storeDescFocusNode,
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
                              status: _saveButtonStatus,
                              listener: (status) {
                                if (status == IdolButtonStatus.enable) {
                                _updating = true;
                                  _clearFocus();
                                  vm._editStore(
                                      _storeNameController.text,
                                      _userNameController.text,
                                      _storeDescController.text,
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
      _updating = false;
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
      EasyLoading.show(status: 'No image selected.');
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

  void _upload(File croppedFile, int type) {
    DioClient.getInstance().upload(ApiPath.upload, File(croppedFile.path),
        onSendProgress: (send, total) {
      EasyLoading.showProgress(send / total, status: 'Uploading...');
    }).then((data) {
      debugPrint('upload success >>> $data');
      Upload upload = Upload.fromMap(data);
      if (upload != null && upload.list != null && upload.list.isNotEmpty) {
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
    }).catchError((err) {
      // then | catchError | whenComplete 期待的函数返回类型是Future<Null>
      // 如果使用单行写法会有隐式return 关键字，如果在执行代码期间出现异常，具体异常不会抛出
      // 反而会抛出 Unhandled Exception: type 'Future<void>' is not a subtype of type 'Future<Null>?'
      // 禁止使用 => 后，具体异常便可以抛出。
      EasyLoading.showError(err.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _clearFocus();
    _storeNameFocusNode.dispose();
    _userNameFocusNode.dispose();
    _storeDescFocusNode.dispose();
    _storeNameController.dispose();
    _storeDescController.dispose();
    _userNameController.dispose();
  }

  void _clearFocus() {
    _storeNameFocusNode.unfocus();
    _userNameFocusNode.unfocus();
    _storeDescFocusNode.unfocus();
  }
}

class _ViewModel {
  final MyInfoState _myInfoState;
  final EditStoreState _editStoreState;
  final Function(String, String, String, {String storePicture, String portrait})
      _editStore;

  _ViewModel(this._myInfoState, this._editStoreState, this._editStore);

  static _ViewModel fromStore(Store<AppState> store) {
    void _editStore(
      storeName,
      userName,
      aboutMe, {
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
