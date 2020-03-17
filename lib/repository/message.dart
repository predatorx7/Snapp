import 'package:flutter/foundation.dart';

// Todo: test
enum ContentType {
  message,
  post,
  profile,
  story,
  image,
  // Not yet supported
  giphy,
}

/// Holds a single message data
class Message {
  /// Message's Unique key
  String key;

  /// Chat ID
  String chatID;

  /// sender user uid
  String sender;

  /// receiver user uid
  String sendee;

  /// Creation time in milliseconds from epoch (UNIX)
  int creationTime;

  /// Content
  String content;

  /// Content of Message
  ContentType type;

  Message({
    @required this.chatID,
    @required this.content,
    @required this.type,
    @required this.sendee,
    @required this.sender,
    this.creationTime,
    this.key,
  }) {
    if (this.creationTime == null)
      this.creationTime = DateTime.now().millisecondsSinceEpoch;
  }

  factory Message.fromMap(Map messageMap) {
    ContentType _typex;
    String _type = messageMap['type'];
    if (_type == ContentType.message.toString()) {
      _typex = ContentType.message;
    } else if (_type == ContentType.post.toString()) {
      _typex = ContentType.post;
    } else if (_type == ContentType.profile.toString()) {
      _typex = ContentType.profile;
    } else if (_type == ContentType.story.toString()) {
      _typex = ContentType.story;
    } else if (_type == ContentType.image.toString()) {
      _typex = ContentType.image;
    }
    return Message(
      chatID: messageMap['chatID'],
      content: messageMap['content'],
      creationTime: messageMap['creationTime'],
      key: messageMap['key'],
      sendee: messageMap['sendee'],
      sender: messageMap['sender'],
      type: _typex,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'chatId': this.chatID,
      'content': this.content,
      'creationTime': this.creationTime,
      'key': this.key ?? '',
      'sendee': this.sendee,
      'sender': this.sender,
      'type': this.type.toString()
    };
  }
}
