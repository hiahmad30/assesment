import 'dart:io';

import 'package:assesment/models/video-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final videos = <VideoModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    // loadVideos();
    fetchVideos();
  }

  // void loadVideos() {
  //   videos.value = [
  //     VideoModel(
  //       videoUrl:
  //           'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

  //       title: 'Bee Video',
  //     ),
  //     VideoModel(
  //       videoUrl:
  //           'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  //       title: 'Butterfly Video',
  //     ),
  //   ];
  // }

  Future<void> fetchVideos() async {
    final snapshot = await _firestore
        .collection('videos')
        .orderBy('timestamp', descending: true)
        .get();
    videos.value = snapshot.docs.map((doc) {
      return VideoModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  // Future<void> pickAndUploadVideo() async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.video);

  //   if (result != null && result.files.single.path != null) {
  //     File videoFile = File(result.files.single.path!);
  //     String title = "My Upload ${DateTime.now().millisecondsSinceEpoch}";

  //     try {
  //       final uploadTask = await _storage
  //           .ref('videos/${DateTime.now().millisecondsSinceEpoch}.mp4')
  //           .putData(await videoFile.readAsBytes());

  //       final downloadUrl =
  //           'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'; //await uploadTask.ref.getDownloadURL();

  //       await _firestore.collection('videos').add({
  //         'videoUrl': downloadUrl,
  //         'title': title,
  //         'timestamp': DateTime.now().millisecondsSinceEpoch,
  //       });

  //       Get.snackbar('Upload', 'Video uploaded successfully');
  //       fetchVideos(); // refresh list
  //     } catch (e) {
  //       Get.snackbar('Error', 'Failed to upload video: $e');
  //     }
  //   } else {
  //     Get.snackbar('Cancelled', 'No video selected');
  //   }
  // }

  Future<void> toggleLike(VideoModel video) async {
    final uid = _auth.currentUser!.uid;
    final isLiked = video.likedBy.contains(uid);

    final updatedLikes = isLiked
        ? FieldValue.arrayRemove([uid])
        : FieldValue.arrayUnion([uid]);

    await _firestore.collection('videos').doc(video.id).update({
      'likedBy': updatedLikes,
    });

    fetchVideos(); // Refresh list
  }

  Future<void> toggleSave(VideoModel video) async {
    final uid = _auth.currentUser!.uid;
    final isSaved = video.savedBy.contains(uid);

    final updatedSaves = isSaved
        ? FieldValue.arrayRemove([uid])
        : FieldValue.arrayUnion([uid]);

    await _firestore.collection('videos').doc(video.id).update({
      'savedBy': updatedSaves,
    });

    fetchVideos(); // Refresh list
  }

  bool isLiked(VideoModel video) {
    final uid = _auth.currentUser!.uid;
    return video.likedBy.contains(uid);
  }

  bool isSaved(VideoModel video) {
    final uid = _auth.currentUser!.uid;
    return video.savedBy.contains(uid);
  }
}
