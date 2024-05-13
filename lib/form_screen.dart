import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController _nameController = TextEditingController();
  List<String> _imageUrls = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(
        maxWidth: 200, maxHeight: 200, imageQuality: 80);
    if (pickedImages != null) {
      for (var image in pickedImages) {
        // Upload images to Firebase Storage and get download URLs
        String imageUrl = await _uploadImageToFirebase(image.path);
        setState(() {
          _imageUrls.add(imageUrl);
        });
      }
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(File(imagePath));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    // Implement form submission to Firebase Firestore or Realtime Database
    // Include form data along with image URLs in the submission
    // Example:
    // FirebaseFirestore.instance.collection('forms').add({
    //   'name': _nameController.text,
    //   'imageUrls': _imageUrls,
    //   // Other form fields
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Select Images'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(_imageUrls[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormScreen(),
  ));
}
