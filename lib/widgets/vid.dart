import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';



class VidApp extends StatelessWidget {
  const VidApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CachedVideoPlayerController controller;
  @override
  void initState() {
    controller = CachedVideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/chathub-7a862.appspot.com/o/videos%2F7HF2NoGGBhf21FSYWVzfmqHAtJ72_lLyzXcQdpRYNKyGDEYsLpxpzhlt1%2F1686487876501.mp4?alt=media&token=8338b092-9243-4205-9025-e54d97b0ad25");
    controller.initialize().then((value) {
      controller.play();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: controller.value.isInitialized
              ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CachedVideoPlayer(controller))
              : const CircularProgressIndicator()),
    );
  }
}