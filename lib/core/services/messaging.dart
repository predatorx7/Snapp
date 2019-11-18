import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/models/plain_models/message_model.dart';

// TODO: test
class MessagingService {
  DatabaseReference rootRef =
      FirebaseDatabase.instance.reference().child('chat');

  Future<bool> sendMessage(
    Message message
  ) async {
    print("[Messaging Service] Sending message");
    try {
      String chatId = message.chatID;
      DatabaseReference messageRef =
          rootRef.child('messages/$chatId').push().reference();
      message.key = messageRef.key;
      await messageRef.set(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getChatID(String thisUserUID, String thatUserUid) async {
    String chatId =
        genChatID(thisUserUID: thisUserUID, thatUserUid: thatUserUid);
    DatabaseReference dr = rootRef.child('details/$chatId');
    DatabaseReference du = rootRef.child('user');
    await dr.once().then(
      (DataSnapshot snapshot) async {
        if (snapshot.value == null) {
          print(
              "[Messaging Service] No chat room exists, creating chatroom with chatId: $chatId");
          Map _data = {
            "user1": thisUserUID,
            "user2": thatUserUid,
            "creationTime": DateTime.now().millisecondsSinceEpoch,
          };
          await dr.set(
            _data,
          );
          await du.child("$thatUserUid").child(chatId).set(
                _data,
              );
          await du.child("$thisUserUID").child(chatId).set(
                _data,
              );
        }
      },
    );
    return chatId;
  }

  static String genChatID({String thisUserUID, String thatUserUid}) {
    String chatID;
    List x = [thisUserUID, thatUserUid]..sort();
    chatID = x.join();
    return chatID;
  }
}
