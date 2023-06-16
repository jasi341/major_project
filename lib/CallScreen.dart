import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:major_project/api/apis.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'data/chat_user.dart';
import 'data/message.dart';

class CallScreen extends StatefulWidget {
  final ChatUser user;
  final String toId;
  const CallScreen({Key? key, required this.user, required this.toId,}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String userName = FirebaseAuth.instance.currentUser?.displayName ?? '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Call ID: ${widget.toId}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(widget.toId.isNotEmpty) {
            APIs.sendMessage(
                widget.user,
                "$userName calling",
                Type.text
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VideoCall(
                      name: widget.user.name,
                      id: widget.user.id,
                      callID: widget.toId,
                    ),
              ),
            );
          }
        },
        label: const Text('Join call'),
        icon: const Icon(Icons.video_call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class VideoCall extends StatefulWidget {
  final String name;
  final String id;
  final String callID;

  const VideoCall({
    Key? key,
    required this.name,
    required this.id,
    required this.callID,
  }) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 572364672,
      appSign: '052e5d1434d7f1273ea323a12ce90cd78004b41e41531d819b734b59758e641c',
      userID: widget.id,
      userName: widget.name,
      callID: widget.callID,
      config: ZegoUIKitPrebuiltCallConfig.groupVoiceCall(),
    );
  }
}


