import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  File? _selectedVideo;
  final captionController = TextEditingController();
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadVideo() async {
    if (captionController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a video and add a caption",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = ref.putFile(_selectedVideo ?? File(''));

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('videos').add({
        'videoUrl': downloadUrl,
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', //downloadUrl,
        'title': captionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Video uploaded",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      setState(() {
        _selectedVideo = null;
        captionController.clear();
        _isUploading = false;
        _uploadProgress = 0.0;
      });

      Get.back(); // Go back to home
    } catch (e) {
      setState(() => _isUploading = false);
      Get.snackbar(
        "Upload Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _selectedVideo == null
                ? OutlinedButton.icon(
                    onPressed: pickVideo,
                    icon: Icon(Icons.video_library),
                    label: Text("Select Video"),
                  )
                : Text(
                    "Video selected: ${_selectedVideo?.path.split('/').last}",
                  ),
            SizedBox(height: 20),

            // Caption input
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                labelText: "Video Caption",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Upload button or progress
            _isUploading
                ? Column(
                    children: [
                      LinearProgressIndicator(value: _uploadProgress),
                      SizedBox(height: 10),
                      Text(
                        "${(_uploadProgress * 100).toStringAsFixed(1)}% uploaded",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: uploadVideo,
                    icon: Icon(Icons.cloud_upload),
                    label: Text("Upload Video"),
                  ),
          ],
        ),
      ),
    );
  }
}
