import 'package:flutter/material.dart';
import 'package:instagram/core/services/posts.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/visited/visited_post.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../repository/message.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class MessageTile extends StatefulWidget {
  final Message message;
  final Profile thatUser;
  final Profile thisUser;
  const MessageTile({
    Key key,
    @required this.message,
    @required this.thatUser,
    @required this.thisUser,
  }) : super(key: key);
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool _isMessageByThisUser = true;
  double _constraint;
  @override
  void initState() {
    super.initState();
  }

  BoxDecoration _highlightedDecor = BoxDecoration(
    color: Colors.grey[400],
    border: Border.all(
      color: Colors.grey[400],
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    // Will remain true if message sent from this user, or else will turn false;
    _isMessageByThisUser = (widget.message.sender == widget.thisUser.uid);

    _constraint = MediaQuery.of(context).size.width / 1.6;
    return Container(
      padding: const EdgeInsets.only(right: 15.0, left: 15, top: 4, bottom: 4),
      child: ScopedModel<_MessageTileModel>(
        model: _MessageTileModel(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ScopedModelDescendant<_MessageTileModel>(
              builder: (context, child, controller) {
                return AnimatedCrossFade(
                  duration: Duration(milliseconds: 200),
                  crossFadeState: controller.isTappedToShowTime
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstCurve: Curves.easeOut,
                  secondCurve: Curves.ease,
                  firstChild: SizedBox(),
                  secondChild: Center(
                    child: Text(
                      timeAgo.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.message.creationTime,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: (!_isMessageByThisUser)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Visibility(
                    visible: widget.message.sender == widget.thatUser.uid,
                    child: ICProfileAvatar(
                      profileURL: widget.thatUser.profileImage,
                    ),
                    replacement: SizedBox(
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
                ScopedModelDescendant<_MessageTileModel>(
                  builder: (context, child, controller) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        controller.setHighlighted(value);
                      },
                      onTap: () {
                        controller.toggleTappedToShowTime();
                      },
                      child: Container(
                        child: FutureBuilder<Widget>(
                            future: controller.contentProvider(
                                context, widget.message, _constraint),
                            builder: (context, AsyncSnapshot<Widget> snapshot) {
                              if (snapshot.data == null) return Container();
                              return snapshot.data;
                            }),
                        decoration: controller.isHighlighted
                            ? _highlightedDecor
                            : BoxDecoration(
                                border: (!_isMessageByThisUser)
                                    ? Border.all(
                                        color: Colors.grey[300],
                                      )
                                    : null,
                                color: (!_isMessageByThisUser)
                                    ? Colors.grey[50]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTileModel extends Model {
  bool _isTappedToShowTime = false;

  bool get isTappedToShowTime => _isTappedToShowTime;

  bool _isHighlighted = false;

  bool get isHighlighted => _isHighlighted;

  toggleTappedToShowTime() {
    this._isTappedToShowTime = !this._isTappedToShowTime;
    notifyListeners();
  }

  setHighlighted(bool isHighlighted) {
    _isHighlighted = isHighlighted;
    notifyListeners();
  }

  Future<Widget> contentProvider(
      BuildContext context, Message message, double constraint) async {
    String target = message.content;
    print('[Message Tile] Post: content: $target');
    Widget child;
    switch (message.type) {
      case ContentType.message:
        child = Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(target),
        );
        break;
      case ContentType.post:
        List<String> postDat = target.split(' ');
        String postKey = postDat[0];
        String publisher = postDat[1];
        Post metadata = await PostService.getPost(postKey, publisher);
        child = Padding(
          padding: const EdgeInsets.all(1.0),
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
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: new BorderRadius.circular(20),
                  child: Image.network(
                    metadata.imageURL,
                    height: constraint * 1.2,
                    width: constraint,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: constraint,
                        width: constraint,
                        child: Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              accentColor: Colors.grey[300],
                              primaryColor: Colors.grey,
                            ),
                            child: SizedBox(
                              height: 40,
                              width: 40,
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
                        ),
                      );
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
                ClipRRect(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    color: Colors.grey[50],
                    width: constraint,
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ICProfileAvatar(
                            profileOf: metadata.publisher,
                            size: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(metadata.publisherUsername),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Visibility(
                    visible: metadata?.description?.isNotEmpty ?? false,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Container(
                        color: Colors.grey[50],
                        width: constraint,
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              child: Text(metadata.description),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case ContentType.profile:
        // TODO: Handle this case.
        break;
      case ContentType.story:
        // TODO: Handle this case.
        break;
      case ContentType.image:
        child = ClipRRect(
          borderRadius: new BorderRadius.circular(20),
          child: Image.network(
            target,
            height: constraint,
            width: constraint,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: constraint,
                width: constraint,
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      accentColor: Colors.grey[300],
                      primaryColor: Colors.grey,
                    ),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: new CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
            fit: BoxFit.fitWidth,
          ),
        );
        break;
      default:
        child = Icon(
          Icons.error_outline,
          color: Colors.red,
        );
    }
    return child;
  }
}
