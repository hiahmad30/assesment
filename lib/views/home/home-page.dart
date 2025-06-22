import 'package:assesment/controllers/video-controller.dart';
import 'package:assesment/views/home/widgets/upload-video.dart';
import 'package:assesment/views/home/widgets/videoplayercontent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoController());

    return Scaffold(
      body: Obx(
        () => PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.videos.length,
          itemBuilder: (context, index) {
            return VideoPlayerItem(video: controller.videos[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => VideoUploadPage());
          controller.fetchVideos();
        }, // => controller.pickAndUploadVideo(),

        child: Icon(Icons.add),
      ),
    );
  }
}
