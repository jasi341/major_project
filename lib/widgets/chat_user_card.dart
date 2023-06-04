import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/data/chat_user.dart';

class ChatUserCard extends StatefulWidget {

  final  ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return   Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.7),
        onTap: (){
          print('img : ${widget.user.image}');
        },
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          tileColor: Colors.blue,
          leading :CircleAvatar(
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

          title: Text(widget.user.name,style: GoogleFonts.roboto(),),
          subtitle: Text(widget.user.about,maxLines: 1,style: GoogleFonts.roboto(),),
          trailing: Container(
            width :9,
            height: 9,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.shade400,
            ),


          ),
          //Text('12:00 PM',style: GoogleFonts.roboto(color: Colors.black54)),
        ),
      ),
    );
  }
}
