import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/data/chat_user.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user ;

  const ChatScreen({super.key,required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF000080),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xffececec),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [

              Expanded(
                child: StreamBuilder(
                   // stream: APIs.getAllUsers(),
                    builder: (context,snapshot){
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          // return
                          //
                          //   const Center(child: Card(child: Padding(
                          //     padding: EdgeInsets.all(8.0),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         SizedBox(height:10),
                          //         SizedBox(width: 50,),
                          //         CircularProgressIndicator(),
                          //         SizedBox(height:10),
                          //         Text('Loading...'),
                          //       ],
                          //     ),
                          //   )
                          //   )
                          //   );

                        case ConnectionState.active:
                        case ConnectionState.done:
                          // final data = snapshot.data?.docs;
                          // _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                      final _list =[];
                          if(_list.isNotEmpty){
                            return ListView.builder(
                              itemCount: _list.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context,index){
                                return  Text('Message:${_list[index]}');
                              },
                            );

                          }else{
                            return  Center(
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
                            );
                          }
                      }
                    }
                ),
              ),
              _chatInput()
            ],
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
                    },
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.blue),
                  ),
                  Expanded(child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.robotoSerif(
                        color: Colors.black87 ,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic
                    ),
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
                    onPressed: () {
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
              onPressed: (){},
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
}

