
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String msg;
  const VideoPlayerScreen({super.key, required this.msg});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  bool isPlaying = false;

  late CachedVideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Video",style: GoogleFonts.acme(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
              child: SizedBox(

                child: Center(
                    child: controller.value.isInitialized
                        ? AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: CachedVideoPlayer(controller))
                        : const CircularProgressIndicator()),
              ),
            ),
            MaterialButton(

              minWidth: 55,
              height: 55,
                onPressed: (){
                  if(isPlaying){
                    controller.pause();
                    setState(() {
                      isPlaying = false;
                    });
                  }else{
                    controller.play();
                    setState(() {
                      isPlaying = true;
                    });

                  }
                },
              shape:const CircleBorder(),
              color: Colors.white,
                child: Icon(
                  isPlaying?
                  Icons.pause:Icons.play_arrow,
                  color: Colors.black,
                  size: 35,
                ),
            ),
          ],
        )

    );
  }

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(
        widget.msg);
    controller.play();
    controller.initialize().then((value) {
      setState(() {
        isPlaying = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.pause();
    setState(() {
      isPlaying = false;
    });
    controller.dispose();
    super.dispose();
  }

}
