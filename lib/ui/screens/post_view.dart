import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/post.dart';

class PostView extends StatefulWidget {
  final String publisher;
  final int creationTime;
  final FirebaseDatabase database;
  final InfoModel observer;

  PostView(
    this.publisher,
    this.creationTime,
    this.database,
    this.observer,
  );
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.database
          .reference()
          .child('posts/${widget.publisher}')
          .orderByChild("creationTime")
          .equalTo(widget.creationTime)
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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                    child: Row(
                      children: <Widget>[
                        FutureBuilder(
                          future: widget.database
                              .reference()
                              .child('profiles')
                              .orderByChild("uid")
                              .equalTo(widget.publisher)
                              .once(),
                          builder: (context, AsyncSnapshot<DataSnapshot> snap) {
                            String profURL = snap.data.value["profileImage"];
                            return CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: profURL.isNotEmpty
                                  ? Image.network(
                                      profURL,
                                    ).image
                                  : CommonImages.profilePic2.image,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            metadata.publisherUsername,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: notBlack),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () {
                                            print('Edit');
                                            Navigator.pop(context);
                                          },
                                          title: Text(
                                            'Edit',
                                            style: actionTitle2Style(),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            var publisher = metadata.publisher,
                                                postKey = metadata.postKey,
                                                creationTime =
                                                    metadata.creationTime;
                                            var database =
                                                FirebaseDatabase().reference();
                                            database
                                                .child(
                                                    'posts/$publisher/$postKey')
                                                .remove();
                                            database
                                                .child(
                                                    'profiles/$publisher/posts')
                                                .once()
                                                .then((DataSnapshot snapshot) {
                                              Map postsList = snapshot.value;
                                              postsList.forEach((key, value) {
                                                if (value == creationTime) {
                                                  database
                                                      .child(
                                                          'profiles/$publisher/posts/$key')
                                                      .remove();
                                                }
                                              });
                                            });
                                            Navigator.pop(context);
                                          },
                                          title: Text(
                                            'Delete',
                                            style: actionTitle2Style(),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            print('Turn Off Commenting');
                                            Navigator.pop(context);
                                          },
                                          title: Text(
                                            'Turn Off Commenting',
                                            style: actionTitle2Style(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.more_vert, color: Colors.black)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridTile(
                      child: Container(
                        color: Colors.grey[200],
                        child: Image.network(
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
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              print('pressed like');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.info),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('pressed comment');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.info),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('pressed send');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.info),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 4.0),
                              child: Text(
                                metadata.publisherUsername,
                                style: bodyStyle(),
                              ),
                            ),
                            Text(metadata.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}
