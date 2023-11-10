import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
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

    // Encode image to base64
    String base64Image = base64Encode(_imageFile!.readAsBytesSync());

    // Make HTTP POST request using Dio
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        selfieUploadUrl,
        data: {'photo': base64Image},
      );

      if (response.statusCode == 200) {
        print(response.data);
        // Handle success
      } else {
        // Handle error
        print("Error uploading selfie: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading selfie: $e");
    }

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

      // Make HTTP POST request using Dio
      try {
        Dio dio = Dio();
        Response response = await dio.post(
          pdfUploadUrl,
          data: {'file': base64Encode(_pdfFile!.readAsBytesSync())},
        );

        if (response.statusCode == 200) {
          log(response.data);
          // Handle success
        } else {
          // Handle error
          log("Error uploading PDF: ${response.statusCode}");
        }
      } catch (e) {
        log("Error uploading PDF: $e");
      }
    } else {
      // User canceled the file picking
      log("User canceled the file picking");
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(pdfFile: _pdfFile),
      ),
    );
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
