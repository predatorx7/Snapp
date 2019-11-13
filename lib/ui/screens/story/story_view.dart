import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/models/plain_models/story.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryView extends StatefulWidget {
  final List<Story> stories;
  final String publisherUID;
  const StoryView({Key key, this.stories, this.publisherUID}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PageView.builder(
            itemCount: widget.stories.length,
            itemBuilder: (context, pubsIndex) {
              Story singleStory = widget.stories[pubsIndex];
              return Stack(
                children: <Widget>[
                  Hero(
                    tag: 'aStory',
                    child: GestureDetector(
                      child: Image.network(
                        singleStory.imageURL,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: ICProfileAvatar(
                      profileOf: widget.stories[0].publisher,
                      size: 20,
                    ),

                    title: Text(
                      widget.stories[0].publisherUsername,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    subtitle: Text(
                      timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.stories[pubsIndex].creationTime),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[200]),
                    ),
                    trailing: Text('${DateTime.fromMillisecondsSinceEpoch(widget.stories[pubsIndex].creationTime)}\n${DateTime.now()}', style: TextStyle(color: Colors.white),),
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}