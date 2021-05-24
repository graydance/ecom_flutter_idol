import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:ecomshare/ecomshare.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/res/theme.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:video_player/video_player.dart';

/// 底部选择弹窗
class ShareDialog extends StatefulWidget {
  //标题 可选
  final String title;

  // Image/Video url
  final List<String> mediaUrls;

  final String shareText;

  // 描述
  final String desc;

  // 提示
  final String tips;

  // 分享类型
  final ShareType shareType;

  // 分享按钮点击回调
  final Function(String channel, String shareText) onShareButtonClick;

  // 分享渠道
  final String shareChannel;

  ShareDialog(this.title, this.mediaUrls, this.desc, this.shareType,
      this.onShareButtonClick,
      {this.shareText, this.tips, this.shareChannel});

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class MyPikVideo extends StatefulWidget {
  final String mediaUrl;

  MyPikVideo(this.mediaUrl);

  @override
  State<StatefulWidget> createState() => _MyPikVideo();
}

class _MyPikVideo extends State<MyPikVideo> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    try {
      //widget.mediaUrl
      _videoPlayerController = VideoPlayerController.network(widget.mediaUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        autoInitialize: true,
        showControlsOnInitialize: false,
      );

      setState(() {});
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 270 / 140, //_controller.value.aspectRatio,
            child: _chewieController != null
                ? Chewie(
                    controller: _chewieController,
                  )
                : Container(),
          ),
        ),
        Center(
          child: _chewieController != null &&
                  _chewieController.videoPlayerController.value.isInitialized
              ? Container()
              : IdolLoadingWidget(),
        ),
      ],
    );
  }
}

class _ShareDialogState extends State<ShareDialog> {
  List<String> _supportShareChannels = [];
  TextEditingController _textEditingController;
  int _currentIndex = 0;

  final Map<String, AssetImage> _supportChannelIconMap = {
    'Instagram': R.image.ic_share_instagram(),
    'Facebook': R.image.ic_share_facebook(),
    'Twitter': R.image.ic_share_twitter(),
    'Download All': R.image.ic_share_download(),
    'Copy Link': R.image.ic_share_copy_link(),
    'System': R.image.ic_share_more(),
  };

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.shareText);
    super.initState();
    initSharePlatformState();
  }

  Future<void> initSharePlatformState() async {
    List<String> supportChannels;
    try {
      supportChannels = await Ecomshare.getSupportedChannels(
          widget.shareType == ShareType.link
              ? Ecomshare.MEDIA_TYPE_TEXT
              : Ecomshare.MEDIA_TYPE_IMAGE);
    } on PlatformException {
      supportChannels = [];
    }
    if (!mounted) return;
    setState(() {
      if (supportChannels.length > 1 && 'System' == supportChannels.last) {
        supportChannels.insert(supportChannels.length - 1,
            widget.shareType == ShareType.link ? 'Copy Link' : 'Download All');
      }
      _supportShareChannels = supportChannels;
      debugPrint('Share channels >>> ${_supportShareChannels.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 250),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Container(
                color: Colours.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: _createShareWidget(),
                ),
              ),
            )),
      ),
    );
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
    return Stack(
      children: [
        Container(
          height: 30.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          padding: EdgeInsets.only(bottom: 20, left: 15, right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 18),
                decoration: BoxDecoration(
                  color: Colours.color_C4C5CD,
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
                    fontSize: TextUtil.isEmpty(widget.title) ? 0 : 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: TextUtil.isEmpty(widget.desc) ? 0 : 10,
              ),
              Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colours.color_979AA9,
                    fontSize: TextUtil.isEmpty(widget.desc) ? 0 : 14),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(70, 0, 70, 10),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0, //_controller.value.aspectRatio,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            placeholder: (context, _) => Image(
                              image: R.image.goods_placeholder(),
                              fit: BoxFit.cover,
                            ),
                            imageUrl: widget.mediaUrls[index],
                            fit: BoxFit.contain,
                          );
                        },
                        pagination: SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: DotSwiperPaginationBuilder(
                              activeSize: 6,
                              size: 5,
                              color: Colours.color_50D8D8D8,
                              activeColor: Colours.white,
                            )),
                        itemCount: widget.mediaUrls.length,
                        onIndexChanged: (value) => _currentIndex = value,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          downloadImages(
                            context,
                            [widget.mediaUrls[_currentIndex]],
                          );
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Image(
                            image: R.image.ic_share_single_download(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: AppTheme.colorF4F4F4,
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 10,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Share Text',
                    hintStyle: TextStyle(
                      color: AppTheme.colorC4C5CD,
                      fontSize: 12,
                    ),
                  ),
                  maxLength: 1000,
                  buildCounter: (_, {currentLength, maxLength, isFocused}) =>
                      Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              currentLength.toString() +
                                  "/" +
                                  maxLength.toString(),
                              style: TextStyle(
                                color: AppTheme.colorC4C5CD,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: _textEditingController.text));
                            EasyLoading.showToast('Capture copied!');
                          },
                          child: Image(image: R.image.copy_sharetext()),
                        ),
                      ],
                    ),
                  ),
                  controller: _textEditingController,
                  maxLines: null,
                  style: TextStyle(
                    color: AppTheme.color555764,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.tips,
                style: TextStyle(
                    fontSize: TextUtil.isEmpty(widget.tips) ? 0 : 12,
                    color: Colours.color_ED8514),
              ),
              SizedBox(
                height: TextUtil.isEmpty(widget.tips) ? 5 : 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _createShareButton(),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _createShareButton() {
    return _supportShareChannels.map((channel) {
      return GestureDetector(
        onTap: () {
          if (widget.onShareButtonClick != null) {
            widget.onShareButtonClick(channel, _textEditingController.text);
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
              channel == "System" ? 'More' : channel,
              style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _createLinkShareWidget() {
    return Stack(
      children: [
        Container(
          height: 30.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 18),
          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 18),
                decoration: BoxDecoration(
                  color: Colours.color_C4C5CD,
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
                  margin: EdgeInsets.only(
                      left: 52.5, right: 52.5, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colours.color_F8F8F8,
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: MyPikVideo(widget.mediaUrls.first)),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 59.5, right: 59.5),
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
                padding: EdgeInsets.only(left: 29.5, right: 29.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _createShareButton(),
                ),
              ),
            ],
          ),
        )
      ],
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              child: MyPikVideo(widget.mediaUrls.first)),
          SizedBox(
            height: 10,
          ),
          IdolButton('Go to $channel', status: IdolButtonStatus.enable,
              listener: (status) {
            if (widget.onShareButtonClick != null) {
              widget.onShareButtonClick(channel, _textEditingController.text);
            }
          }),
        ],
      ),
    );
  }
}

enum ShareType {
  goods,
  link,
  guide,
}
