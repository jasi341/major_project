import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/helper/dateUtils.dart';
import 'package:major_project/helper/dialogs.dart';
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

    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: (){
        _showBottomSheet(isMe);
      },
      child: isMe?_greyMessage():_blueMessage() ,);

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

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
        builder: (_){
          return  ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            children: [
              const SizedBox(height: 10,),
              Divider(
                color: Colors.grey,
                thickness: 5,
                height: 3,
                endIndent: MediaQuery.of(context).size.width*.42,
                indent:  MediaQuery.of(context).size.width*.42,),
              const SizedBox(height: 20,),

              widget.message.type == Type.text?
              _OptionItem(
                  icon: const Icon(Icons.copy,color: Colors.black87,size: 26,),
                  name:'Copy Message',
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.message.msg));
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Copied to Clipboard")));
                    }
                  }
              ): _OptionItem(
                  icon: const Icon(CupertinoIcons.down_arrow,color: Colors.black87,size: 26,),
                  name:'Save Image/Video',
                  onTap: () async {
                    Navigator.pop(context);
                    Dialogs.showProgressBar(context, Colors.green, "Saving...");
                    if(widget.message.type == Type.image) {
                      try{
                        await GallerySaver.saveImage(widget.message.msg,albumName: "ChatHub")
                            .then((success) {
                          Navigator.pop(context);

                          if(success!=null && success){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Saved to Gallery"))
                            );
                          }
                        });
                      }catch(e){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Something went wrong"))
                        );
                      }

                    }
                    else {

                      try{
                        await GallerySaver.saveVideo(widget.message.msg,albumName: "ChatHub")
                            .then((success) {
                          Navigator.pop(context);
                          if(success!=null && success){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Saved to Gallery"))
                            );
                          }
                        });
                      }catch(e){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Something went wrong"))
                        );
                      }
                    }
                  }
              ),
              const Divider(
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              if( widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit,color: Colors.blueAccent,size: 26,),
                    name:'Edit Message',
                    onTap: (){
                      Navigator.pop(context);
                      _showMessageUpdateDialog();

                    }
                ),

              if(isMe)
                _OptionItem(
                    icon: const Icon(CupertinoIcons.delete,color: Colors.red,size: 26,),
                    name:'Delete Message',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(context: context, builder:
                          (context){
                        return AlertDialog(
                          title:  Text(
                              'Delete Message',
                            style: GoogleFonts.acme(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87
                            )
                          ),
                          content:  Text(
                              'Are you sure you want to delete this message?',
                              style: GoogleFonts.acme(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87
                              )
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text(
                                  'Cancel',
                                style:GoogleFonts.acme(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87
                                )
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                await APIs.deleteMessage(widget.message).then((value){
                                  Fluttertoast.showToast(
                                      msg: "Message Deleted",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );

                                });
                              },
                              child:  Text(
                                'Delete',
                                style:GoogleFonts.acme(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red
                                )
                              ),
                            ),
                          ],
                        );
                      }
                      );


                    }
                ),
              if(isMe)
                const Divider(
                  color: Colors.grey,
                  indent: 20,
                  endIndent: 20,
                ),
              _OptionItem(
                  icon: const Icon(CupertinoIcons.eye_solid,color: Colors.grey,size: 26,),
                  name:'Send At: ${MyDateUtils.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: (){}
              ),
              _OptionItem(
                  icon: const Icon(CupertinoIcons.eye_solid,color: Colors.blue,size: 26,),
                  name: widget.message.read.isEmpty?'Not Read yet':'Read At:${MyDateUtils.getLastMessageTime(context: context, time: widget.message.read)}',
                  onTap: (){}
              ),

            ],
          );
        }
    );

  }

  void _showMessageUpdateDialog() {
    String updatedMessage = widget.message.msg;

    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit,color: Colors.black87,size: 26,),
                  const SizedBox(width: 10,),
                  Text(
                      "Edit Message",
                      style: GoogleFonts.acme(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                      )
                  ),
                ],
              ),
              content: TextFormField(
                initialValue: widget.message.msg,
                onChanged: (value){
                  updatedMessage = value;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black87)
                  ),
                    hintText: "Enter Message",
                    hintStyle: GoogleFonts.acme(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87
                    )
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child:  Text(
                        "Cancel",
                        style: GoogleFonts.acme(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey
                        )
                    )
                ),
                TextButton(
                    onPressed: () async {
                      await APIs.updateMessage(widget.message, updatedMessage).then((value){
                        if(mounted){
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Message Updated")));
                        }
                      });
                    },
                    child:  Text(
                        "Update",
                        style: GoogleFonts.acme(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue
                        )
                    )
                ),
              ],
            )
    );

  }




}
class _OptionItem extends StatelessWidget {

  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({required this.icon, required this.name, required this.onTap});



  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: ()=>onTap(),
        child: Padding(
          padding:  EdgeInsets.only(
            left : MediaQuery.of(context).size.width*0.05,
            top: MediaQuery.of(context).size.height*0.001,
            bottom: MediaQuery.of(context).size.height*0.02,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10,),
              icon,
              const SizedBox(width: 10,),
              Flexible(
                child: Text(
                  name,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.acme(
                      fontStyle: FontStyle.normal,
                      color: Colors.black87,
                      fontSize: 18,
                      letterSpacing: 1
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}


