import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/home/upload_video/upload_form.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  getVideoFile(ImageSource sourceImg) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);
    if (videoFile != null) {
      Get.to(
        UploadForm(
          videoFile: File(videoFile.path),
          videoPath: videoFile.path,
        ),
      );
    }
  }

  displayDialogBox() {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    getVideoFile(ImageSource.gallery);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Get Video from Phone Gallery',
                            maxLines: 3,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    getVideoFile(ImageSource.camera);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Make Video with Phone Camera',
                            maxLines: 3,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.cancel),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/upload.png",
              width: 260,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  //display dialog box
                  displayDialogBox();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Upload New Video',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
