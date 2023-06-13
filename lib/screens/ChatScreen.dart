import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/data/chat_user.dart';

import '../api/apis.dart';
import '../data/message.dart';
import '../helper/dateUtils.dart';
import '../widgets/message_card.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user ;

  const ChatScreen({super.key,required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF000080),
        ),
        child: GestureDetector(
          onTap: (){
            setState(() {
              _showEmoji = false;
              FocusScope.of(context).unfocus();
            });
          },
          child: WillPopScope(
            onWillPop: ()  {
              if(_showEmoji){
                setState(() {
                  _showEmoji = !_showEmoji;
                });
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: const Color(0xfff7ede2),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
              ),
              body: Column(
                children: [

                  Expanded(
                    child: StreamBuilder(
                        stream: APIs.getAllMessages(widget.user),
                        builder: (context,snapshot){
                          switch(snapshot.connectionState){
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const SizedBox();
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                              if(_list.isNotEmpty){
                                return ListView.builder(
                                  reverse: true,

                                  itemCount: _list.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context,index){
                                    return   MessageCard(message: _list[index]);
                                  },
                                );

                              }else{
                                return  GestureDetector(
                                  onTap: (){
                                    _textController.text = 'Hi';
                                  },
                                  child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          LottieBuilder.asset(
                                            'assets/animation/sayhi.json',
                                            repeat: true,
                                            animate: true,
                                            fit: BoxFit.cover,

                                          ),
                                          const SizedBox(height:10),
                                        ],
                                      )
                                  ),
                                );
                              }
                          }
                        }
                    ),
                  ),
                  if(_isUploading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CircularProgressIndicator(strokeWidth: 2,)
                      ),
                    ),
                  _chatInput(),
                  if(_showEmoji)
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.35,
                      child: EmojiPicker(
                          textEditingController: _textController,
                          config: Config(
                            bgColor: const Color(0xfff7ede2),
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),

                          )
                      ),
                    )
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>Scaffold(
              backgroundColor: const Color(0xff1b242d),
              appBar: AppBar(
                backgroundColor: const Color(0xff3a5872),
                title: Text(widget.user.name),
              ),
              body: Stack(
                  children:[ Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 25,),
                      Center(
                        child: CircleAvatar(
                          maxRadius: MediaQuery.of(context).size.width*0.25,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              height: MediaQuery.of(context).size.width*0.5,
                              width: MediaQuery.of(context).size.width*0.5,
                              imageUrl: widget.user.image,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const CircularProgressIndicator(color: Colors.green),
                              errorWidget: (context, url, error) =>  CircleAvatar(
                                child: Image.asset('assets/images/profile.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const SizedBox(height: 10,),
                      Text(
                        "About :${widget.user.about}",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),),
                      const SizedBox(height: 10,),

                    ],
                  ),
                    Positioned(
                      bottom: 10,
                      left:MediaQuery.of(context).size.width*0.25,
                      right: MediaQuery.of(context).size.width*0.25,
                      child: Text(
                        "Joined on :${MyDateUtils.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true)}",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),),
                    ),

                  ]
              ),
            )));
      },
      child: StreamBuilder(
        stream:APIs.getUserInfo(widget.user),
        builder: (context,snapshot){

          final data = snapshot.data?.docs;
          final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Container(color:const Color(0xFF000080) ,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white), ),
                CircleAvatar(
                  radius: 19,
                  child: ClipOval(
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: CachedNetworkImage(
                        imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(color: Colors.yellow),
                        errorWidget: (context, url, error) =>  CircleAvatar(
                          child: Image.asset('assets/images/profile.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name :
                      widget.user.name,
                      style: GoogleFonts.acme(fontSize: 20,color: Colors.white),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                        list.isNotEmpty ?
                        list[0].isOnline?'Online':
                        MyDateUtils.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                            :MyDateUtils.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                        style: GoogleFonts.acme(fontSize: 13,color: Colors.white.withAlpha(210))
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chatInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.white,
              elevation: 2,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.blue),
                  ),
                  Expanded(
                      child: TextField(
                        onTap: (){

                          setState(() {
                            _showEmoji = false;
                          });
                        },
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.robotoSerif(
                            color: Colors.black87 ,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal
                        ),
                        onSubmitted: (value){
                          validateAndSend();
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: 'Type SomeThing...',
                            hintStyle: GoogleFonts.acme(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.normal
                            ),
                            border: InputBorder.none
                        ),
                      )),
                  IconButton(
                    onPressed: (){
                      _showBottomSheet();
                    },
                    icon:  const Icon(CupertinoIcons.paperclip, color: Colors.blue,size: 25),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                      if(image!= null){
                        setState(() {
                          _isUploading = true;
                        });
                        await APIs.sendChatImage(widget.user,File(image.path));
                        setState(() {
                          _isUploading = false;
                        });
                      }
                    },

                    icon:  const Icon(CupertinoIcons.camera_fill, color: Colors.blue,size: 25),
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: MaterialButton(
              elevation: 2,
              splashColor: Colors.blueGrey,
              padding: const EdgeInsets.all(10),
              onPressed: (){
                validateAndSend();
              },
              shape: const CircleBorder(),
              minWidth: 5,
              color: Colors.green,
              child: const Center(child: Icon(Icons.send_sharp,size: 25,color: Colors.white,)),
            ),
          )
        ],
      ),
    );
  }

  void validateAndSend() {
    if(_textController.text.isNotEmpty){
      APIs.sendMessage(
          widget.user,
          _textController.text,
          Type.text

      );
      _textController.clear();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Enter Some Text !'),
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            closeIconColor: Colors.green,
            showCloseIcon: true,


          ));
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
        builder: (_){
          return SizedBox(
              height: MediaQuery.of(context).size.height*0.32,
              child: Stack(
                children: [
                  const SizedBox(height: 10,),
                  Positioned(
                      right: 10,
                      top: 5,
                      child:  GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.cancel, color: Colors.grey,),
                              const SizedBox(width:2,),
                              Text('Close',style: GoogleFonts.acme(fontSize: 17,color: Colors.grey),)
                            ],
                          ),
                        ),
                      )
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10,),
                      Divider(
                        color: Colors.grey,
                        thickness: 5,
                        height: 3,
                        endIndent: MediaQuery.of(context).size.width*.42,
                        indent:  MediaQuery.of(context).size.width*.42,),
                      const SizedBox(height: 30,),
                      Center(
                          child: Text(
                            'Choose From',
                            style: GoogleFonts.robotoSerif(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w700
                            ),
                          )
                      ),
                      const SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          //for gallery
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                            color: Colors.white70,
                            elevation: 25,
                            shadowColor: Colors.black,
                            child: InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

                                setState(() {
                                  _isUploading = true;
                                });
                                if(mounted) {
                                  Navigator.pop(context);
                                }
                                for(var i in images){
                                  await APIs.sendChatImage(widget.user,File(i.path)
                                  );
                                }
                                setState(() {
                                  _isUploading = false;
                                });


                              },
                              splashColor: Colors.tealAccent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/images/gallery.png',width: 60,height: 60,),
                                    const SizedBox(height:5),
                                    Text('Photo',style: GoogleFonts.acme(fontSize: 22,),),
                                  ],
                                ),
                              ),
                            ),
                          ),


                          //for video
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                            color: Colors.white,
                            elevation: 25,
                            shadowColor: Colors.black,
                            child: InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

                                if(mounted) {
                                  Navigator.pop(context);
                                }
                                if(video!= null){
                                  setState(() {
                                    _isUploading = true;
                                  });
                                  await APIs.sendChatVideo(widget.user,File(video.path));
                                  setState(() {
                                    _isUploading = false;
                                  });
                                }
                              },

                              splashColor: Colors.tealAccent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/images/video.png',width: 60,height: 60,),
                                    const SizedBox(height:5),
                                    Text('Video',style: GoogleFonts.acme(fontSize: 22,),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,)
                    ],
                  )

                ],
              ));
        });

  }


}

