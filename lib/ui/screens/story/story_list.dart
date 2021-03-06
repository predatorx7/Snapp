import 'package:flutter/material.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/repository/story.dart';
import 'package:instagram/models/plain_models/story_model.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class StoryList extends StatefulWidget {
  final double size;
  const StoryList({Key key, this.size}) : super(key: key);
  @override
  _StoryListState createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> with TickerProviderStateMixin {
  StoryModel cFeed;
  InfoModel _observer;
  @override
  void didChangeDependencies() {
    cFeed = ScopedModel.of<StoryModel>(context);
    _observer = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: cFeed.collection.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        String storyOf = cFeed.collection.keys.toList()[index];
        Story metadata = cFeed.collection[storyOf][index];
        bool storySeen = metadata.views.contains(_observer.info.uid);
        /// TODO: implement
        return null;
      },
    );
  }
}
