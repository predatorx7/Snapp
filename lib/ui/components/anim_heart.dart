import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AnimatedHeart extends StatefulWidget {
  final Widget child;
  final double size;
  final int milliseconds;
  const AnimatedHeart({Key key, this.child, this.size = 200, this.milliseconds})
      : super(key: key);
  @override
  _AnimateState createState() => _AnimateState();
}

class _AnimateState extends State<AnimatedHeart> {
  double size;
  AnimatedHeartModel model;
  @override
  void initState() {
    size = widget.size;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AnimatedHeartModel>(
      model: AnimatedHeartModel(),
      child: ScopedModelDescendant<AnimatedHeartModel>(
          builder: (context, _, model) {
        return AnimatedContainer(
          color: Colors.amber,
          duration: new Duration(milliseconds: widget.milliseconds),
          height: size,
          width: size,
          child: widget.child,
        );
      }),
    );
  }
}

class AnimatedHeartModel extends Model {
  double _size;

  double get size => _size;

  setSize(double size) {
    _size = size;
    notifyListeners();
  }

  changeSize({num milliseconds, double size}) async {
    await Future.delayed(
        Duration(
          milliseconds: int.parse('$milliseconds'),
        ), () {
      _size = size;
      notifyListeners();
    });
  }
}
