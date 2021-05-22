import 'package:flutter/material.dart';
import 'package:idol/res/theme.dart';

class CustomizeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey<FormState> formKey;
  const CustomizeTextField({
    Key key,
    @required this.controller,
    this.focusNode,
    this.formKey,
  }) : super(key: key);

  @override
  _CustomizeTextFieldState createState() => _CustomizeTextFieldState();
}

class _CustomizeTextFieldState extends State<CustomizeTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.colorEDEEF0,
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: AppTheme.colorC4C5CD,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: EdgeInsets.all(8),
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: 'Example: Michelle',
          suffixText: widget.controller.text.length.toString() + "/10",
          suffixStyle: TextStyle(
            color: widget.controller.text.length > 10
                ? AppTheme.colorED3544
                : AppTheme.color0F1015,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
        validator: (value) {
          if (value.trim().isEmpty)
            return 'Please enter your customize information';
          if (value.length > 10) return 'No more than 10 characters';
          return null;
        },
      ),
    );
  }
}
