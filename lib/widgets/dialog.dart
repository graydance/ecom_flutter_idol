import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:idol/widgets/rating_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:ecomshare/ecomshare.dart';

/// Dialog
class IdolMessageDialog extends StatelessWidget {
  final String buttonText;
  final String message;
  final Function onClose;
  final Function onTap;

  const IdolMessageDialog(this.message,
      {Key key, this.buttonText = 'Next', this.onClose, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onClose(),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colours.color_0F1015),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                IdolButton(
                  buttonText,
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => onTap(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 列表Item被点击或选中
/// index：索引
/// T t 返回index对应Item绑定的元素
typedef OnItemSelectedListener<T> = void Function(int index, T t);

/// 选择支付方式弹窗
class SelectPaymentMethodsDialog extends StatefulWidget {
  final defaultSelectedIndex;
  final List<WithdrawType> withdrawType;
  final Function onClose;
  final OnItemSelectedListener<WithdrawType> onItemSelected;

  const SelectPaymentMethodsDialog(
    this.withdrawType, {
    this.defaultSelectedIndex = -1,
    this.onClose,
    this.onItemSelected,
  });

  @override
  State<StatefulWidget> createState() => _SelectPaymentMethodsDialogState();
}

class _SelectPaymentMethodsDialogState
    extends State<SelectPaymentMethodsDialog> {
  int _selectedItemIndex;
  WithdrawType _withdrawType;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => widget.onClose(),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Payment Methods',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colours.color_3B3F42,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  //水平子Widget之间间距
                  crossAxisSpacing: 0.0,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 5.0,
                  //GridView内边距
                  padding: EdgeInsets.all(30.0),
                  //一行的Widget数量
                  crossAxisCount: 2,
                  //子Widget宽高比例
                  childAspectRatio: 2.0,
                  //子Widget列表
                  children: _createPaymentMethodsWidgets(),
                ),
                IdolButton('Done',
                    status: IdolButtonStatus.enable,
                    width: 100,
                    height: 36, listener: (status) {
                  debugPrint(
                      '_selectedItemIndex：$_selectedItemIndex, _withdrawType：$_withdrawType');
                  widget.onItemSelected(_selectedItemIndex, _withdrawType);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createPaymentMethodsWidgets() {
    return widget.withdrawType
        .asMap()
        .map((key, value) {
          return MapEntry(
            key,
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItemIndex = key;
                    _withdrawType = value;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colours.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                            color: _selected(key)
                                ? Colours.color_4E9AE3
                                : Colours.white,
                            width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colours.color_40A2A2A2,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2,
                              spreadRadius: 0.5),
                        ],
                      ),
                      child: Image(
                        image: NetworkImage(value.portrait),
                        width: 65,
                        height: 24,
                      ),
                    ),
                    ...(_selected(key))
                        ? [
                            Align(
                              widthFactor: 6.2,
                              heightFactor: 0,
                              alignment: Alignment.topRight,
                              child:
                                  // Expanded(),
                                  Icon(
                                Icons.check_circle,
                                color: Colours.color_4E9AE3,
                                size: 15,
                              ),
                            ),
                          ]
                        : [],
                  ],
                ),
              ),
            ),
          );
        })
        .values
        .toList();
  }

  bool _selected(int currentIndex) {
    debugPrint(
        '_selected >>> currentIndex:$currentIndex | _selectedItemIndex:$_selectedItemIndex');
    if (_selectedItemIndex != null) {
      return currentIndex == _selectedItemIndex;
    } else {
      return widget.defaultSelectedIndex != null &&
          currentIndex == widget.defaultSelectedIndex;
    }
  }
}

/// 评分弹窗
class RatingDialog extends StatelessWidget {
  final Function onClose;
  final Function(String) onRate;

  const RatingDialog({Key key, this.onClose, this.onRate});

  @override
  Widget build(BuildContext context) {
    String rateValue;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onClose(),
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.clear,
                      color: Colours.color_40A2A2A2,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Let us know how we\'re doing!\nPlease rate our app and services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colours.color_3B3F42),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: RatingWidget(
                    onRatingUpdate: (value) => {rateValue = value},
                    normalImage: Icon(
                      Icons.star_border,
                      size: 25,
                      color: Colours.color_C4C5CD,
                    ),
                    selectImage: Icon(
                      Icons.star,
                      size: 25,
                      color: Colours.color_FFD457,
                    ),
                    selectAble: true,
                    count: 5,
                    maxRating: 10,
                    padding: 5,
                    value: 0,
                  ),
                ),
                IdolButton(
                  'Rate',
                  status: IdolButtonStatus.enable,
                  width: 100,
                  height: 36,
                  listener: (status) => onRate(rateValue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部选择弹窗
class BottomSheetDialog extends StatefulWidget {
  //按钮title
  final List<String> items;

  //点击事件回调 0开始
  final Function(int) onItemClick;

  //标题 可选
  final String title;

  BottomSheetDialog(
    this.items, {
    this.onItemClick,
    this.title,
  });

  @override
  _BottomSheetDialogState createState() => _BottomSheetDialogState();
}

class _BottomSheetDialogState extends State<BottomSheetDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.color_C4C5CD,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //有标题的情况下
          (widget.title != null && widget.title.length > 0)
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Text(
                    widget.title,
                    style: TextStyle(color: Colours.color_979AA9, fontSize: 14),
                  ),
                  decoration: BoxDecoration(
                    color: Colours.white,
                    border: Border(
                      bottom: BorderSide(color: Colours.color_E7E8EC, width: 1),
                    ),
                  ),
                )
              : Container(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((title) {
              int index = widget.items.indexOf(title);
              return GestureDetector(
                onTap: () {
                  IdolRoute.pop(context);
                  widget.onItemClick(index);
                },
                child: _createItem(title),
              );
            }).toList(),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: _createItem('Cancel'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _createItem(String title) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colours.black),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colours.color_E7E8EC, width: 1)),
      ),
    );
  }
}

/// 底部选择弹窗
class ShareDialog extends StatefulWidget {
  //标题 可选
  final String title;

  // Image/Video url
  final String mediaUrl;

  // 描述
  final String desc;

  // 提示
  final String tips;

  // 分享类型
  final ShareType shareType;

  // 分享按钮点击回调
  final Function(String channel) onShareButtonClick;

  // 分享渠道
  final String shareChannel;

  ShareDialog(this.title, this.mediaUrl, this.desc, this.shareType,
      this.onShareButtonClick,
      {this.tips, this.shareChannel});

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  List<String> _supportShareChannels = [];

  final Map<String, AssetImage> _supportChannelIconMap = {
    'Instagram': R.image.ic_share_instagram(),
    'Facebook': R.image.ic_share_facebook(),
    'Twitter': R.image.ic_share_twitter(),
    'Download': R.image.ic_share_download(),
    'Copy Link': R.image.ic_share_copy_link(),
    'System': R.image.ic_share_more(),
  };

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initSharePlatformState();
    if (ShareType.guide == widget.shareType ||
        ShareType.link == widget.shareType &&
            widget.mediaUrl.toLowerCase().endsWith('.mp4')) {
      _controller = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  Future<void> initSharePlatformState() async {
    List<String> supportChannels;
    try {
      supportChannels =
          await Ecomshare.getSupportedChannels(Ecomshare.MEDIA_TYPE_IMAGE);
    } on PlatformException {
      supportChannels = [];
    }
    if (!mounted) return;
    setState(() {
      if (supportChannels.length > 1 &&
          'System' == supportChannels[supportChannels.length - 1]) {
        supportChannels.insert(supportChannels.length - 2,
            widget.shareType == ShareType.link ? 'Copy Link' : 'Download');
      }
      _supportShareChannels = supportChannels;
      debugPrint('Share channels >>> ${_supportShareChannels.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: _createShareWidget(),
        ));
  }

  Widget _createShareWidget() {
    if (ShareType.goods == widget.shareType) {
      return _createGoodsShareWidget();
    } else if (ShareType.link == widget.shareType) {
      return _createLinkShareWidget();
    } else if (ShareType.guide == widget.shareType) {
      return _createGuideShareWidget(widget.shareChannel);
    } else {
      return IdolErrorWidget(
        () {
          IdolRoute.pop(context);
        },
        buttonText: 'Close',
        tipsText: 'Oh, sorry about the share widget error.',
      );
    }
  }

  Widget _createGoodsShareWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.only(bottom: 60, left: 30, right: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 18),
            decoration: BoxDecoration(
              color: Colours.color_949494,
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
            ),
            child: SizedBox(
              height: 4,
              width: 40,
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(
                color: Colours.color_0F1015,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colours.color_979AA9, fontSize: 14),
          ),
          Container(
            margin: EdgeInsets.only(left: 80, right: 80, top: 15, bottom: 10),
            child: AspectRatio(
              aspectRatio: 1.0, //_controller.value.aspectRatio,
              child: Image(image: NetworkImage(widget.mediaUrl),),
            ),
          ),
          Text(
            widget.tips,
            style: TextStyle(fontSize: 12, color: Colours.color_ED8514),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _createShareButton(),
            ),
        ],
      ),
    );
  }

  List<Widget> _createShareButton() {
    return _supportShareChannels.map((channel) {
      return GestureDetector(
        onTap: () {
          if (widget.onShareButtonClick != null) {
            widget.onShareButtonClick(channel);
          }
        },
        child: Column(
          children: [
            Image(
              image: _supportChannelIconMap[channel],
              width: 50,
              height: 50,
            ),
            Text(
              channel,
              style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _createLinkShareWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 18),
            decoration: BoxDecoration(
              color: Colours.color_949494,
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
            ),
            child: SizedBox(
              height: 4,
              width: 40,
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(
                color: Colours.color_979AA9,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colours.black,
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                    setState(() {});
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    child: AspectRatio(
                      aspectRatio: 270 / 140, //_controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Center(
                  child: _controller.value.initialized
                      ? Visibility(
                          visible: !_controller.value.isPlaying,
                          child: Image(
                            image: R.image.play(),
                            width: 50,
                            height: 50,
                          ),
                        )
                      : IdolLoadingWidget(),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 60, right: 60),
            child: Text(
              widget.desc,
              style: TextStyle(color: Colours.color_979AA9, fontSize: 12),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _createShareButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGuideShareWidget(String channel) {
    return Container(
      color: Colours.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
                color: Colours.color_979AA9,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.desc,
            style: TextStyle(color: Colours.color_979AA9, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
              color: Colours.black,
            ),
            child: Stack(
              children: [
                _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: 270 / 140, //_controller.value.aspectRatio
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        child: Text(
                          'The video resource failed to load or initialize',
                          style: TextStyle(
                              fontSize: 10, color: Colours.color_ED3544),
                        ),
                      ),
                Visibility(
                  visible: _controller.value.initialized,
                  child: Image(
                    image: _controller.value.isPlaying
                        ? R.image.pause()
                        : R.image.play(),
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          IdolButton('Go to $channel', status: IdolButtonStatus.enable,
              listener: (status) {
            if (widget.onShareButtonClick != null) {
              widget.onShareButtonClick(channel);
            }
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

enum ShareType {
  goods,
  link,
  guide,
}

/// 修改用户名
class ChangeUserNameDialog extends StatefulWidget {
  final String userName;
  final String linkDomain;
  final Function onCancel;
  final Function(String newUserName) onSave;

  ChangeUserNameDialog(
      this.userName, this.linkDomain, this.onCancel, this.onSave);

  @override
  State<StatefulWidget> createState() => _ChangeUserNameDialogState();
}

class _ChangeUserNameDialogState extends State<ChangeUserNameDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colours.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 7, bottom: 7, right: 12),
                  child: GestureDetector(
                    onTap: (){
                      IdolRoute.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: Colours.color_C4C5CD,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change Your UserName',
                        style: TextStyle(
                            fontSize: 16, color: Colours.color_0F1015),
                      ),
                      Text(
                        'Changing your username will change the link to your profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, color: Colours.color_979AA9),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (userName) {
                          setState(() {
                            // update IdolButtonStatus
                          });
                        },
                        style: TextStyle(
                            color: Colours.color_979AA9, fontSize: 16),
                        textAlign: TextAlign.start,
                        controller: _controller,
                        maxLength: 512,
                        maxLines: 1,
                        enabled: true,
                        cursorColor: Colours.color_979AA9,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.only(
                              left: 8, top: 12, right: 8, bottom: 12),
                          counterText: '',
                          filled: true,
                          fillColor: Colours.color_EDEEF0,
                          prefix: Text(
                            '${widget.linkDomain.replaceAll('https://', '')}',
                            style: TextStyle(
                                color: Colours.color_48B6EF, fontSize: 16),
                          ),
                          hintText: widget.userName,
                          hintStyle: TextStyle(
                              color: Colours.color_979AA9, fontSize: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colours.white),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      IdolButton(
                        'Save',
                        width: 160,
                        height: 44,
                        status: widget.userName == _controller.text.trim()
                            ? IdolButtonStatus.disable
                            : IdolButtonStatus.enable,
                        listener: (status) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (widget.onSave != null) {
                            widget.onSave(_controller.text.trim());
                          }
                        },
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
}
