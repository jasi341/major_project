import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/helper/dateUtils.dart';

import '../nav_anim/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId? _greyMessage():_blueMessage();
  }

  Widget _blueMessage(){
    
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
     // print(object)
      
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 14),
            decoration:  const BoxDecoration(
              color:  Color(0x2b0f4857),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              widget.message.msg,
              style: GoogleFonts.robotoSerif(
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),

            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_outlined,size: 19,color: Colors.blue,),
              if(widget.message.read.isEmpty)
                const Icon(Icons.done_outlined,size: 19,color: Colors.grey,),
              const SizedBox(width: 2,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                    MyDateUtils.getFormattedDate(context: context,time: widget.message.sent),
                    style: GoogleFonts.acme(
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                        fontSize: 12
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greyMessage(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 14),
            decoration:  const BoxDecoration(
              color: Color(0xff0F4857),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              widget.message.msg,
              style: GoogleFonts.robotoSerif(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 17
              ),

            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              if(widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_outlined,size: 19,color: Colors.blue,),
              if(widget.message.read.isEmpty)
                const Icon(Icons.done_outlined,size: 19,color: Colors.grey,),
              const SizedBox(width: 2,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                    MyDateUtils.getFormattedDate(context: context,time: widget.message.sent),
                    style: GoogleFonts.acme(
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                        fontSize: 12
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
