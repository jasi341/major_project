import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/data/chat_user.dart';
import 'package:major_project/data/message.dart';
import '../api/apis.dart';
import '../helper/dateUtils.dart';
import '../nav_anim/chat_nav_anim.dart';
import '../screens/ChatScreen.dart';

class ChatUserCard extends StatefulWidget {

  final  ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  Message? _message ;

  @override
  Widget build(BuildContext context) {
    return   Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
      child: InkWell(
          splashColor: Colors.black.withOpacity(0.7),
          onTap: (){
            Navigator.push(context, ChatNavAnim(
              builder: (context) =>  ChatScreen(user:widget.user),
            )
            );
          },
          child: StreamBuilder(
            stream: APIs.getLastMessages(widget.user),
            builder:(context,snapshot){

              final data = snapshot.data?.docs;
              final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if(list.isNotEmpty){
                _message = list.first;
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  tileColor: const Color(0xffffffff),
                  leading :CircleAvatar(
                    radius: 23,
                    child: ClipOval(
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const CircularProgressIndicator(color: Colors.yellow),
                          ),
                          errorWidget: (context, url, error) =>  CircleAvatar(
                            child: Image.asset('assets/images/profile.png'),
                          ),
                        ),
                      ),
                    ),
                  ),

                  title: Text(widget.user.name,style: GoogleFonts.roboto(),),
                  subtitle: Row(
                    children: [
                      _message != null && _message!.type == Type.image?
                        Row(
                          children: [
                            const Icon(Icons.image,size: 15,color: Colors.grey,),
                            const SizedBox(width: 5,),
                            Text('Image',style: GoogleFonts.roboto(color: Colors.black54),),
                          ],
                        ):
                    _message != null && _message!.type == Type.text?
                      Text(
                        _message!.msg.length > 14? '${_message!.msg.substring(0,14)}...':_message!.msg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(),
                      ):
                        _message != null && _message!.type == Type.video?
                        Row(
                          children: [
                            const Icon(Icons.video_camera_back_outlined,size: 15,color: Colors.grey,),
                            const SizedBox(width: 5,),
                            Text('Video',style: GoogleFonts.roboto(color: Colors.black54),),
                          ],
                        ): const SizedBox(),
                    ],
                  ),
                  trailing:_message== null? null :
                      _message!.read.isEmpty  && _message!.fromId != APIs.user.uid?
                      const Icon(Icons.circle,size: 15,color: Colors.green,):
                      Text(MyDateUtils.getLastMessageTime(context: context, time: _message!.sent),
                          style: GoogleFonts.roboto(color: Colors.black54)
                      ),
                ),
              );

            } ,
          )
      ),
    );
  }
}
