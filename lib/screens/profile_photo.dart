import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final profilePic;
  const ProfilePhotoScreen({super.key, this.profilePic});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {

  bool _isLottiePlaying = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2500),() {
      setState(() {
        _isLottiePlaying = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Profile Photo'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PinchZoom(
            maxScale: 5,
            resetDuration: const Duration(milliseconds: 1500),
            zoomEnabled: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.width*0.75,
                width: MediaQuery.of(context).size.width*0.75,
                imageUrl: widget.profilePic,
                placeholder: (context, url) => const CircularProgressIndicator(color: Colors.green),
                errorWidget: (context, url, error) =>  CircleAvatar(
                  child: Image.asset('assets/images/profile.png'),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isLottiePlaying,
            child: LottieBuilder.asset(
              'assets/animation/pinch.json',
              repeat: true,
              animate: true,
              fit: BoxFit.cover,

            ),
          ),
        ],
      ),
    );

  }
}
