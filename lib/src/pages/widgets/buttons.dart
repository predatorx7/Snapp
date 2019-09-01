import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/src/core/values.dart';

class ICFlatButton extends StatefulWidget {
  final void Function() onPressed;
  final String text;
  ICFlatButton({this.onPressed, @required this.text});
  @override
  _ICFlatButtonState createState() => _ICFlatButtonState();
}

class _ICFlatButtonState extends State<ICFlatButton> {
  bool pressed = true;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      highlightColor: Colors.transparent,
      child: Text(
        widget.text,
        style: TextStyle(
          color: Color(
            pressed ? 0xff3897f0 : 0x773897f0,
          ),
        ),
      ),
      constraints: BoxConstraints(
        minWidth: 60,
        minHeight: 36,
      ),
      onHighlightChanged: ((_) {
        setState(() {
          pressed = !pressed;
        });
      }),
      onPressed: widget.onPressed,
    );
  }
}
