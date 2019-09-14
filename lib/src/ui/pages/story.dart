import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/src/core/services/story_adapter.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class StoryPick extends StatefulWidget {
  @override
  _StoryPickState createState() => _StoryPickState();
}

class _StoryPickState extends State<StoryPick> {
  File _image;
  bool hasResult = false;
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getImage(ImageSource.camera));
  }

  dispose() {
    if (_image != null) _image.delete();
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      hasResult = true;
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasResult && _image == null) {
      Navigator.pop(context);
      return null;
    } else {
      return ChangeNotifierProvider(
        builder: (_) => UserRepository.instance(),
        child: UploadStoryStage(
          image: _image,
        ),
      );
    }
  }
}

class UploadStoryStage extends StatefulWidget {
  final File image;

  const UploadStoryStage({Key key, this.image}) : super(key: key);
  @override
  _UploadStoryStageState createState() => _UploadStoryStageState();
}

class _UploadStoryStageState extends State<UploadStoryStage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Story',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          Center(
            child: TappableText(
              onTap: () async {
                await uploadStory(widget.image, userRepo.user);
                Navigator.pop(context);
              },
              text: 'Share',
              textSize: 16,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            child: widget.image != null
                ? Image.file(
                    widget.image,
                    fit: BoxFit.fitWidth,
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

Future uploadStory(File _image, FirebaseUser user) async {
  StorageReference storageReference =
      FirebaseStorage.instance.ref().child('profiles/${user.email}/stories');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('Story Uploaded');
  storageReference.getDownloadURL().then((fileURL) {
    StoryAdapter().createStory(fileURL, '', user);
  });
}
