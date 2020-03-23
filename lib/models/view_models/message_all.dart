import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

enum MStatus {
  fruitful,
  none,
  busy,
  searchMode,
}

class MessageAll extends Model {
  MStatus _status = MStatus.none;
  Map detailsMap = {};
  MStatus get status => _status;
  List<Map> chatIDs = [];
  List<Map> allMessages = [];
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  setStatus(MStatus status) {
    _status = status;
    notifyListeners();
  }

  MessageAll(String thisUserUid) {
    print("Fetching Message Details");
    pullDetails(thisUserUid);
  }

  Future<void> pullDetails(String thisUserUID) async {
    DataSnapshot snapshot = await ref.child('chat/user/$thisUserUID').once();
    if (snapshot.value != null) {
      Map _map = {};

      _map.addAll(snapshot.value);
      if (_map.isNotEmpty) {
        this.detailsMap = _map;
        _status = MStatus.fruitful;
      } else {
        _status = MStatus.none;
      }
      notifyListeners();
      print('${detailsMap.toString()}');
      print("Message Details Done");
    }
  }

  /// TO-FIX: Causes every message to be pulled
  Future<List<Map>> pullChatDetails(String thisUserUid) async {
    DataSnapshot snapshot = await ref.child('chat/user/$thisUserUid').once();
    if (snapshot.value != null) {
      List<String> _chatIDs = [];
      for (var x in snapshot.value.keys) {
        _chatIDs.add(x);
      }
      if (_chatIDs.isNotEmpty) {
        List<Map> initChats = [];
        for (var _chatId in _chatIDs) {
          DataSnapshot chatSnap =
              await ref.child('chat/messages/$_chatId').once();
          allMessages.add(chatSnap.value);
          if (chatSnap.value != null) {
            initChats.add(
              snapshot.value[_chatId],
            );
          }
        }
        return initChats;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
