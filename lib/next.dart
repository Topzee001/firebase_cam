import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
//import 'dart:async';
import 'dart:io';
//import 'package:path/path.dart';

class UploadSurvey extends StatefulWidget {
  const UploadSurvey({super.key});

  @override
  State<UploadSurvey> createState() => _UploadSurveyState();
}

class _UploadSurveyState extends State<UploadSurvey> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<File> _photos = [];

  final ImagePicker _picker = ImagePicker();
//pick image from gallery method
  Future imageFromGallery() async {}
  //pick image from camera method
  Future imageFromCamera() async {}
  //show image picker method
  void _showPicker(BuildContext context) {}
  //upload tofirebase method
  Future<void> _uploadFiles() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Surveys'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 0.5)),
              height: 100,
              width: 375,
              child: Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
