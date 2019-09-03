import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Flat Button which has not splash or highlight.
/// It has text colors as Instagram Blue.
class ICTextButton extends StatefulWidget {
  final void Function() onPressed;
  final String text;

  /// Width for text of size 16 in wrapped form is 68 for 'Post' and 74 for 'Postx'
  final double width;
  ICTextButton({@required this.onPressed, @required this.text, this.width});
  @override
  _ICTextButtonState createState() => _ICTextButtonState();
}

class _ICTextButtonState extends State<ICTextButton> {
  bool _pressed;
  void initState() {
    _pressed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: FlatButton(
        highlightColor: Colors.transparent,
        disabledTextColor: Color(0x773897f0),
        textColor: Color(
          _pressed ? 0xff3897f0 : 0x773897f0,
        ),
        child: Text(
          widget.text,
        ),
        onHighlightChanged: ((_) {
          setState(() {
            _pressed = !_pressed;
          });
        }),
        onPressed: widget.onPressed,
      ),
    );
  }
}

class ICFlatButton extends StatefulWidget {
  final void Function() onPressed;
  final String text;

  ICFlatButton({@required this.onPressed, @required this.text});

  @override
  _ICFlatButtonState createState() => _ICFlatButtonState();
}

class _ICFlatButtonState extends State<ICFlatButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color(0xff3897f0),
      disabledColor: Color(0x553897f0),
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 12),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: widget.onPressed,
    );
  }
}
