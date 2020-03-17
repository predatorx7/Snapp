import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/messaging.dart';
import 'package:instagram/repository/message.dart';
import 'package:instagram/models/view_models/direct_message.dart';
import 'package:instagram/models/plain_models/visited_info.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:instagram/ui/components/mesage_tile.dart';
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
  InfoModel thisUser;
  VisitedInfoModel thatUser;
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
    thisUser = Provider.of<InfoModel>(context);
    thatUser = Provider.of<VisitedInfoModel>(context);
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
            Flexible(
              child: FirebaseAnimatedList(
                sort: (DataSnapshot snap1, DataSnapshot snap2) {
                  // To arrange how messages will be displayed to user chat
                  return snap2.key.compareTo(snap1.key);
                },
                shrinkWrap: true,
                reverse: true,
                query: FirebaseDatabase.instance
                    .reference()
                    .child('chat/messages/${_view.chatId}'),
                itemBuilder: (context, DataSnapshot dataSnapshot, anim, index) {
                  Message thisMessage = Message.fromMap(dataSnapshot.value);
                  return MessageTile(
                    message: thisMessage,
                    thatUser: thatUser.profile,
                    thisUser: thisUser.profile,
                  );
                },
              ),
            ),
            Visibility(
              visible: _view.status == Status.sending,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sending..',
                      style: TextStyle(
                        color: Colors.grey[350],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: icProcessIndicator(context),
                    ),
                  ],
                ),
              ),
            ),
            // Reply Box
            Material(
              color: Colors.grey[50],
              child: Column(
                verticalDirection: VerticalDirection.up,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            iconSize: 22,
                            padding: const EdgeInsets.all(4),
                            onPressed: () async {
                              var image = await ImagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 60);
                              if (image != null) {
                                _view.setStatus(Status.sending);
                                String imageUrl = await uploadFile(
                                    image, _view.chatId, thisUser.userUID);
                                if (imageUrl?.isNotEmpty ?? false) {
                                  msgSrv.sendMessage(
                                    Message(
                                      chatID: _view.chatId,
                                      content: imageUrl,
                                      sender: thisUser.userUID,
                                      sendee: thatUser.userUID,
                                      type: ContentType.image,
                                    ),
                                  );
                                }
                                _view.setStatus(Status.idle);
                              }
                            },
                            color: Color(actionColor),
                            icon: PhysicalModel(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(actionColor),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: new Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 22.0,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: _replyController,
                              onChanged: (value) {},
                              decoration: InputDecoration.collapsed(
                                hintText: 'Message...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                                Scaffold.of(context)
                                                    .showSnackBar(
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
                          )
                        ],
                      ),
                    ),
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

Future<String> uploadFile(File _image, String chatID, String senderUID) async {
  int time = DateTime.now().millisecondsSinceEpoch;
  StorageReference storageReference =
      FirebaseStorage.instance.ref().child('messages/$chatID/$senderUID/$time');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');
  return await storageReference.getDownloadURL();
}
