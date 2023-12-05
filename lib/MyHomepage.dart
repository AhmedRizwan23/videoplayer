import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class Feautredpage extends StatefulWidget {
  const Feautredpage({super.key});

  @override
  State<Feautredpage> createState() => _IntropageState();
}

class _IntropageState extends State<Feautredpage> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset("lib/assets/introvideo.mp4");
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        allowMuting: true,
        allowFullScreen: true,
        //   controlsSafeAreaMinimum: const EdgeInsets.symmetric(vertical: 20),

        aspectRatio: 21 / 10);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey.shade700,
                  child: Chewie(controller: chewieController)),
            ],
          ),
        ),
      ]),
    );
  }
}
