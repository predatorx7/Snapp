import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/core/services/comments.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import '../../components/buttons.dart';

class CommentsPage extends StatefulWidget {
  final Post postData;
  CommentsPage({this.postData});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _addCommentController;
  bool _isButtonDisabled = true;
  InfoModel observer;
  @override
  void initState() {
    super.initState();
    _addCommentController = new TextEditingController();
  }

  @override
  void didChangeDependencies() {
    observer = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Comments'),
        actions: <Widget>[
          Container(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                print('Goto Inbox');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonImages.directOutline,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                ///Show if Caption Exist
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ICProfileAvatar(
                      profileOf: widget.postData.publisher,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          RichText(
                            // maxLines: 16,
                            textAlign: TextAlign.left,
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: widget.postData.publisherUsername,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                new TextSpan(
                                  text: widget.postData.description,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListView(
                shrinkWrap: true,
              )
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ICProfileAvatar(
                        profileURL: observer.info.profileImage,
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: _addCommentController,
                        onChanged: (value) {
                          value.isEmpty
                              ? setState(() => _isButtonDisabled = true)
                              : setState(() => _isButtonDisabled = false);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TappableText(
                        text: 'Post',
                        // width: 68,
                        textSize: 14,
                        transparency: '0x55',
                        fontWeight: FontWeight.normal,
                        onTap: _isButtonDisabled
                            ? null
                            : () {
                                print('Posting');
                                CommentService.createComment(
                                  widget.postData.postKey,
                                  _addCommentController.text,
                                  observer.info.uid,
                                );
                              },
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
