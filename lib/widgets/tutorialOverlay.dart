import 'package:flutter/material.dart';
import 'package:idol/widgets/SpeechBubble.dart';

class TutorialOverlay extends StatefulWidget {
  final builder;
  final bool showOverlay;
  final String text;
  final Position position;
  final NipLocation bubblePosition;
  final int scale;
  TutorialOverlay(
      {this.builder,
      this.showOverlay = true,
      this.text = "",
      Key key,
      this.position = Position.BOTTOM_RIGHT,
      this.bubblePosition = NipLocation.BOTTOM,
      this.scale = 1})
      : super(key: key);
  static removeAll() {
    tutorialOverlays.forEach((overlay) {
      overlay.remove();
    });
    tutorialOverlays.clear();
  }

  @override
  State<StatefulWidget> createState() => TutorialOverlayState();
}

var tutorialOverlays = <OverlayEntry>[];
const double BUBBLE_NIP_HEIGHT = 10;
const HAND_POSITION_OFFSET = const Offset(20, 20);

class TutorialOverlayState extends State<TutorialOverlay> {
  var builderKey = GlobalKey();
  var bubbleEntryKey = GlobalKey();
  AnimationController controller;

  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showOverlay && tutorialOverlays.length == 0) {
        var screensize = MediaQuery.of(context).size;
        OverlayEntry bgEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: 0,
                top: 0,
                width: screensize.width,
                height: screensize.height,
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                )));
        tutorialOverlays.add(bgEntry);

        final RenderBox renderBoxTarget =
            builderKey.currentContext.findRenderObject();
        final targetSize = renderBoxTarget.size;
        final positionTarget = renderBoxTarget.localToGlobal(Offset.zero);
        OverlayEntry targetEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: positionTarget.dx,
                top: positionTarget.dy,
                width: targetSize.width,
                height: targetSize.height,
                child: widget.builder(ctx)));
        tutorialOverlays.add(targetEntry);

        controller = AnimationController(
          duration: Duration(milliseconds: 300),
          vsync: Overlay.of(context),
        );
        final Animation curve =
            CurvedAnimation(parent: controller, curve: Curves.easeOut);
        controller
          ..forward()
          ..addListener(() {
            if (!controller.isAnimating) {
              if (controller.value == 0) {
                controller.forward();
              } else {
                controller.reverse();
              }
            }
          });
        OverlayEntry handEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: widget.position == Position.BOTTOM_RIGHT
                    ? (positionTarget.dx +
                        targetSize.width / 2 -
                        HAND_POSITION_OFFSET.dx)
                    : (positionTarget.dx - targetSize.width),
                top: widget.position == Position.BOTTOM_RIGHT
                    ? (positionTarget.dy +
                        targetSize.height -
                        HAND_POSITION_OFFSET.dy)
                    : positionTarget.dy,
                height: widget.position == Position.BOTTOM_RIGHT
                    ? null
                    : targetSize.height,
                width: widget.position == Position.BOTTOM_RIGHT
                    ? targetSize.width
                    : null,
                child: AnimatedBuilder(
                    animation: curve,
                    builder: (context, child) => Transform.translate(
                          offset: Position.BOTTOM_RIGHT == widget.position
                              ? Offset(0, curve.value * 15)
                              : Offset(-curve.value * 15, 0),
                          child: child,
                        ),
                    child: Image.asset(
                      widget.position == Position.BOTTOM_RIGHT
                          ? 'assets/image/hand_rb.png'
                          : 'assets/image/hand_lb.png',
                      width: 40,
                      height: 51,
                    ))));
        tutorialOverlays.add(handEntry);

        OverlayEntry bubbleEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: _bubbleLeft(positionTarget, targetSize),
                top: _bubbleTop(positionTarget, targetSize, targetSize),
                width: _bubbleWidth(targetSize),
                // height: targetSize.height,
                child: SpeechBubble(
                  key: bubbleEntryKey,
                  nipHeight: BUBBLE_NIP_HEIGHT,
                  nipLocation: widget.bubblePosition,
                  color: Colors.black,
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                )));
        tutorialOverlays.add(bubbleEntry);
        Overlay.of(context).insertAll(tutorialOverlays);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox renderBoxBubble =
              bubbleEntryKey.currentContext.findRenderObject();
          bubbleEntry.remove();
          tutorialOverlays.remove(bubbleEntry);
          bubbleEntry = OverlayEntry(
              builder: (ctx) => Positioned(
                  left: _bubbleLeft(positionTarget, targetSize),
                  top: _bubbleTop(
                      positionTarget, targetSize, renderBoxBubble.size),
                  width: _bubbleWidth(targetSize),
                  // height: targetSize.height,
                  child: SpeechBubble(
                    key: bubbleEntryKey,
                    nipHeight: BUBBLE_NIP_HEIGHT,
                    nipLocation: widget.bubblePosition,
                    color: Colors.black,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                  )));
          tutorialOverlays.add(bubbleEntry);
          Overlay.of(context).insert(bubbleEntry);
          Overlay.of(context).setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(key: builderKey, builder: (ctx) => widget.builder(ctx));
  }

  _bubbleLeft(Offset offset, Size size) {
    switch (widget.bubblePosition) {
      case NipLocation.TOP_RIGHT:
        return offset.dx - (widget.scale - 1) * size.width;
      case NipLocation.TOP_LEFT:
        return offset.dx;
      default:
        return offset.dx;
    }
  }

  _bubbleTop(Offset offset, Size oriain, Size bubble) {
    switch (widget.bubblePosition) {
      case NipLocation.TOP_RIGHT:
        return offset.dy + oriain.height + BUBBLE_NIP_HEIGHT;
      case NipLocation.TOP_LEFT:
        return offset.dy + oriain.height + BUBBLE_NIP_HEIGHT;
      default:
        return offset.dy - bubble.height - BUBBLE_NIP_HEIGHT;
    }
  }

  _bubbleWidth(Size size) {
    return size.width * widget.scale;
  }
}

enum Position {
  LEFT,
  BOTTOM_RIGHT,
}
