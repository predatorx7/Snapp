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
    this.key,
  }) : this.creationTime = DateTime.now().millisecondsSinceEpoch;

  Message.fromMap(Map messageMap) {
    this.chatID = messageMap['chatID'];
    this.content = messageMap['content'];
    this.creationTime = messageMap['creationTime'];
    this.key = messageMap['key'];
    this.sendee = messageMap['sendee'];
    this.sender = messageMap['sender'];
    String _type = messageMap['type'];
    if (_type == ContentType.message.toString()) {
      this.type = ContentType.message;
    } else if (_type == ContentType.post.toString()) {
      this.type = ContentType.post;
    } else if (_type == ContentType.profile.toString()) {
      this.type = ContentType.profile;
    } else if (_type == ContentType.story.toString()) {
      this.type = ContentType.story;
    } else if (_type == ContentType.image.toString()) {
      this.type = ContentType.image;
    }
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
