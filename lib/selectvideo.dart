import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class NewHompage extends StatefulWidget {
  const NewHompage({
    Key? key,
  }) : super(key: key);

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
      final FlutterFFprobe flutterFFprobe = FlutterFFprobe();

      var mediaInfo = await flutterFFprobe.getMediaInformation(filePath);
      double durationInSeconds = double.parse(
        mediaInfo.getMediaProperties()?['duration'] ?? '0',
      );
      Duration duration = Duration(seconds: durationInSeconds.round());

      if (duration > const Duration(minutes: 1)) {
        // Display an error message when the video exceeds 1 minute length
        Get.snackbar(
          "Upload error",
          "Video exceeds 1 minute length",
          snackPosition: SnackPosition.BOTTOM,
        );

        print("Video exceeds 1 minute length");
        _uploadVideo();
      } else {
        // Proceed to initialize video
        await initializeVideo(filePath);
      }

      // User canceled file selection or video exceeded 1 minute
      setState(() {
        videouploading = false;
      });
    }
  }
  // Future<void> _checkVideoDuration(String filePath) async {
  //   final FlutterFFprobe flutterFFprobe = FlutterFFprobe();

  //   try {
  //     var mediaInfo = await flutterFFprobe.getMediaInformation(filePath);
  //     double durationInSeconds = double.parse(
  //       mediaInfo.getMediaProperties()?['duration'] ?? '0',
  //     );
  //     Duration duration = Duration(seconds: durationInSeconds.round());

  //     if (duration > const Duration(minutes: 1)) {
  //       // Display an error message when the video exceeds 1 minute length
  //       Get.snackbar(
  //         "Upload error",
  //         "Video exceeds 1 minute length",
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       print("Video exceeds 1 minute length");
  //       _uploadVideo();
  //       setState(() {
  //         videouploading = false;
  //       });
  //     } else {
  //       await _initializeVideo(filePath);
  //     }
  //   } catch (error) {
  //     print("Error getting video information: $error");
  //     // Handle the error as needed
  //     setState(() {
  //       videouploading = false;
  //     });
  //   }
  // }

  Future<void> initializeVideo(String filePath) async {
    videoPlayerController = VideoPlayerController.file(File(filePath));

    try {
      await videoPlayerController.initialize();

      // Display the video preview
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,
        );
      });
    } catch (error) {
      print("Error initializing video: $error");
    } finally {
      // Set uploading state to false after completing the initialization
      setState(() {
        videouploading = false;
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
