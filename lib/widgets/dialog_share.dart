import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:video_player/video_player.dart';

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

class MyPikVideo extends StatefulWidget {
  final VideoPlayerController controller;
  MyPikVideo(this.controller);
  @override
  State<StatefulWidget> createState() => _MyPikVideo();
}

class _MyPikVideo extends State<MyPikVideo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 270 / 140, //_controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            Center(
              child: widget.controller.value.initialized
                  ? widget.controller.value.isPlaying
                      ? Container(
                          width: 50,
                          height: 50,
                          color: Colors.transparent,
                        )
                      : Image(
                          image: R.image.play(),
                          width: 50,
                          height: 50,
                        )
                  : IdolLoadingWidget(),
            ),
          ],
        ));
  }
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
          _controller.setLooping(true);
          // _controller.play();
          setState(() {});
        });
    }
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
        supportChannels
            .add(widget.shareType == ShareType.link ? 'Copy Link' : 'Download');
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
              child: Image(
                image: NetworkImage(widget.mediaUrl),
              ),
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
                color: Colours.color_F8F8F8,
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              child: MyPikVideo(_controller)),
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              child: MyPikVideo(_controller)),
          SizedBox(
            height: 10,
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
    if (_controller != null) _controller.dispose();
    super.dispose();
  }
}

enum ShareType {
  goods,
  link,
  guide,
}
