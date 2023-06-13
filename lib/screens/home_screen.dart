import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/data/chat_user.dart';
import 'package:major_project/helper/dialogs.dart';
import 'package:major_project/nav_anim/userprofile_nav_anim.dart';
import 'package:major_project/screens/chat_with_bot/chatWithBot.dart';
import 'package:major_project/screens/update_profile_screen.dart';
import '../widgets/chat_user_card.dart';
import 'auth/login_signup_screen.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {

  List<ChatUser> _list =[];
  final List<ChatUser> _searchList =[];
  bool _isSearching = false;


  @override
  void initState() {
    APIs.getSelfInfo();

    APIs.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('State :$message');

      if(APIs.auth.currentUser !=null) {
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('destroy')) {
          APIs.updateActiveStatus(false);
          // Perform additional cleanup tasks here
        }
      }
      return Future.value(message);
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }

        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              //on clicking user will be redirected to home screen
              leading: Center(child: IconButton(
                onPressed: () {}, icon: const Icon(CupertinoIcons.home),)),
              title: _isSearching?
              CupertinoTextField(
                style: GoogleFonts.robotoSerif(
                    fontStyle: FontStyle.normal,
                    fontSize: 16
                ),
                cursorColor: Colors.grey[700],
                placeholder: 'Name,Email....',
                placeholderStyle: GoogleFonts.robotoSerif(
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Colors.grey[700]
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onChanged: (value) {
                  _searchList.clear();

                  for(var i in _list){
                    if(i.name.toLowerCase().contains(value.toLowerCase()) ||
                        i.email.toLowerCase().contains(value.toLowerCase())
                    ){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }

                },
              ):
              const Text('ChatHub'),
              actions: [
                // search user button
                Center(child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon:  Icon(
                        _isSearching?
                        CupertinoIcons.clear_circled :Icons.search
                    )
                )
                ),
                // more options button
                Center(
                  child: IconButton(
                    onPressed: () {
                      final RenderBox button = context
                          .findRenderObject() as RenderBox;
                      final RenderBox overlay = Overlay
                          .of(context)
                          .context
                          .findRenderObject() as RenderBox;
                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(
                              button.size.topRight(Offset.zero), ancestor: overlay),
                          button.localToGlobal(
                              button.size.topRight(Offset.zero), ancestor: overlay),
                        ),
                        Offset.zero & overlay.size,
                      );

                      showMenu(
                        context: context,
                        position: position,
                        items: <PopupMenuEntry>[
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Update Profile",
                              style: GoogleFonts.robotoSerif(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20

                              ),
                            ),
                          ),

                          PopupMenuItem(
                            value: 2,
                            child: Text(
                              "Chat with bot",
                              style: GoogleFonts.robotoSerif(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text(
                              "Logout",
                              style: GoogleFonts.robotoSerif(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (value != null) {
                          switch (value) {
                            case 1:
                              Navigator.push(context, UserprofileNavAnim(builder: (
                                  context) =>  UpdateProfileScreen(user:APIs.me)));
                              break;
                            case 3:
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Logout"),
                                      content: const Text(
                                          "Are you sure you want to logout?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _signOut();
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (
                                                    context) => const LoginScreen()));
                                            Dialogs.showSnackbar(
                                                context, "Logged out successfully",
                                                Colors.white70,
                                                SnackBarBehavior.floating,
                                                Colors.black);
                                          },
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    );
                                  }
                              );
                              break;
                            case 2:
                              Navigator.push(context, MaterialPageRoute(builder: (
                                  context) => const ChatWithBot()));
                          }
                        }
                      }
                      );
                    },
                    icon: const Icon(Icons.more_vert_outlined),
                  ),
                ),


              ],
            ),
            //to add new user
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xB3000080),
              splashColor: Colors.blueGrey,
              child: const Icon(Icons.add_comment_rounded,),

            ),
            body:Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StreamBuilder(
                  stream: APIs.getAllUsers(),
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return

                          const Center(child: Card(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height:10),
                              CircularProgressIndicator(),
                              SizedBox(height:10),
                              Text('Loading...'),
                            ],
                          )
                          )
                          );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                        if(_list.isNotEmpty){
                          return ListView.builder(
                            itemCount:_isSearching? _searchList.length : _list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index){
                              return  ChatUserCard(
                                user:_isSearching?_searchList[index]:_list[index],
                              );
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
                                    'assets/animation/no-user.json',
                                    repeat: true,
                                    animate: true,
                                    fit: BoxFit.cover,

                                  ),
                                  const SizedBox(height:10),
                                  Text('No users found',style: GoogleFonts.acme(fontSize: 22,),),
                                ],
                              ));
                        }
                    }
                  }
              ),
            )
        ),
      ),
    );
  }
  void _signOut() async {
    Dialogs.showProgressBar(context, Colors.greenAccent, "Logging out...");
    await APIs.updateActiveStatus(false);
    await APIs.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        APIs.auth = FirebaseAuth.instance;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      });


    });

  }
}
