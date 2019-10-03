import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
  cursorColor: Colors.teal,
  textSelectionColor: Color(0x550077ff),
  textSelectionHandleColor: Colors.teal,
  primaryTextTheme: TextTheme(title: TextStyle(color: Color(0xff262626))),
  appBarTheme: AppBarTheme(
    elevation: 2,
    brightness: Brightness.light,
    color: Colors.grey[100],
    iconTheme: IconThemeData(color: Colors.black),
  ),
  splashColor: Colors.transparent,
);

int actionColor = 0xff3897f0;

Color notBlack = Color(0xff262626);

TextStyle headStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      color: notBlack,
      fontSize: 14,
    );
TextStyle head2Style() => TextStyle(
      fontWeight: FontWeight.bold,
      color: notBlack,
      fontSize: 16,
    );

TextStyle actionTitleStyle() => TextStyle(
      fontWeight: FontWeight.normal,
      color: notBlack,
      fontSize: 16,
    );
TextStyle actionTapStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(actionColor),
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
