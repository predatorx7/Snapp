import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/models/view_models/search_page.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchPage extends StatefulWidget {
  final String observer;

  const SearchPage({Key key, @required this.observer}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // controls the text label we use as a search bar
  TextEditingController _filter;
  FirebaseDatabase fd;

  @override
  void initState() {
    _filter = new TextEditingController();
    fd = FirebaseDatabase.instance;
    super.initState();
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SearchModel>(
      model: SearchModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title:
              ScopedModelDescendant<SearchModel>(builder: (context, _, view) {
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
          }),
        ),
        body: ScopedModelDescendant<SearchModel>(builder: (context, _, view) {
          return ListView.builder(
            itemCount: view.results.length,
            itemBuilder: (context, index) {
              if (view.results.isEmpty) return Container();
              String pKey = view.results.keys.toList()[index];
              Profile key = view.results[pKey];
              return ListTile(
                onTap: () {
                  if (widget.observer == key.uid) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  } else {
                    Navigator.of(context)
                        .pushNamed(SomeoneProfileRoute, arguments: key);
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
    );
  }
}
