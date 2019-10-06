import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/plain_models/post.dart';
import '../services/profile.dart';

class PostAdapters extends StatelessWidget {
  final String uid;
  final int creationTime;
  final bool isInGrid;
  final FirebaseDatabase database;
  final double height;

  const PostAdapters(
      {this.uid, this.creationTime, this.isInGrid, this.database, this.height});

  @override
  Widget build(BuildContext context) {
    String username;
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
            return new CircularProgressIndicator();
          default:
            if (snapshot.hasData) {
              username = snapshot.data.value;
            } else {
              print(snapshot.data.toString());
            }
        }
      },
    );
    return FutureBuilder(
      future: database
          .reference()
          .child('posts/$uid')
          .orderByChild("creationTime")
          .equalTo(this.creationTime)
          .once(),
      builder: (context, AsyncSnapshot snapshot) {
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
                return Container();
              } else {
                Post metadata = Post.fromMap(snapshot.data);
                print(
                    '[Posts Adapter] Metadata: ${metadata.toJson().toString()}');
                print('[Posts Adapter] Raw Data: ${snapshot.data.toString()}');
                return new Material(
                  child: new GridTile(
                    header: Text('${metadata.publisher}: $username'),
                    footer:
                        this.isInGrid ? Text(metadata.description ?? '') : null,
                    child: new Image.network(
                      metadata.imageURL,
                      height: height,
                      fit: BoxFit.fitWidth,
                    ), //just for testing, will fill with image later
                  ),
                );
              }
            }
        }
      },
    );
  }
}
