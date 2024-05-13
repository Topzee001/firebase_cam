import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SurveyUpload extends StatefulWidget {
  const SurveyUpload({super.key});

  @override
  State<SurveyUpload> createState() => _SurveyUploadState();
}

class _SurveyUploadState extends State<SurveyUpload> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<File> _photos = [];

  final ImagePicker _picker = ImagePicker();

  Future<List<File>> imagesFromGallery() async {
    List<File> selectedImages = [];

    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(

          // maxImages: 300,
          // enableCamera: false,
          );
    } on Exception catch (e) {
      print(e.toString());
    }

    for (Asset asset in resultList) {
      final byteData = await asset.getByteData();
      final tempFile =
          File('${(await getTemporaryDirectory()).path}/${asset.name}');
      final buffer = byteData.buffer;
      await tempFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      selectedImages.add(tempFile);
    }

    return selectedImages;
  }

  Future<List<File>> imagesFromCamera() async {
    List<File> snappedImages = [];

    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    await cameraController.initialize();

    XFile picture;
    for (int i = 0; i < 3; i++) {
      // Change '3' to the desired number of pictures
      if (!cameraController.value.isTakingPicture) {
        picture = await cameraController.takePicture();
        snappedImages.add(File(picture.path));
      }
    }

    await cameraController.dispose();

    return snappedImages;
  }

  Future<void> _uploadFiles() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final folderName = 'uploads_$timestamp';

    for (File photo in _photos) {
      await _uploadFile(photo, folderName);
    }
    setState(() {
      _photos.clear();
    });
  }

  Future<void> _uploadFile(File photo, String folderName) async {
    if (photo == null) return;
    final fileName = basename(photo.path);
    final destination = '$folderName/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(photo);
    } catch (e) {
      print('error occurred: $e');
    }
  }

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
                  onPressed: () async {
                    final images = await imagesFromGallery();
                    setState(() {
                      _photos.addAll(images);
                    });
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
                  onPressed: () async {
                    final images = await imagesFromCamera();
                    setState(() {
                      _photos.addAll(images);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Take Picture',
                      ),
                      Icon(Icons.camera_alt)
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
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 0.5)),
              height: 100,
              width: 375,
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
          ],
        ),
      ),
    );
  }
}
