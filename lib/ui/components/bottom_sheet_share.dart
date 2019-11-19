import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/messaging.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/models/view_models/search_page.dart';
import 'package:instagram/repository/message.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:instagram/ui/components/drawer_handle.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:scoped_model/scoped_model.dart';

Future<Widget> directShare(context, InfoModel observer, Post metadata) async {
  List<Profile> users = observer.following;
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return ScopedModel<SearchModel>(
        model: SearchModel(),
        child: BottomSheet(
          elevation: 8,
          backgroundColor: Colors.transparent,
          onClosing: () {
            print("Bottom sheet closed");
          },
          builder: (context) {
            return Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  drawerHandle,
                  // List
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        Profile key = users[index];
                        return ListTile(
                          leading: ICProfileAvatar(
                            profileURL: key.profileImage,
                          ),
                          title: Text(
                            key.username,
                            style: body3Style(),
                          ),
                          trailing: ICSendButton(
                            onPressed: () async {
                              MessagingService().sendMessage(
                                Message(
                                  content:
                                      '${metadata.postKey} ${metadata.publisher}',
                                  chatID: MessagingService.genChatID(
                                      thisUserUID: observer.userUID,
                                      thatUserUid: key.uid),
                                  sender: observer.userUID,
                                  sendee: key.uid,
                                  type: ContentType.post,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
//                  SizedBox(
//                    height: 60,
//                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
