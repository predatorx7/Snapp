import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/services/story.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//Future<void> main() async {
//  // Obtain a list of the available cameras on the device.
//  final cameras = await availableCameras();
//
//  // Get a specific camera from the list of available cameras.
//  final firstCamera = cameras.first;
//
//  TakePictureScreen(
//    // Pass the appropriate camera to the TakePictureScreen widget.
//    camera: firstCamera,
//  );
//}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: PhysicalModel(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(25.0),
            child: new Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(25.0),
                color: Colors.white,
                border: new Border.all(
                  width: 2.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InfoModel user = Provider.of<InfoModel>(context);
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: <Widget>[
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Padding(
              padding: EdgeInsets.only(
                right: 20,
                bottom: 15,
              ),
              child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  print('Post Story');
                  uploadFile(File(imagePath), user.info.uid, user.info.username)
                      .then((answer) {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        'Set story',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(Icons.chevron_right, color: Colors.black)
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future uploadFile(File _image, String uid, String username) async {
  int time = DateTime.now().millisecondsSinceEpoch;
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('stories/$uid/${DateTime.now().millisecondsSinceEpoch}');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');
  storageReference.getDownloadURL().then(
    (fileURL) {
      StoryService().createStory(fileURL, uid, time, username);
    },
  );
}
