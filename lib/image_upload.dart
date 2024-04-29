import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class SurveyUploads extends StatefulWidget {
  const SurveyUploads({super.key});

  @override
  State<SurveyUploads> createState() => _SurveyUploadsState();
}

class _SurveyUploadsState extends State<SurveyUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<File> _photos = [];

  final ImagePicker _picker = ImagePicker();

  Future imageFromGallery() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (PickedFile != null) {
        _photos.add(File(PickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future imageFromCamera() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (PickedFile != null) {
        _photos.add(File(PickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future<void> _uploadFiles() async {
    for (File photo in _photos) {
      await _uploadFile(photo);
    }
  }

  Future<void> _uploadFile(File photo) async {
    if (photo == null) return;
    final fileName = basename(photo.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(photo);
    } catch (e) {
      print('error occured');
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: [
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      imageFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Surveys'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the SurveyUploads object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  _showPicker(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Add attachment',
                    ),
                    Icon(Icons.upload)
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.file(
                      _photos[index],
                      width: 50,
                      height: 50,
                    ),
                  );
                },
              ),
            ),
            TextButton(
                onPressed: _uploadFiles,
                child: const Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'capture',
        child: const Icon(Icons.photo_camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
