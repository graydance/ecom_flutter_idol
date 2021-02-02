import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  double initialVolume;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    initialVolume = _controller.value.volume;
    _controller.setLooping(true);
    _controller.setVolume(0);
    _initializeVideoPlayerFuture = _controller.initialize()
      ..then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                //345 / 376,//_controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              ),
              _PlayPauseOverlay(
                controller: _controller,
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  onPressed: () {
                    var currentVolume = _controller.value.volume;
                    if (currentVolume == 0) {
                      _controller.setVolume(initialVolume);
                    } else {
                      _controller.setVolume(0);
                    }
                  },
                  icon: Icon(
                      _controller.value.volume == 0
                          ? Icons.volume_off
                          : Icons.volume_up,
                      color: Colours.white),
                ),
              ),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(
              child: Container(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
            ),
          ));
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Center(
                  child: Image(
                    image: R.image.play(),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            var playing = controller.value.isPlaying;
            debugPrint('click play: $playing');
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              // If the video is paused, play it.
              controller.play();
            }
          },
        ),
      ],
    );
  }
}
