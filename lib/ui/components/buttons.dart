import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/commons/styles.dart';

class ICFlatButton extends StatefulWidget {
  final void Function() onPressed;
  final String text;
  final bool conditionForProcessIndicator;

  ICFlatButton(
      {@required this.onPressed,
      @required this.text,
      this.conditionForProcessIndicator = false});

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
      child: widget.conditionForProcessIndicator
          ? Theme(
              data: Theme.of(context).copyWith(
                accentColor: Colors.white,
                primaryColor: Colors.blue,
              ),
              child: SizedBox(
                height: 27,
                width: 27,
                child: new CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            )
          : Text(
              widget.text,
              style: TextStyle(fontSize: 14),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: widget.onPressed,
    );
  }
}

class ICSendButton extends StatefulWidget {
  final void Function() onPressed;

  ICSendButton({
    @required this.onPressed,
  });

  @override
  _ICSendButtonState createState() => _ICSendButtonState();
}

class _ICSendButtonState extends State<ICSendButton> {
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: sent ? Colors.white : Color(0xff3897f0),
      disabledColor: Color(0x553897f0),
      disabledTextColor: Colors.white,
      textColor: sent ? Colors.green : Colors.white,
      child: sent
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Sent',
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.done,
                  color: Colors.green,
                )
              ],
            )
          : Text(
              'Send',
              style: TextStyle(fontSize: 14),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: () {
        if (!sent) {
          widget.onPressed();
          setState(() {
            sent = true;
          });
        }
      },
    );
  }
}

/// A Tappable Text with Changeable padding
/// When using as a action button, do these configs: textSize: 14, fontWeight: FontWeight.normal.
class TappableText extends StatefulWidget {
  final String text;
  final void Function() onTap;

  /// Default padding is EdgeInsets.all(8.0).
  final EdgeInsetsGeometry padding;
  final double textSize;
  final FontWeight fontWeight;
  final String transparency;
  TappableText(
      {@required this.text,
      @required this.onTap,
      this.padding,
      this.textSize,
      this.fontWeight,
      this.transparency = '0x99'});
  @override
  _TappableTextState createState() => _TappableTextState();
}

class _TappableTextState extends State<TappableText> {
  bool _pressed;
  void initState() {
    _pressed = true;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHighlightChanged: ((_) {
        setState(() {
          _pressed = !_pressed;
        });
      }),
      onTap: widget.onTap,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(8.0),
        child: Text(
          widget.text,
          style: TextStyle(
            color: (widget.onTap == null || !_pressed)
                ? Color(
                    int.parse('${widget.transparency}3897f0'),
                  )
                : Color(0xff3897f0),
            fontSize: widget.textSize ?? 12,
            fontWeight: widget.fontWeight ?? FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
