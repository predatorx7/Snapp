import 'package:flutter/material.dart';

int actionColor = 0xff3897f0;

Color notBlack = Color(0xff262626);

TextStyle headStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      color: notBlack,
      fontSize: 14,
    );

TextStyle bodyStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      color: notBlack,
      fontSize: 14,
    );

TextStyle body2Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontSize: 14,
    );

InputBorder fieldInputBorder({Color borderColor}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        width: 1,
        color: borderColor ?? Colors.grey[350],
      ),
    );

InputDecoration outlineTextField({
  String hintText,
  String errorText,
  Widget suffixIcon,
}) =>
    InputDecoration(
      filled: true,
      hintText: hintText,
      errorText: errorText,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 12,
      ),
      fillColor: Colors.grey[100],
      border: fieldInputBorder(),
      enabledBorder: fieldInputBorder(),
      focusedBorder: fieldInputBorder(),
      errorBorder: fieldInputBorder(borderColor: Colors.red),
      contentPadding: EdgeInsets.all(12),
    );
