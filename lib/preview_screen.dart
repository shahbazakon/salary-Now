// preview_screen.dart

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final File? imageFile;
  final File? pdfFile;

  PreviewScreen({Key? key, this.imageFile, this.pdfFile}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool uploading = false;

    Future<void> _uploadImage() async {
      if (widget.imageFile == null) return;

      setState(() {
        uploading = true;
      });

      // Encode image to base64
      String base64Image = base64Encode(widget.imageFile!.readAsBytesSync());

      // Make HTTP POST request using Dio
      try {
        Dio dio = Dio();
        Response response = await dio.post(
          "https://salarynow.in/testapi/imageapi.php",
          data: {'photo': base64Image},
        );

        if (response.statusCode == 200) {
          print(response.data);
          // Handle success
        } else {
          // Handle error
          print("Error uploading image: ${response.statusCode}");
        }
      } catch (e) {
        print("Error uploading image: $e");
      }

      setState(() {
        uploading = false;
      });
    }

    Future<void> _uploadPdf() async {
      if (widget.pdfFile == null) return;

      setState(() {
        uploading = true;
      });

      // Make HTTP POST request using Dio
      try {
        Dio dio = Dio();
        Response response = await dio.post(
          "https://salarynow.in/testapi/pdfapi.php",
          data: {'file': base64Encode(widget.pdfFile!.readAsBytesSync())},
        );

        if (response.statusCode == 200) {
          print(response.data);
          // Handle success
        } else {
          // Handle error
          print("Error uploading PDF: ${response.statusCode}");
        }
      } catch (e) {
        print("Error uploading PDF: $e");
      }

      setState(() {
        uploading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.imageFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(widget.imageFile!,
                    width: size.width,
                    height: size.height * .6,
                    fit: BoxFit.cover),
              ),
            if (widget.pdfFile != null)
              Text('PDF Preview: ${widget.pdfFile!.path}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the preview screen
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.purple, // Set the background color to purple
                  ),
                  onPressed: uploading
                      ? null
                      : widget.imageFile != null
                          ? _uploadImage
                          : _uploadPdf,
                  child: Text(
                      widget.imageFile != null ? 'Upload Image' : 'Upload PDF',
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
