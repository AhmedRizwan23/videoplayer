import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NewHompage extends StatefulWidget {
  const NewHompage({
    super.key,
  });

  @override
  State<NewHompage> createState() => _NewHompageState();
}

class _NewHompageState extends State<NewHompage> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool videouploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: chewieController != null
            ? Chewie(
                controller: chewieController!,
              )
            : Center(
                child: videouploading
                    ? const CircularProgressIndicator()
                    : const Text("Upload short video")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadVideo,
        child: const Icon(Icons.upload),
      ),
    );
  }

  Future<void> _uploadVideo() async {
    setState(() {
      videouploading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      await _initializeVideo(filePath);
    }
  }

  Future<void> _initializeVideo(String filePath) async {
    videoPlayerController = VideoPlayerController.file(File(filePath));

    try {
      await videoPlayerController.initialize();
      if (videoPlayerController.value.duration <= const Duration(minutes: 1)) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: true,
          );
        });
      } else {
        Get.snackbar("Upload error", "Video exceeds 1 minute length",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      print("Error initializing video: $error");
    }
    setState(() {
      videouploading = false;
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
