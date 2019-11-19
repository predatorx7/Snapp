import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/ui/screens/visited/visited_post.dart';

class PostAdapters extends StatelessWidget {
  final String uid;
  final bool isInGrid;
  final FirebaseDatabase database;
  final double height;
  final int index;
  final Post metadata;
  const PostAdapters(
      {this.uid,
      this.isInGrid,
      this.database,
      this.height,
      this.index,
      this.metadata,});
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
    EdgeInsetsGeometry postPadding;
    postPadding = paddingForPost(index, isInGrid);
    print('Attached post: ${metadata.imageURL}');
    return Padding(
      padding: postPadding,
      child: Container(
        color: Colors.grey[300],
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                maintainState: true,
                builder: (context) => VisitedPost(
                  post: metadata,
                ),
              ),
            );
          },
          onLongPressStart: (gesture) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                double constr = MediaQuery.of(context).size.width / 1.2;
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: GestureDetector(
                    onLongPressEnd: (gesture) {
                      Navigator.pop(context);
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constr,
                        minHeight: constr,
                        maxWidth: constr,
                        minWidth: constr,
                      ),
                      child: Image.network(
                        metadata.imageURL,
                        height: constr,
                        width: constr,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: new Material(
            child: new GridTile(
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
          ),
        ),
      ),
    );
  }
}
