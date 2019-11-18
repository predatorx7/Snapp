import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/messaging.dart';
import 'package:instagram/models/view_models/new_message.dart';
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
  NewMessageModel _view;
  @override
  void initState() {
    _filter = new TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _view = Provider.of<NewMessageModel>(context);
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
        title: Text('New Message', style: head3Style()),
      ),
      body: SingleChildScrollView(
        child: ScopedModel<SearchModel>(
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
                      onChanged: (_text) async {
                        if (_text?.isEmpty ?? null) {
                          print('Search box empty');
                          _view.status = Status.idle;
                        } else {
                          _view.status = Status.busy;
                          await _search.search(_text ?? '').then(
                            (_) {
                              _view.status = _search.results.isNotEmpty
                                  ? Status.hasResults
                                  : Status.none;
                            },
                          );
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
                  _view.status != Status.hasResults
                      ? 'Suggested'
                      : 'Search results',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Visibility(
                visible: _view.status == Status.idle,
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

                /// TODO: TO FIX: No result Bug
                replacement: Visibility(
                  visible: _view.status == Status.busy,
                  child: Center(
                    child: icProcessIndicator(context),
                  ),
                  replacement: _view.status == Status.none
                      ? Center(
                          child: Text(
                            'No results',
                            style: TextStyle(
                              color: Color(actionColor),
                            ),
                          ),
                        )
                      : ScopedModelDescendant<SearchModel>(
                          builder: (context, _, view) {
                          return ListView.builder(
                            itemCount: view.results.length,
                            itemBuilder: (context, index) {
                              if (view.results.isEmpty) return Container();
                              String pKey = view.results.keys.toList()[index];
                              Profile key = view.results[pKey];
                              return ListTile(
                                onTap: () {
                                  if (observer.userUID == key.uid) {
                                    // Open chats
                                  } else {
                                    // Open Chats
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
                          );
                        }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
