import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/loading.dart';
import 'package:video_player/video_player.dart';

/// Dialog
class TipsGuideDialog extends StatefulWidget {
  final String storeKey;
  final String buttonText;
  final String title;
  final String desc;
  final String mediaUrl;
  final Function onClose;
  final Function onTap;

  const TipsGuideDialog(this.storeKey, this.title, this.desc, this.mediaUrl,
      {Key key, this.buttonText = 'Next', this.onClose, this.onTap});

  @override
  State<StatefulWidget> createState() => _TipsGuideDialogState();
}

class _TipsGuideDialogState extends State<TipsGuideDialog> {
  VideoPlayerController _controller;
  bool _neverShow = false;
  static final _storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.mediaUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.onClose != null) {
                      widget.onClose();
                    }
                  },
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
                Padding(
                  padding:
                      EdgeInsets.only(left: 50, right: 50, ),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colours.color_0F1015, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                            aspectRatio: 270 / 140,
                            //_controller.value.aspectRatio,
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
                Text(
                  widget.desc,
                  style: TextStyle(color: Colours.color_979AA9, fontSize: 12),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: this._neverShow,
                        activeColor: Colours.color_ED8514,
                        checkColor: Colours.white,
                        onChanged: (bool value) {
                          setState(() {
                            this._neverShow = value;
                            _storage.write(
                                key: widget.storeKey, value: value.toString());
                          });
                        }),
                    Text(
                      'Don\'t show this hint again.',
                      style:
                          TextStyle(color: Colours.color_979AA9, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 55, right: 55),
                  child: IdolButton(
                    widget.buttonText,
                    status: IdolButtonStatus.enable,
                    listener: (status) => widget.onTap(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
