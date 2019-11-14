// import 'package:instagram/src/models/plain_models/story.dart';

// void test() async {
//   var story = Story(imageURL: '/samplestory.jpg', publisher: 'smushaheed');
//   print('uploading Story: ${story.toJson()}');
//   print('done');
//   print('story creation as timestamp');
//   print(story.creationTime);
//   print('story expiration as timestamp');
//   print(story.expiryTime);
//   var time = DateTime.fromMillisecondsSinceEpoch(story.creationTime);
//   var expiry = DateTime.fromMillisecondsSinceEpoch(story.expiryTime);
//   print('story creation as Iso8601');
//   print(time.toIso8601String());
//   print('story expiration Iso8601');
//   print(expiry.toIso8601String());
//   print('story creation UTC');
//   print(time.toUtc());
//   print('story expiration UTC');
//   print(expiry.toUtc());
//   print('story creation Local');
//   print(time.toLocal());
//   print('story expiration Local');
//   print(expiry.toLocal());
//   await Future.delayed(Duration(seconds: 20), () {
//     var currentTime = DateTime.now().toLocal();
//     print('Current time: $currentTime');
//   });
// }

