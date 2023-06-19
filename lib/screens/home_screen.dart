import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/data/chat_user.dart';
import 'package:major_project/helper/dialogs.dart';
import 'package:major_project/nav_anim/userprofile_nav_anim.dart';
import 'package:major_project/screens/chat_with_bot/chatgpt.dart';
import 'package:major_project/screens/update_profile_screen.dart';
import '../color_pallete/pallete.dart';
import '../widgets/chat_user_card.dart';
import 'auth/login_signup_screen.dart';
import 'chat_with_bot/chatWithBot.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with WidgetsBindingObserver {

  List<ChatUser> _list =[];
  final List<ChatUser> _searchList =[];
  bool _isSearching = false;
  bool isLoggedOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    APIs.getSelfInfo();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    APIs.updateActiveStatus(false);
    // Perform additional cleanup tasks here
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('State :$state');
    if (APIs.auth.currentUser != null) {
      if (state == AppLifecycleState.paused) {
        APIs.updateActiveStatus(false);
      } else if (state == AppLifecycleState.resumed) {
        APIs.updateActiveStatus(true);
      }else if (state == AppLifecycleState.detached) {
        APIs.updateActiveStatus(false);
        log('Destroyed :hi');

      }
    }
  }


  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching || isLoggedOut){
            setState(() {
              _isSearching = !_isSearching;
              isLoggedOut = true;
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
                                            setState(() {
                                              isLoggedOut = true;
                                            });
                                            // _signOut();
                                            Dialogs.showProgressBar(context,Colors.black ,'Logging out...');
                                            APIs.signOut();

                                            APIs.auth = FirebaseAuth.instance;

                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                               Navigator.pop(context);
                                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

                                            });


                                          },
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    );
                                  }
                              );
                              break;
                            case 2:
                              //Dialogs.showSnackbar(context,' Coming soon', Colors.grey, SnackBarBehavior.fixed, Colors.black87);
                              Navigator.push(context, MaterialPageRoute(builder: (
                                  context) => const ChatGptScreen()));
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
              onPressed: () {
                _addChatUserDialog();
              },
              backgroundColor: Pallete.secondSuggestionBoxColor,
              child: const Center(child: Icon(CupertinoIcons.person_add,size : 30)),

            ),
            body:Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: StreamBuilder(
                    stream: APIs.getMyUsersId(),
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
                          if(!snapshot.hasData|| snapshot.data!.docs.isEmpty) {
                            return Center(
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
                                  const SizedBox(height: 10),
                                  Text(
                                    'No connections found',
                                    style: GoogleFonts.acme(fontSize: 22),
                                  ),
                                ],
                              ),
                            );

                          }else {
                            return StreamBuilder(
                              stream: APIs.getAllUsers(
                                  snapshot.data?.docs.map((e) => e.id)
                                      .toList() ?? []),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return const Center(
                                        child: Card(child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            CircularProgressIndicator(),
                                            SizedBox(height: 10),
                                            Text('Loading...'),
                                          ],
                                        )
                                        )
                                    );

                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final data = snapshot.data?.docs;
                                    _list = data?.map((e) =>
                                        ChatUser.fromJson(e.data())).toList() ??
                                        [];

                                    if (_list.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: _isSearching ? _searchList
                                            .length : _list.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ChatUserCard(
                                            user: _isSearching
                                                ? _searchList[index]
                                                : _list[index],
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              LottieBuilder.asset(
                                                'assets/animation/no-user.json',
                                                repeat: true,
                                                animate: true,
                                                fit: BoxFit.cover,

                                              ),
                                              const SizedBox(height: 10),
                                              Text('No Connections found',
                                                style: GoogleFonts.acme(
                                                  fontSize: 22,),),
                                            ],
                                          ));
                                    }
                                }
                              }
                          );
                          }

                      }
                    })
            )
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              title: Row(
                children: [
                  const Icon(CupertinoIcons.person_add,color: Colors.black87,size: 26,),
                  const SizedBox(width: 10,),
                  Text(
                      "Add User",
                      style: GoogleFonts.robotoSerif(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                      )
                  ),
                ],
              ),
              content: TextFormField(
                onChanged: (value){
                  email = value;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black87)
                    ),
                    hintText: "Email Id",
                    prefixIcon:  Icon(CupertinoIcons.mail,color: Colors.grey.shade700,),
                    hintStyle: GoogleFonts.robotoSerif(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey
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
                        style: GoogleFonts.robotoSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey
                        )
                    )
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if(email.isNotEmpty){
                        APIs.addChatUser(email).then((value){

                          if(!value){

                            Fluttertoast.showToast(
                                msg: "User does not exist!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "User added successfully!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        }
                        );

                      }

                    },
                    child:  Text(
                        "Add",
                        style: GoogleFonts.robotoSerif(
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
