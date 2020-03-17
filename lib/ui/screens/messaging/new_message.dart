import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/view_models/new_message.dart';
import 'package:instagram/models/view_models/search_page.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class NewMessage extends StatefulWidget {
  final List<Profile> users;
  const NewMessage({Key key, this.users}) : super(key: key);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  InfoModel observer;
  TextEditingController _filter;
  NewMessageModel control;

  @override
  void initState() {
    _filter = new TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    control = Provider.of<NewMessageModel>(context);
    observer = Provider.of<InfoModel>(context);
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
        title: Text('New Message', style: head3Style()),
      ),
      body: ScopedModel<SearchModel>(
        model: SearchModel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                'To',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 10, 10),
              child: ScopedModelDescendant<SearchModel>(
                builder: (context, _, _search) {
                  return TextField(
                    controller: _filter,
                    cursorWidth: 1,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) async {
                      if (value?.isEmpty ?? true) {
                        control.setStatus(Status.idle);
                      } else if (_filter?.text?.isNotEmpty ?? false) {
                        control.setStatus(Status.busy);
                        await _search.search(_filter.text);
                        control.setStatus(Status.searchMode);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle:
                          TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
              child: Text(
                control.status != Status.searchMode
                    ? 'Suggested'
                    : 'Search results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: control.status == Status.idle,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  Profile key = widget.users[index];
                  return ListTile(
                    onTap: () async {
                      Navigator.of(context).pushNamed(DirectMessagePageRoute,
                          arguments: [observer.userUID, key.uid]);
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
            ),
            Visibility(
              visible: control.status == Status.busy,
              child: Center(
                child: ConstrainedBox(
                  child: icProcessIndicator(context),
                  constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                ),
              ),
            ),
            Visibility(
              visible: control.status == Status.searchMode,
              child: ScopedModelDescendant<SearchModel>(
                builder: (context, _, _search) {
                  print(
                      'Search Visible, result: ${_search.results.keys.toList().length}');
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _search.results.keys.toList().length,
                      itemBuilder: (context, index) {
                        if (_search.results.isEmpty) {
                          return Center(
                            child: Text(
                              'No results',
                              style: TextStyle(
                                color: Color(actionColor),
                              ),
                            ),
                          );
                        }
                        String pKey = _search.results.keys.toList()[index];
                        Profile key = _search.results[pKey];
                        return ListTile(
                          onTap: () {
                            if (observer.userUID == key.uid) {
                              // Open chats
                            } else {
                              Navigator.of(context).pushNamed(
                                DirectMessagePageRoute,
                                arguments: [
                                  observer.userUID,
                                  key.uid,
                                ],
                              );
                            }
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
