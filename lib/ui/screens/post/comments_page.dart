import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/comments.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/models/plain_models/comments.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/models/view_models/comment_page.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../components/buttons.dart';

class CommentsPage extends StatefulWidget {
  final Post postData;
  CommentsPage({this.postData});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _addCommentController;
  InfoModel observer;
  List<Comment> commentList = [];
  @override
  void initState() {
    super.initState();
    _addCommentController = new TextEditingController();
    print('first\n\n\n\n\n');
    CommentService.fetchComment(widget.postData.postKey).then((value) {
      if (value != null) {
        setState(() {
          commentList = value;
        });
      }
    });
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
    return ScopedModel<CommentPageModel>(
      model: CommentPageModel(),
      child: ScopedModel<SubCommentModel>(
        model: SubCommentModel(),
        child:
            ScopedModelDescendant<SubCommentModel>(builder: (context, _, view) {
          return Scaffold(
            appBar: (view.selectedComment?.commentKey == null ||
                    view.selectedComment.commentKey == 'lol')
                ? AppBar(
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
                  )
                : AppBar(
                    backgroundColor: Color(actionColor),
                    leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: notBlack,
                      ),
                      onPressed: () {
                        view.setSelectedComment(Comment(commentKey: null));
                      },
                    ),
                    actions: <Widget>[
                      Visibility(
                        visible: view.selectedComment?.publisher ==
                            observer.info.uid,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await CommentService.deleteComment(
                                view.selectedComment);
                            var list = await CommentService.fetchComment(
                                widget.postData.postKey);
                            if (list != null) {
                              setState(
                                () {
                                  commentList = list;
                                },
                              );
                            }
                          },
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
                                        text:
                                            '${widget.postData.publisherUsername} ',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                    RefreshIndicator(
                      onRefresh: () async {
                        var list = await CommentService.fetchComment(
                            widget.postData.postKey);
                        if (list != null) {
                          setState(() {
                            commentList = list;
                          });
                        }
                      },
                      child: ListView.builder(
                        itemCount: commentList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = commentList[index];
                          return Container(
                            color: ScopedModel.of<SubCommentModel>(context)
                                        .selectedComment
                                        ?.commentKey ==
                                    comment.commentKey
                                ? Colors.grey[200]
                                : Colors.transparent,
                            child: ListTile(
                              selected: ScopedModel.of<SubCommentModel>(context)
                                      .selectedComment
                                      ?.commentKey ==
                                  comment.commentKey,
                              onLongPress: () {
                                ScopedModel.of<SubCommentModel>(context)
                                    .setSelectedComment(comment);
                              },
                              contentPadding: EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                                right: 0,
                                left: 10,
                              ),
                              leading: ICProfileAvatar(
                                profileOf: comment.publisher,
                              ),
                              title: RichText(
                                // maxLines: 16,
                                textAlign: TextAlign.left,
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: '${comment.pulisherUsername} ',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new TextSpan(
                                      text: comment.comment,
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  print('Liked');
                                },
                                icon: Icon(
                                  OMIcons.favoriteBorder,
                                  size: 15,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Material(
                    color: Colors.grey[50],
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
                              child: ScopedModelDescendant<CommentPageModel>(
                                  builder: (context, child, view) {
                                return TextField(
                                  controller: _addCommentController,
                                  onChanged: (value) {
                                    value.isEmpty
                                        ? view.setButtonStatus(true)
                                        : view.setButtonStatus(false);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ScopedModelDescendant<CommentPageModel>(
                                builder: (context, child, view) {
                                  return TappableText(
                                    text: 'Post',
                                    // width: 68,
                                    textSize: 14,
                                    transparency: '0x55',
                                    fontWeight: FontWeight.normal,
                                    onTap: view.isButtonDisabled
                                        ? null
                                        : () {
                                            CommentService.createComment(
                                              widget.postData.postKey,
                                              _addCommentController.text,
                                              observer.info.uid,
                                              observer.info.username,
                                            );
                                            AppNotification(
                                              notifyTo: widget.postData.publisher,
                                              notificationFrom: observer.info.uid,
                                              event: OnEvent.commentedOnYour,
                                              postKey: widget.postData.postKey ?? '',
                                            );
                                            _addCommentController =
                                                new TextEditingController();
                                            setState(() {});
                                          },
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
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
