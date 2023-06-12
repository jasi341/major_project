import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String msg;
  const VideoPlayerScreen({super.key, required this.msg});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  bool isPlaying = false;
  bool isVisible = false;

  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Video",style: GoogleFonts.acme(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),),
        ),
        body: GestureDetector(
          onTap: (){
            setState(() {
              isVisible = !isVisible;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(

                  child: Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: _controller.value.isInitialized
                                  ? VideoPlayer(_controller)
                                  : const CircularProgressIndicator()
                          )
                      )
                          : const CircularProgressIndicator()),
                ),
                Visibility(
                  visible: isVisible,
                  child: MaterialButton(

                    minWidth: 55,
                    height: 55,
                    onPressed: (){
                      if(isPlaying){
                        _controller.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      }else{
                        _controller.play();
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
                      size: 45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        widget.msg);
    _controller.play();
    _controller.initialize().then((value) {
      setState(() {
        isPlaying = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    setState(() {
      isPlaying = false;
    });
    _controller.dispose();
    super.dispose();
  }

}
