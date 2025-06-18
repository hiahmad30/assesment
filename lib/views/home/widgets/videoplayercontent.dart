import 'package:assesment/models/video-model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/video-controller.dart';

class VideoPlayerItem extends StatelessWidget {
  final VideoModel video;

  VideoPlayerItem({required this.video});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoController>();

    return Stack(
      children: [
        // Your video player here
        Positioned(
          right: 20,
          bottom: 100,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  controller.isLiked(video)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isLiked(video) ? Colors.red : Colors.white,
                  size: 30,
                ),
                onPressed: () => controller.toggleLike(video),
              ),
              Text(
                '${video.likedBy.length}',
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 16),

              IconButton(
                icon: Icon(
                  controller.isSaved(video)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => controller.toggleSave(video),
              ),
              Text(
                '${video.savedBy.length}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
