import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';

/// 通用按钮样式
class IdolButton extends StatelessWidget {
  /// Button text.
  final String text;

  /// Button status [IdolButtonStatus]
  final IdolButtonStatus status;

  /// Button width.
  final double width;

  /// Button height.
  final double height;

  /// Button active gradient colors.
  final List<Color> enableColors;

  /// Button IdolButtonStatus.disable color.
  final Color disableColor;

  /// Button IdolButtonStatus.normal color.
  final Color normalColor;

  /// Button [LinearGradient.begin]
  final Alignment linearGradientBegin;

  /// Button [LinearGradient.end]
  final Alignment linearGradientEnd;

  /// Button click callback.
  final IdolButtonClickListener listener;

  const IdolButton(
    this.text, {
    Key key,
    this.status = IdolButtonStatus.enable,
    this.width = double.infinity,
    this.height = 45,
    this.enableColors = const <Color>[
      Colours.color_F68A51,
      Colours.color_EA5228
    ],
    this.disableColor = Colours.color_FFD8B1,
    this.normalColor = Colours.color_C3C4C4,
    this.linearGradientBegin = Alignment.centerLeft,
    this.linearGradientEnd = Alignment.centerRight,
    this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return status == IdolButtonStatus.enable
        ? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: linearGradientBegin,
                end: linearGradientEnd,
                colors: enableColors,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: RaisedButton(
              onPressed: () => listener(status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: Text(
                text,
                style: TextStyle(color: Colours.white, fontSize: 16),
              ),
            ),
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: status == IdolButtonStatus.normal
                  ? normalColor
                  : disableColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: RaisedButton(
              onPressed: () => listener(status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: Text(
                text,
                style: TextStyle(color: Colours.white, fontSize: 16),
              ),
            ),
          );
  }
}

enum IdolButtonStatus {
  /// 默认状态，为灰色不可点击
  normal,

  /// 用户已进行交互，但条件未完全满足
  disable,

  /// 满足条件，可进行点击
  enable,
}

/// IdolButton点击监听
typedef IdolButtonClickListener = void Function(IdolButtonStatus status);

/// Following button.
class FollowButton extends StatefulWidget {
  final String supplierId;
  final FollowStatus defaultFollowStatus;
  final double width;
  final double height;
  final double fontSize;
  final FollowButtonStyle buttonStyle;

  FollowButton(this.supplierId,
      {this.defaultFollowStatus,
      this.width = 88.0,
      this.height = 36.0,
      this.buttonStyle = FollowButtonStyle.elevated,
      this.fontSize = 14.0});

  @override
  State<StatefulWidget> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  FollowStatus followStatus = FollowStatus.unFollow;

  @override
  void initState() {
    super.initState();
    followStatus = widget.defaultFollowStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonStyle == FollowButtonStyle.elevated) {
      return ElevatedButton(
        onPressed: () {
          _changeFollowStatus();
        },
        child: _getElevatedButtonStyleChildWidget(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              (followStatus == FollowStatus.followed ||
                      followStatus == FollowStatus.following)
                  ? Colours.color_C3C4C4
                  : Colours.color_EA5228),
          minimumSize:
              MaterialStateProperty.all(Size(widget.width, widget.height)),
          // minimumSize: MaterialStateProperty.all(value),
          // padding: MaterialStateProperty.all(),
        ),
      );
    } else {
      return TextButton(
        onPressed: () {
          if (followStatus == FollowStatus.unFollow) {
            _changeFollowStatus();
          }
        },
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            TextStyle(color: Colours.color_48B6EF, fontSize: 14),
          ),
        ),
        child: _getTextButtonStyleChildWidget(),
      );
    }
  }

  Widget _getTextButtonStyleChildWidget() {
    Widget childWidget;
    switch (followStatus) {
      case FollowStatus.unFollow: // 未关注
        childWidget = Text(
          'Follow',
          style: TextStyle(color: Colours.color_48B6EF, fontSize: widget.fontSize),
        );
        break;
      case FollowStatus.following: // Loading
        childWidget = SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colours.color_48B6EF),
          ),
        );
        break;
      case FollowStatus.followed: // 已关注
        childWidget = Text(
          '',
          style: TextStyle(color: Colours.white, fontSize: widget.fontSize),
        );
        break;
      default:
        childWidget = Text(
          'Follow',
          style: TextStyle(color: Colours.color_48B6EF, fontSize: widget.fontSize),
        );
        break;
    }
    return childWidget;
  }

  Widget _getElevatedButtonStyleChildWidget() {
    Widget childWidget;
    switch (followStatus) {
      case FollowStatus.unFollow: // 未关注
        childWidget = Text(
          'Follow',
          style: TextStyle(color: Colours.white, fontSize: widget.fontSize),
        );
        break;
      case FollowStatus.following: // Loading
        childWidget = SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colours.white),
          ),
        );
        break;
      case FollowStatus.followed: // 已关注
        childWidget = Text(
          'Following',
          style: TextStyle(color: Colours.white, fontSize: widget.fontSize),
        );
        break;
      default:
        childWidget = Text(
          'Follow',
          style: TextStyle(color: Colours.white, fontSize: widget.fontSize),
        );
        break;
    }
    return childWidget;
  }

  void _changeFollowStatus() {
    setState(() {
      followStatus = FollowStatus.following;
    });
    DioClient.getInstance()
        .post(ApiPath.follow, baseRequest: FollowRequest(widget.supplierId))
        .then((data) {
      if (data['isFollow'] != null) {
        followStatus = (data['isFollow'] == 0)
            ? FollowStatus.unFollow
            : FollowStatus.followed;
      }
    }).whenComplete(() {
      setState(() {
        // update state.
      });
    }).catchError((err) {
      EasyLoading.showToast(err.toString());
    });
  }
}

enum FollowStatus {
  followed,
  following,
  unFollow,
}

enum FollowButtonStyle {
  text,
  elevated,
}
