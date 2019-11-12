import 'package:flutter/material.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/story.dart';
import 'package:instagram/models/plain_models/story_model.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class StoryList extends StatefulWidget {
  final double size;
  const StoryList({Key key, this.size}) : super(key: key);
  @override
  _StoryListState createState() => _StoryListState();
}

class _StoryListState extends State<StoryList>
    with TickerProviderStateMixin {
  StoryModel cFeed;
  InfoRepo _observer;
  @override
  void didChangeDependencies() {
    cFeed = ScopedModel.of<StoryModel>(context);
    _observer = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: cFeed.stories.length,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        Story metadata = cFeed.stories[index];
        bool storySeen = metadata.views.contains(_observer.info.uid);
        // Todo implement
        return null;
      },
    );
  }
}