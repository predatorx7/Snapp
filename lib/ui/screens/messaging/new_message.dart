import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/view_models/search_page.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

// Todo: test
class NewMessage extends StatefulWidget {
  final List<Profile> users;
  const NewMessage({Key key, this.users}) : super(key: key);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  InfoRepo observer;
  TextEditingController _filter;

  @override
  void initState() {
    _filter = new TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    observer = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('New Message', style: actionTitleStyle()),
      ),
      body: SingleChildScrollView(
        child: ScopedModel<SearchModel>(
          model: SearchModel(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('To'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScopedModelDescendant<SearchModel>(
                  builder: (context, _, view) {
                    return TextField(
                      controller: _filter,
                      cursorWidth: 1,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () async => view.search(_filter.text),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 26,
                        ),
                        hintText: "Search",
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Suggested'),
              ),
              Visibility(
                visible: _filter?.text?.isEmpty ?? true,
                child: ListView.builder(
                  itemCount: widget.users.length,
                  itemBuilder: (context, index) {
                    Profile key = widget.users[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SomeoneProfileRoute, arguments: key);
                      },
                      leading: ICProfileAvatar(
                        profileURL: key.profileImage,
                      ),
                      title: Text(
                        key.username,
                        style: body3Style(),
                      ),
                    );
                  },
                ),
                replacement: ScopedModelDescendant<SearchModel>(
                  builder: (context, _, view) {
                    return ListView.builder(
                      itemCount: view.results.length,
                      itemBuilder: (context, index) {
                        if (view.results.isEmpty) return Container();
                        String pKey = view.results.keys.toList()[index];
                        Profile key = view.results[pKey];
                        return observer.userUID != key.uid
                            ? ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      SomeoneProfileRoute,
                                      arguments: key);
                                },
                                leading: ICProfileAvatar(
                                  profileURL: key.profileImage,
                                ),
                                title: Text(
                                  key.username,
                                  style: body3Style(),
                                ),
                              )
                            : SizedBox();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
