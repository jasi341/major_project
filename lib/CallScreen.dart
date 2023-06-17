import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'data/chat_user.dart';


class VideoCall extends StatefulWidget {
  final ChatUser user;
  final bool isVideo;
  final String toId;

  const VideoCall({
    Key? key,
     required this.isVideo,
    required this.user,
    required this.toId,
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
      userID: widget.user.id,
      userName: widget.user.name,
      callID: widget.toId,
      config: widget.isVideo?
      ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          :  ZegoUIKitPrebuiltCallConfig.groupVoiceCall()

    );
  }
}


