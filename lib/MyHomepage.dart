import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/assets/assets_path.dart';

class Feautredpage extends StatefulWidget {
  const Feautredpage({Key? key}) : super(key: key);

  @override
  State<Feautredpage> createState() => _IntropageState();
}

class _IntropageState extends State<Feautredpage> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset(Assetpath.testvideo);

    videoPlayerController.initialize().then((value) {
      if (videoPlayerController.value.duration <= const Duration(minutes: 1)) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: true,
          );
        });
      } else {
        print("Video duration exceds 1 minute");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chewieController != null
          ? Chewie(
              controller: chewieController!,
            )
          : const Center(
              child: Text("Video duration exceeds 1 minute"),
            ),
    );
  }
}
