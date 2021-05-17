import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';

/// 通用按钮样式
class IdolButton extends StatefulWidget {
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

  /// 是否使用局部刷新？ 如果使用局部刷新则通过rebuild方式无法进行status更改。
  final bool isPartialRefresh;

  final bool isOutlineStyle;

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
    this.isPartialRefresh = false,
    this.isOutlineStyle = false,
    this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IdolButtonState();
}

class IdolButtonState extends State<IdolButton> {
  String _text;
  IdolButtonStatus _status;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('IdolButton didChangeDependencies...');
    _text = widget.text;
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('IdolButton >>> ${widget.isOutlineStyle}');
    BoxDecoration decoration;
    Color textColor = Colours.white;
    if (widget.isOutlineStyle) {
      decoration = BoxDecoration(
        border: Border.all(
          color: Colours.color_EA5228,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      );
      textColor = Colours.color_EA5228;
    } else {
      bool condition = (widget.isPartialRefresh
          ? (_status == IdolButtonStatus.enable)
          : (widget.status == IdolButtonStatus.enable));

      decoration = condition
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: widget.linearGradientBegin,
                end: widget.linearGradientEnd,
                colors: widget.enableColors,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)))
          : BoxDecoration(
              color: (widget.isPartialRefresh
                      ? _status == IdolButtonStatus.normal
                      : widget.status == IdolButtonStatus.normal)
                  ? widget.normalColor
                  : widget.disableColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            );
    }

    return (widget.isPartialRefresh
            ? (_status == IdolButtonStatus.enable)
            : (widget.status == IdolButtonStatus.enable))
        ? Container(
            width: widget.width,
            height: widget.height,
            decoration: decoration,
            child: RaisedButton(
              onPressed: () => widget
                  .listener(widget.isPartialRefresh ? _status : widget.status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: AutoSizeText(
                widget.isPartialRefresh ? _text : widget.text,
                style: TextStyle(color: textColor, fontSize: 16),
                maxLines: 1,
              ),
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            decoration: decoration,
            child: RaisedButton(
              onPressed: () => widget
                  .listener(widget.isPartialRefresh ? _status : widget.status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colours.transparent,
              highlightElevation: 0,
              elevation: 0,
              child: AutoSizeText(
                widget.isPartialRefresh ? _text : widget.text,
                style: TextStyle(color: textColor, fontSize: 16),
                maxLines: 1,
              ),
            ),
          );
  }

  void updateText(String buttonText) {
    assert(() {
      if (!widget.isPartialRefresh) {
        throw FlutterError(
            'You must set the IdolButton->isPartialRefresh property, then use updateText/updateButtonStatus method.');
      }
      return true;
    }());
    debugPrint('updateIButtonText >>> $buttonText');
    setState(() {
      _text = buttonText;
    });
  }

  void updateButtonStatus(IdolButtonStatus status) {
    assert(() {
      if (!widget.isPartialRefresh) {
        throw FlutterError(
            'You must set the IdolButton->isPartialRefresh property, then use updateText/updateButtonStatus method.');
      }
      return true;
    }());
    debugPrint('updateIButtonStatus >>> $status');
    setState(() {
      _status = status;
    });
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
          style:
              TextStyle(color: Colours.color_48B6EF, fontSize: widget.fontSize),
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
          style:
              TextStyle(color: Colours.color_48B6EF, fontSize: widget.fontSize),
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

/// EditPage/Save Button
class EditButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditButtonState();

  EditButton({key}) : super(key: key);
}

class EditButtonState extends State<EditButton> {
  String _buttonText = 'Edit Page';
  EditButtonStatus _status = EditButtonStatus.normal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _status == EditButtonStatus.loading
                        ? Colours.black
                        : Colours.white),
              ),
            ),
            Text(
              _buttonText,
              style: TextStyle(color: Colours.color_29292B, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void updateButtonStatus(EditButtonStatus status) {
    setState(() {
      _status = status;
      _buttonText = _status == EditButtonStatus.normal ? 'Edit Page' : 'Done';
    });
  }
}

enum EditButtonStatus {
  normal,
  loading,
}
