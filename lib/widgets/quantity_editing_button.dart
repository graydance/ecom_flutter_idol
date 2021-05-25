import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/theme.dart';

enum QuantityEditingButtonStyle { large, small }

class QuantityEditingButton extends StatefulWidget {
  final QuantityEditingButtonStyle style;
  final int quantity;
  final int min;
  final int max;
  final Function(int) onChanged;

  QuantityEditingButton({
    Key key,
    this.style = QuantityEditingButtonStyle.large,
    this.quantity = 1,
    this.min = 1,
    this.max = 9999,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _QuantityEditingButtonState createState() => _QuantityEditingButtonState();
}

class _QuantityEditingButtonState extends State<QuantityEditingButton> {
  int _quantity;

  TextStyle get _tipTextStyle {
    switch (widget.style) {
      case QuantityEditingButtonStyle.large:
        return TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.color0F1015,
        );
      case QuantityEditingButtonStyle.small:
        return TextStyle(
          fontSize: 12,
          color: AppTheme.color555764,
        );
      default:
        throw Error();
    }
  }

  double get _buttonSize {
    switch (widget.style) {
      case QuantityEditingButtonStyle.large:
        return 30;
      case QuantityEditingButtonStyle.small:
        return 24;
      default:
        throw Error();
    }
  }

  double get _iconSize {
    switch (widget.style) {
      case QuantityEditingButtonStyle.large:
        return 15;
      case QuantityEditingButtonStyle.small:
        return 15;
      default:
        throw Error();
    }
  }

  @override
  void initState() {
    _quantity = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Quantity',
          style: _tipTextStyle,
        ),
        SizedBox(
          height: _buttonSize,
          width: _buttonSize,
          child: QuantityButton(
            image: R.image.icon_remove(),
            disableImage: R.image.icon_remove_disable(),
            iconSize: _iconSize,
            isEnable: _quantity > widget.min,
            onPressed: () {
              setState(() {
                _quantity -= 1;
              });
              if (widget.onChanged != null) widget.onChanged(_quantity);
            },
          ),
        ),
        Container(
          constraints: new BoxConstraints(
            minWidth: 20.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '$_quantity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.color0F1015,
            ),
          ),
        ),
        SizedBox(
          height: _buttonSize,
          width: _buttonSize,
          child: QuantityButton(
            image: R.image.icon_add(),
            disableImage: R.image.icon_add_disable(),
            iconSize: _iconSize,
            isEnable: _quantity < widget.max,
            onPressed: () {
              setState(() {
                _quantity += 1;
              });
              if (widget.onChanged != null) widget.onChanged(_quantity);
            },
          ),
        ),
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    Key key,
    @required bool isEnable,
    @required double iconSize,
    @required ImageProvider image,
    @required ImageProvider disableImage,
    @required VoidCallback onPressed,
  })  : _isEnable = isEnable,
        _iconSize = iconSize,
        _image = image,
        _disableImage = disableImage,
        _onPressed = onPressed,
        super(key: key);

  final bool _isEnable;
  final double _iconSize;
  final ImageProvider _image;
  final ImageProvider _disableImage;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isEnable ? _onPressed : null,
      child: Image(
        width: _iconSize,
        height: _iconSize,
        image: _isEnable ? _image : _disableImage,
      ),
    );
  }
}
