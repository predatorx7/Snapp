import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/models/view_models/message_all.dart';
import 'package:instagram/models/view_models/new_message.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/messaging/new_message.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class MessagingPage extends StatefulWidget {
  final PageController pageController;

  const MessagingPage({Key key, this.pageController}) : super(key: key);
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  InfoRepo _user;
  @override
  void didChangeDependencies() {
    _user = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.pageController != null) {
          setState(() {
            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 700), curve: Curves.easeIn);
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Direct',
            style: actionTitleStyle(),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<NewMessageModel>(
                      builder: (context) => NewMessageModel(),
                      child: NewMessage(
                        users: _user.following,
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                OMIcons.addComment,
                color: notBlack,
              ),
            ),
          ],
        ),
        body: ScopedModelDescendant<MessageAll>(
            builder: (context, child, control) {
          return RefreshIndicator(
            onRefresh: () async {
              await control.pullDetails(_user.userUID);
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    decoration: outlineTextField(
                      hintText: 'Search',
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 10),
                      child: Text(
                        'Messages',
                        style: bodyStyle(),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: control.status != MStatus.fruitful,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Message Friends with Direct',
                          style: actionTitle3Style(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Send private messages or share your favorite posts directly with friends.',
                          style: body2Style(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TappableText(
                        text: 'Send a Message',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<NewMessageModel>(
                                builder: (context) => NewMessageModel(),
                                child: NewMessage(
                                  users: _user.following,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: control.status == MStatus.fruitful,
                    child: ListView.builder(
                      itemCount: control.detailsMap.length,
                      itemBuilder: (context, index) {
                        String chatIDKey =
                            control.detailsMap.keys.toList()[index];
                        String user1 = control.detailsMap[chatIDKey]['user1'];
                        String thatUser = user1 == _user.userUID
                            ? control.detailsMap[chatIDKey]['user2']
                            : user1;
                        debugPrint('Build: $thatUser');
                        return FutureBuilder<DataSnapshot>(
                          future:
                              ProfileService().getProfileSnapshot(thatUser),
                          builder: (context, x) {
                            switch (x.connectionState) {
                              case ConnectionState.done:
                                print('Value: ${x.data.value}');
                                if (x.data.value != null) {
                                  Profile thatUserProfile = Profile.fromMap(
                                      x.data.value[x.data.value.keys.first]);
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          DirectMessagePageRoute,
                                          arguments: [
                                            _user.userUID,
                                            thatUserProfile.uid
                                          ]);
                                    },
                                    leading: ICProfileAvatar(
                                      profileURL:
                                          thatUserProfile.profileImage,
                                    ),
                                    title: Text(thatUserProfile.username),
                                  );
                                } else {
                                  return Container();
                                }
                                break;
                              default:
                                return Container();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: Material(
          elevation: 5,
          color: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    onPressed: () {
                      print('Tapped camera');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
