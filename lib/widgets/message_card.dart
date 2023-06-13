import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/helper/dateUtils.dart';
import 'package:major_project/widgets/videoplayer_screen.dart';
import '../data/message.dart';
import 'package:cached_video_preview/cached_video_preview.dart';

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
              child: widget.message.type == Type.text?
              Text(
                widget.message.msg,
                style: GoogleFonts.robotoSerif(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17
                ),
              )
                  : widget.message.type == Type.video?
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>
                          VideoPlayerScreen(msg: widget.message.msg,)
                      )
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.75 ,
                  height: MediaQuery.of(context).size.height*0.4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      CachedVideoPreviewWidget(
                        path: widget.message.msg,
                        type: SourceType.remote,
                        remoteImageBuilder: (BuildContext context, url) => Image.network(url),
                      ),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 60,
                        color: Colors.white,
                      ),

                    ],
                  ),
                ),
              )

                  :GestureDetector(

                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Scaffold(
                        backgroundColor: Colors.white70,
                        appBar: AppBar(
                          backgroundColor: Colors.blueAccent.shade700,
                          title: const Text("Image"),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: CachedNetworkImage(
                                  width:MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height,
                                  imageUrl: widget.message.msg,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(strokeWidth:2,color: Colors.yellow),
                                  ),
                                  errorWidget: (context, url, error) =>   const Icon(
                                    Icons.image,size: 70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.75 ,
                    height: MediaQuery.of(context).size.height*0.4,
                    child: CachedNetworkImage(
                      width:MediaQuery.of(context).size.width*0.75 ,
                      height: MediaQuery.of(context).size.height/2,
                      imageUrl: widget.message.msg,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth:2,color: Colors.yellow),
                      ),
                      errorWidget: (context, url, error) =>   const Icon(
                        Icons.image,size: 70,
                      ),
                    ),
                  ),
                ),
              )


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
              padding:  EdgeInsets.all(widget.message.type == Type.text ?
              14:4
              ),
              decoration:  const BoxDecoration(
                color: Color(0xff0F4857),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:
              widget.message.type == Type.text?

              Text(
                widget.message.msg,
                style: GoogleFonts.robotoSerif(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17
                ),
              ):
              widget.message.type == Type.video?
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>
                          VideoPlayerScreen(msg: widget.message.msg,)
                      )
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.75 ,
                  height: MediaQuery.of(context).size.height*0.4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      CachedVideoPreviewWidget(
                        path: widget.message.msg,
                        type: SourceType.remote,
                        remoteImageBuilder: (BuildContext context, url) => Image.network(url),
                      ),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 60,
                        color: Colors.white,
                      ),

                    ],
                  ),
                ),
              ):
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Scaffold(
                        backgroundColor: const Color(0xff0F4857),
                        appBar: AppBar(
                          backgroundColor: Colors.blueAccent.shade700,
                          title: const Text("Image"),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10) ,
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: CachedNetworkImage(
                                  width:MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height,
                                  imageUrl: widget.message.msg,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const CircularProgressIndicator(strokeWidth:2,color: Colors.yellow),
                                  errorWidget: (context, url, error) =>   const Icon(
                                    Icons.image,size: 70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.75 ,
                    height: MediaQuery.of(context).size.height*0.4,
                    child: CachedNetworkImage(
                      width:MediaQuery.of(context).size.width*0.75 ,
                      height: MediaQuery.of(context).size.height/2,
                      imageUrl: widget.message.msg,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth:2,color: Colors.yellow),
                      errorWidget: (context, url, error) =>   const Icon(
                        Icons.image,size: 70,
                      ),
                    ),
                  ),
                ),
              )
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

