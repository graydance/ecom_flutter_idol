import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.disableButtonValues = const [],
    this.radioButtonValue,
    this.buttonWidth,
    this.buttonColor,
    this.selectedColor,
    this.buttonHeight = 35,
    this.horizontal = false,
    this.enableShape = false,
    this.elevation = 10,
    this.customShape,
    this.fontSize = 15,
    this.lineSpace = 5,
    this.buttonSpace,
    this.buttonBorderColor = const Color(0xFF2594B22B),
    this.unselectedButtonBorderColor = const Color(0xFF2594B22B),
    this.textColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.disableColor = const Color(0xFF979AA9),
    this.disableButtonColor = const Color(0xFFEDEEF0),
    this.initialSelection = 0,
  })  : assert(buttonLables.length == buttonValues.length),
        assert(buttonLables.length > initialSelection),
        assert(buttonColor != null),
        assert(selectedColor != null);

  final bool horizontal;
  final double fontSize;
  final List buttonValues;
  final List disableButtonValues;
  final double buttonSpace;
  final double buttonHeight;

  final double lineSpace;
  final List<String> buttonLables;

  final Function(dynamic, int) radioButtonValue;

  final Color selectedColor;
  final Color buttonBorderColor;
  final Color unselectedButtonBorderColor;
  final Color buttonColor;
  final Color textColor;
  final Color selectedTextColor;
  final Color disableColor;
  final Color disableButtonColor;
  final ShapeBorder customShape;
  final bool enableShape;
  final double elevation;
  final double buttonWidth;
  final int initialSelection;

  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int currentSelected = 0;
  String currentSelectedLabel;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      currentSelectedLabel = widget.buttonLables[widget.initialSelection];
    } else {
      currentSelectedLabel = widget.buttonLables[0];
    }
  }

  List<Widget> buildButtons() {
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      final isDisable =
          widget.disableButtonValues.contains(widget.buttonValues[index]);
      var item = InkWell(
        onTap: isDisable
            ? null
            : () {
                widget.radioButtonValue(widget.buttonValues[index], index);
                setState(() {
                  currentSelected = index;
                  currentSelectedLabel = widget.buttonLables[index];
                });
              },
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 14) *
          // (widget.fontSize / 14),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(
                color: isDisable
                    ? Colors.transparent
                    : currentSelectedLabel == widget.buttonLables[index]
                        ? widget.buttonBorderColor
                        : widget.unselectedButtonBorderColor,
                width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: isDisable
                ? widget.disableButtonColor
                : currentSelectedLabel == widget.buttonLables[index]
                    ? widget.selectedColor
                    : widget.buttonColor,
          ),
          constraints: BoxConstraints(minWidth: 25),
          child: Text(
            widget.buttonLables[index],
            style: isDisable
                ? TextStyle(
                    color: widget.disableColor,
                    fontSize: widget.fontSize,
                  )
                : TextStyle(
                    color: currentSelectedLabel == widget.buttonLables[index]
                        ? widget.selectedTextColor
                        : widget.textColor,
                    fontSize: widget.fontSize,
                  ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      buttons.add(item);
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.horizontal ? Axis.horizontal : Axis.vertical,
      spacing: widget.buttonSpace, // gap between adjacent chips
      runSpacing: widget.lineSpace,
      textDirection: TextDirection.ltr,
      children: buildButtons(),
    );
  }
}
