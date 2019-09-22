import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


/// Handles boiler plate snapshot builder. Should make life easier.
class HandleViewSnapshot extends StatefulWidget {
  final Future<DataSnapshot> future;
  final Widget Function(BuildContext, AsyncSnapshot<DataSnapshot>) builder;

  const HandleViewSnapshot({Key key, @required this.future, @required this.builder})
      : super(key: key);

  @override
  _HandleViewSnapshotState createState() => _HandleViewSnapshotState();
}

class _HandleViewSnapshotState extends State<HandleViewSnapshot> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
          case ConnectionState.active:
            return new Text('Result: ${snapshot.data}');
          case ConnectionState.none:
            return new Text('Result: ${snapshot.data}');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              if (!snapshot.hasData) {
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {});
                });
                return Container();
              } else {
                return widget.builder(context, snapshot);
              }
            }
        }
      },
    );
  }
}
