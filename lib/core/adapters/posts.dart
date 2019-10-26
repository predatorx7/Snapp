import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/ui/components/process_indicator.dart';

class PostAdapters extends StatelessWidget {
  final String uid;
  final int creationTime;
  final bool isInGrid;
  final FirebaseDatabase database;
  final double height;
  final int index;

  const PostAdapters(
      {this.uid,
      this.creationTime,
      this.isInGrid,
      this.database,
      this.height,
      this.index});
  EdgeInsetsGeometry paddingForPost(int index, bool isInGrid) {
    double right = 2, left = 2;

    if (isInGrid) {
      switch (index % 3) {
        case 0:
          left = 0;
          break;
        case 1:
          right = 0;
          left = 0;
          break;
        case 2:
          right = 0;
          break;
      }
      print(
          '[Post Adapter] [Padding for post] for index: $index = left: $left, right: $right');
      return EdgeInsets.fromLTRB(left, 0, right, 2);
    } else {
      return EdgeInsets.all(0);
    }
  }

  /// TO avoid reloading on changing of tabs, Future builder should be used in List of the Widget using
  /// this adapter instead of this (adapter itself) and use setstate to use a function in initState to update
  /// futures FutureBuilder depends on when necessary.
  @override
  Widget build(BuildContext context) {
    String username;
    EdgeInsetsGeometry postPadding;
    postPadding = paddingForPost(index, isInGrid);
    FutureBuilder(
      future: FirebaseDatabase()
          .reference()
          .child("profiles")
          .orderByChild("uid")
          .equalTo(uid)
          .once(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new ICProcessIndicator();
          default:
            if (snapshot.hasData) {
              username = snapshot.data.value;
            } else {
              print("[Post Adapter] Snapshot doesn't have data");
            }
        }
      },
    );
    return Padding(
      padding: postPadding,
      child: Container(
        color: Colors.grey[300],
        child: FutureBuilder(
          future: database
              .reference()
              .child('posts/$uid')
              .orderByChild("creationTime")
              .equalTo(this.creationTime)
              .once(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              if (!snapshot.hasData) {
                return Container();
              } else {
                Post metadata = Post.fromMap(snapshot.data);
                return new Material(
                  child: new GridTile(
                    header: this.isInGrid
                        ? null
                        : Text('${metadata.publisher}: $username'),
                    footer:
                        this.isInGrid ? null : Text(metadata.description ?? ''),
                    child: new Image.network(
                      metadata.imageURL,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              accentColor: Colors.grey[300],
                              primaryColor: Colors.grey,
                            ),
                            child: SizedBox(
                              height: 28,
                              width: 28,
                              child: new CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      },
                      height: height,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
