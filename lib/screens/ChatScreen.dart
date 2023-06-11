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
import '../widgets/message_card.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user ;

  const ChatScreen({super.key,required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = ScrollController();

  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false;

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
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                                return ListView.builder(

                                  controller: _scrollController,
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
      onTap: (){},
      child: Container(color:const Color(0xFF000080) ,
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
                    imageUrl: widget.user.image,
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
                Text(widget.user.name,style: GoogleFonts.acme(fontSize: 20,color: Colors.white),),
                const SizedBox(height: 2,),
                Text(widget.user.lastActive,style: GoogleFonts.acme(fontSize: 13,color: Colors.white.withAlpha(210)))
              ],)
          ],
        ),
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
                    onPressed: () {
                    },
                    icon:  const Icon(CupertinoIcons.photo_fill, color: Colors.blue,size: 25),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                      if(image!= null){
                        await APIs.sendChatImage(widget.user,File(image.path));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enter Some Text'),duration: Duration(milliseconds: 1500),));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut
      );
    }
  }


}

