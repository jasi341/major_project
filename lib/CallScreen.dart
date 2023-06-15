import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'data/chat_user.dart';
import 'data/message.dart';

class CallScreen extends StatefulWidget {
  final ChatUser user;
  final Message message;
  const CallScreen({Key? key, required this.user, required this.message}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String? _callID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Call ID: ${widget.message.toId}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_callID != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoCall(
                  name: widget.user.name,
                  id: widget.user.id,
                  callID: widget.message.toId,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please start a call first.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
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


