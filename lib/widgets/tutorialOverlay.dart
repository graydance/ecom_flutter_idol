import 'dart:math';

import 'package:flutter/material.dart';
import 'package:idol/widgets/SpeechBubble.dart';

class TutorialOverlay extends StatefulWidget {
  final GlobalKey<TutorialOverlayState> key;
  final builder; // 子控件构造函数
  final String bubbleText; // 气泡框文本内容
  final Position handPosition; // 手势位置
  final NipLocation bubbleNipPosition; //气泡指针位置
  final double bubbleWidth; //气泡框宽度，如果小于等于0 则使用子控件宽度
  final bool clipCircle; //在目标区域显示一个原型抠图
  final Color clipBg; //圆形抠图的背景色
  final int clipPadding; //圆形抠图时指定padding
  final clipCircleOnTap; //如果指定了 clipCircle，可以附加额外的点击事件
  TutorialOverlay(
      {this.builder,
      this.key,
      this.bubbleText = "",
      this.handPosition = Position.BOTTOM_RIGHT,
      this.bubbleNipPosition = NipLocation.BOTTOM,
      this.clipCircle = false,
      this.clipPadding = 0,
      this.clipBg = Colors.transparent,
      this.clipCircleOnTap,
      this.bubbleWidth = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TutorialOverlayState();
}

// var tutorialOverlays = <OverlayEntry>[];
const double BUBBLE_NIP_HEIGHT = 10;
const HAND_POSITION_OFFSET = const Offset(20, 20);

class TutorialOverlayState extends State<TutorialOverlay> {
  var builderKey = GlobalKey();
  var bubbleEntryKey = GlobalKey();
  OverlayEntry bubbleEntry;
  AnimationController controller;
  Size targetSize;
  Offset positionTarget;
  var tutorialOverlays = <OverlayEntry>[];

  hide() {
    tutorialOverlays.forEach((overlay) {
      try {
        overlay.remove();
      } catch (e) {}
    });
  }

  show() {
    Overlay.of(widget.key.currentContext).insertAll(tutorialOverlays);
    WidgetsBinding.instance.addPostFrameCallback(adjustBubble);
  }

  adjustBubble(_) {
    final RenderBox renderBoxBubble =
        bubbleEntryKey.currentContext.findRenderObject();
    bubbleEntry.remove();
    tutorialOverlays.remove(bubbleEntry);
    bubbleEntry = OverlayEntry(
        builder: (ctx) => Positioned(
            left: _bubbleLeft(positionTarget, targetSize),
            top: _bubbleTop(positionTarget, targetSize, renderBoxBubble.size),
            width: _bubbleWidth(targetSize),
            // height: targetSize.height,
            child: SpeechBubble(
              key: bubbleEntryKey,
              nipHeight: BUBBLE_NIP_HEIGHT,
              nipLocation: widget.bubbleNipPosition,
              color: Colors.black,
              child: Text(
                widget.bubbleText,
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
  }

  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tutorialOverlays.length == 0) {
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
        targetSize = renderBoxTarget.size;
        positionTarget = renderBoxTarget.localToGlobal(Offset.zero);
        OverlayEntry targetEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: positionTarget.dx - widget.clipPadding,
                top: positionTarget.dy - widget.clipPadding,
                width: targetSize.width + 2 * widget.clipPadding,
                height: targetSize.height + 2 * widget.clipPadding,
                child: widget.clipCircle
                    ? Center(
                        child: ClipOval(
                          child: Container(
                            width: min(targetSize.width, targetSize.height) +
                                2 * widget.clipPadding,
                            height: min(targetSize.width, targetSize.height) +
                                2 * widget.clipPadding,
                            color: widget.clipBg,
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      widget.clipCircleOnTap != null &&
                                          widget.clipCircleOnTap();
                                    },
                                    child: SizedBox(
                                      width: targetSize.width,
                                      height: targetSize.height,
                                      child: widget.builder(ctx),
                                    ))),
                          ),
                        ),
                      )
                    : widget.builder(ctx)));
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
                left: widget.handPosition == Position.BOTTOM_RIGHT
                    ? (positionTarget.dx +
                        targetSize.width / 2 -
                        HAND_POSITION_OFFSET.dx)
                    : (positionTarget.dx - targetSize.width),
                top: widget.handPosition == Position.BOTTOM_RIGHT
                    ? (positionTarget.dy +
                        targetSize.height -
                        HAND_POSITION_OFFSET.dy)
                    : positionTarget.dy,
                height: widget.handPosition == Position.BOTTOM_RIGHT
                    ? null
                    : targetSize.height,
                width: widget.handPosition == Position.BOTTOM_RIGHT
                    ? targetSize.width
                    : null,
                child: AnimatedBuilder(
                    animation: curve,
                    builder: (context, child) => Transform.translate(
                          offset: Position.BOTTOM_RIGHT == widget.handPosition
                              ? Offset(0, curve.value * 15)
                              : Offset(-curve.value * 15, 0),
                          child: child,
                        ),
                    child: Image.asset(
                      widget.handPosition == Position.BOTTOM_RIGHT
                          ? 'assets/image/hand_rb.png'
                          : 'assets/image/hand_lb.png',
                      width: 40,
                      height: 51,
                    ))));
        tutorialOverlays.add(handEntry);

        bubbleEntry = OverlayEntry(
            builder: (ctx) => Positioned(
                left: _bubbleLeft(positionTarget, targetSize),
                top: _bubbleTop(positionTarget, targetSize, targetSize),
                width: _bubbleWidth(targetSize),
                // height: targetSize.height,
                child: SpeechBubble(
                  key: bubbleEntryKey,
                  nipHeight: BUBBLE_NIP_HEIGHT,
                  nipLocation: widget.bubbleNipPosition,
                  color: Colors.black,
                  child: Text(
                    widget.bubbleText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                )));
        tutorialOverlays.add(bubbleEntry);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(key: builderKey, builder: (ctx) => widget.builder(ctx));
  }

  _bubbleLeft(Offset offset, Size size) {
    switch (widget.bubbleNipPosition) {
      case NipLocation.TOP_RIGHT:
        return offset.dx - widget.bubbleWidth + size.width;
      case NipLocation.TOP_LEFT:
        return offset.dx;
      default:
        return widget.bubbleWidth > 0
            ? offset.dx - widget.clipPadding * 2 - size.width + defaultNipHeight
            : offset.dx;
    }
  }

  _bubbleTop(Offset offset, Size oriain, Size bubble) {
    switch (widget.bubbleNipPosition) {
      case NipLocation.TOP_RIGHT:
        return offset.dy + oriain.height + BUBBLE_NIP_HEIGHT;
      case NipLocation.TOP_LEFT:
        return offset.dy + oriain.height + BUBBLE_NIP_HEIGHT;
      default:
        return offset.dy -
            bubble.height -
            BUBBLE_NIP_HEIGHT -
            widget.clipPadding;
    }
  }

  _bubbleWidth(Size size) {
    return widget.bubbleWidth > 0 ? widget.bubbleWidth : size.width;
  }
}

enum Position {
  LEFT,
  BOTTOM_RIGHT,
}
