import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salarynow/preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String selfieUploadUrl = "https://salarynow.in/testapi/imageapi.php";
  final String pdfUploadUrl = "https://salarynow.in/testapi/pdfapi.php";

  File? _imageFile;
  File? _pdfFile;

  Future<void> _takeSelfieAndUpload() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      _imageFile = File(image.path);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imageFile: _imageFile),
      ),
    );
  }

  Future<void> _choosePdfFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _pdfFile = File(result.files.single.path!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(pdfFile: _pdfFile),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _takeSelfieAndUpload,
              child: const Text('Take Selfie and Upload'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _choosePdfFileAndUpload,
              child: const Text('Choose PDF and Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
