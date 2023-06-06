import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/chat_user.dart';

class UpdateProfileScreen extends StatefulWidget {
  final ChatUser user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailController.text = widget.user.email;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.blue[900],
          appBar: AppBar(
            title: const Text('Update Profile'),
          ),
          body:SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    const SizedBox( width: double.infinity,),
                    Stack(
                      children: [
                        CircleAvatar(
                          maxRadius: 75,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              height: 150,
                              width: 150,
                              imageUrl: widget.user.image,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const CircularProgressIndicator(color: Colors.green),
                              errorWidget: (context, url, error) =>  CircleAvatar(
                                child: Image.asset('assets/images/profile.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -15,
                          child: MaterialButton(
                            onPressed: (){},
                            shape:const CircleBorder(),
                            color: Colors.blue,
                            child:const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        maxLines: 1,
                        enabled: false,
                        controller: _emailController,
                        style: GoogleFonts.robotoSerif(color: Colors.white),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email,color: Colors.white,),
                          labelStyle: GoogleFonts.robotoSerif(color: Colors.white),
                          border:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          disabledBorder:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        initialValue: widget.user.name,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.robotoSerif(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          hintStyle: GoogleFonts.robotoSerif(color: Colors.white70),
                          prefixIcon: const Icon(Icons.person,color: Colors.white,),
                          labelStyle: GoogleFonts.robotoSerif(color: Colors.white),
                          border:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          disabledBorder:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        initialValue: widget.user.about,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.done,
                        style: GoogleFonts.robotoSerif(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'About',
                          hintText: 'Hey there! I am using ChatHub.',
                          hintStyle: GoogleFonts.robotoSerif(color: Colors.white70),
                          prefixIcon: const Icon(CupertinoIcons.info_circle,color: Colors.white,),
                          labelStyle: GoogleFonts.robotoSerif(color: Colors.white),
                          border:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          disabledBorder:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 5.0) ,
                      child: ElevatedButton(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            elevation: 10,
                            shadowColor: Colors.black54,
                            backgroundColor:Colors.blue
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save,color: Colors.white,),
                            const SizedBox(width: 5,),
                            Text(
                              'Update',
                              style: GoogleFonts.robotoSerif(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}





