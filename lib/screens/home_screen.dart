import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:major_project/screens/chat_with_bot/chatWithBot.dart';

import 'auth/login_signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar:
      AppBar(
        //on clicking user will be redirected to home screen
        leading: Center(child: IconButton(onPressed: (){},icon: const Icon(CupertinoIcons.home),)),
        title: const Text('ChatHub'),
        actions: [
          // search user button
          Center(child: IconButton(onPressed: (){}, icon: const Icon(Icons.search))),
          // more options button
          Center(
            child: IconButton(
              onPressed: () {
                final RenderBox button = context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(button.size.topRight(Offset.zero), ancestor: overlay),
                    button.localToGlobal(button.size.topRight(Offset.zero), ancestor: overlay),
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
                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateProfile()));
                        break;
                      case 3:
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: (){

                                      _signOut();
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

                                      Fluttertoast.showToast(
                                          msg: "Logged out successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            }
                        );
                        break;
                        case 2:
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChatWithBot()));
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
      floatingActionButton:FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color(0xB3000080),
        splashColor: Colors.blueGrey,
        child: const Icon(Icons.add_comment_rounded,),

      ) ,

    );
  }
}

void _signOut()async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();


}
