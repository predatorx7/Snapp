import 'package:flutter/material.dart';

import 'assets.dart';

Widget icProcessIndicator(context) => Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.grey[300],
        primaryColor: Colors.grey,
      ),
      child: SizedBox(
        height: 28,
        width: 28,
        child: new CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );
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

List<Shadow> icShadows = <Shadow>[
  Shadow(
    offset: Offset(0.0, 0.0),
    blurRadius: 8.0,
    color: Color.fromARGB(150, 0, 0, 0),
  ),
];

const Widget gradientBG = SizedBox(
  height: 60,
  width: 60,
  child: Image(
    image: CommonImages.circleGradientAsset,
    fit: BoxFit.fill,
  ),
);

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
TextStyle actionTitle2Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: notBlack,
      fontSize: 14,
    );
TextStyle actionTitle3Style() => TextStyle(
      fontWeight: FontWeight.w600,
      color: notBlack,
      fontSize: 18,
    );
TextStyle actionTitle4Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: notBlack,
      fontSize: 18,
    );
TextStyle actionTitle5Style() => TextStyle(
      fontWeight: FontWeight.bold,
      color: notBlack,
      fontSize: 14,
    );
InputDecoration editPageInputBorder(String label) => InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
    );
TextStyle actionTapStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(actionColor),
      fontSize: 14,
    );
TextStyle actionTap2Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: Color(actionColor),
      fontSize: 18,
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
TextStyle body4Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontSize: 12,
    );
TextStyle body3Style() => TextStyle(
      fontWeight: FontWeight.normal,
      color: notBlack,
      fontSize: 14,
    );
TextStyle body5Style() => TextStyle(
      fontWeight: FontWeight.w600,
      color: notBlack,
      fontSize: 16,
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
