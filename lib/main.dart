import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:survey_cap/firebase_options.dart';
import 'package:survey_cap/form_screen.dart';
import 'package:survey_cap/image_upload.dart';
import 'package:survey_cap/new1w.dart';
import 'package:survey_cap/new2.dart';
import 'package:survey_cap/next.dart';

import 'rand.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiImagePickerForm(),
    );
  }
}
