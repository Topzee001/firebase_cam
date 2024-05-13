import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_cap/response.dart';

class MultiImagePickerForm extends StatefulWidget {
  const MultiImagePickerForm({super.key});

  @override
  MultiImagePickerFormState createState() => MultiImagePickerFormState();
}

class MultiImagePickerFormState extends State<MultiImagePickerForm> {
  String name = '';
  String phoneNumber = '';
  String address = '';
  List<XFile> pickedImages = [];

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        pickedImages.addAll(pickedFiles);
      });
    }
  }

  Future<void> submitForm() async {
    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (var image in pickedImages) {
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask = ref.putFile(File(image.path));
        final TaskSnapshot downloadUrl = await uploadTask;
        final String url = await downloadUrl.ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Save form data to Firestore
      await FirebaseFirestore.instance.collection('form_submissions').add({
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'image_urls': imageUrls,
        'timestamp': Timestamp.now(),
      });

      // Reset form fields and picked images after successful submission
      setState(() {
        name = '';
        phoneNumber = '';
        address = '';
        //pickedImages = [];
        pickedImages.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Handle errors
      print('Error submitting form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting form. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    // setState(() {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Image Picker Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) => setState(() => name = value),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) => setState(() => phoneNumber = value),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) => setState(() => address = value),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: pickImages,
              child: const Text('Pick Images'),
            ),
            const SizedBox(height: 20.0),
            pickedImages.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: pickedImages
                        .map((image) => Image.file(File(image.path),
                            width: 100, height: 100))
                        .toList(),
                  ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FirestoreDataViewer(),
            ));
      }),
    );
  }
}
