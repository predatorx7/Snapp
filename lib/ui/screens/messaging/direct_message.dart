import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/messaging.dart';
import 'package:instagram/models/plain_models/message_model.dart';
import 'package:instagram/models/view_models/direct_message.dart';
import 'package:instagram/repository/ex_information.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';

class DirectMessageScreen extends StatefulWidget {
  const DirectMessageScreen({
    Key key,
  }) : super(key: key);

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  InfoRepo thisUser;
  ExInfoRepo thatUser;
  DirectMessageModel _view;
  TextEditingController _replyController;
  MessagingService msgSrv;
  @override
  void initState() {
    _replyController = TextEditingController();
    msgSrv = MessagingService();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    thisUser = Provider.of<InfoRepo>(context);
    thatUser = Provider.of<ExInfoRepo>(context);
    _view = Provider.of<DirectMessageModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Visibility(
          visible: thatUser.profile.uid != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ICProfileAvatar(
                profileURL: thatUser.profile.profileImage,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  thatUser.profile?.username ?? '',
                  style: head3Style(),
                ),
              )
            ],
          ),
        ),
      ),
      body: Visibility(
        visible: _view.status != Status.loading,
        replacement: Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: icProcessIndicator(context),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Messages View
            // TODO test
            FirebaseAnimatedList(
              reverse: true,
              shrinkWrap: true,
              query: FirebaseDatabase.instance
                  .reference()
                  .child('chat/messages/${_view.chatId}'),
              itemBuilder: (context, DataSnapshot dataSnapshot, anim, index) {
                Message thisMessage = Message.fromMap(dataSnapshot.value);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('${thisMessage.content.toString()}'),
                    Text(thisMessage.sender == thisUser.userUID ? thisUser.profile.username : thatUser.profile.username),
                  ],
                );
              },
            ),
            // Reply Box
            Material(
              color: Colors.grey[50],
              child: Column(
                verticalDirection: VerticalDirection.up,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: TextField(
                        controller: _replyController,
                        onChanged: (value) {
//                            value.isEmpty
//                                ? view.setButtonStatus(true)
//                                : view.setButtonStatus(false);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Send a message..',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Builder(
                          builder: (context) {
                            return TappableText(
                              text: 'Send',
                              // width: 68,
                              textSize: 14,
                              transparency: '0x55',
                              fontWeight: FontWeight.normal,
                              onTap: _view.isSending
                                  ? null
                                  : () async {
                                      _view.setStatus(Status.sending);
                                      await msgSrv
                                          .sendMessage(
                                        Message(
                                          chatID: _view.chatId,
                                          content: _replyController.text,
                                          sender: thisUser.userUID,
                                          sendee: thatUser.userUID,
                                          type: ContentType.message,
                                        ),
                                      )
                                          .then(
                                        (result) {
                                          if (!result) {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Couldn't send your message"),
                                              ),
                                            );
                                          }
                                          _view.setStatus(Status.idle);
                                        },
                                      );
                                      _replyController =
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
          ],
        ),
      ),
    );
  }
}
