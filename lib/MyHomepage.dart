import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';

class newlogic extends StatefulWidget {
  const newlogic({Key? key}) : super(key: key);

  @override
  State<newlogic> createState() => _newlogicState();
}

class _newlogicState extends State<newlogic> {
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
        onPressed: () => _pickVideo(context), // Pass context to _pickVideo
        child: const Icon(Icons.upload),
      ),
    );
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final picker = ImagePicker();
      var pickedFile = await picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 60));
      if (pickedFile == null) {
        return;
      }

      VideoPlayerController testLengthController =
          VideoPlayerController.file(File(pickedFile.path));
      await testLengthController.initialize();

      if (testLengthController.value.duration.inSeconds > 60) {
        pickedFile = null;
        _showVideoDurationDialog(
            context); // Show dialog on the file picker screen
      } else {
        setState(() {
          videoPlayerController =
              VideoPlayerController.file(File(pickedFile!.path));
          _startVideoPlayer();
        });
      }
      testLengthController.dispose();
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
      return;
    }
  }

  void _showVideoDurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.black,
          content: Text(
            'We only allow videos that are shorter than 1 minute!',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    ).then((value) {
      // This will be executed after the dialog is dismissed
      _pickVideo(context);
    });
  }

  void _startVideoPlayer() async {
    try {
      await videoPlayerController.initialize();

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
