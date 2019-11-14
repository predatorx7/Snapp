import 'package:flutter/material.dart';

class ICProcessIndicator extends StatelessWidget {
  final double size;

  const ICProcessIndicator({Key key, this.size = 28}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.grey[300],
          primaryColor: Colors.grey,
        ),
        child: SizedBox(
          height: size,
          width: size,
          child: new CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class ICLinearProcessIndicator extends StatelessWidget {
  const ICLinearProcessIndicator({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.grey[300],
          primaryColor: Colors.grey,
        ),
        child: LinearProgressIndicator(),
      ),
    );
  }
}
