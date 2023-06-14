import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:major_project/api/apis.dart';
import '../data/chat_user.dart';
import '../helper/dialogs.dart';

class UpdateProfileScreen extends StatefulWidget {
  final ChatUser user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  String? _imagePath;

  bool dismiss = false;

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
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    const SizedBox( width: double.infinity,),
                    Stack(
                      children: [
                        _imagePath != null ?
                            //local image
                        CircleAvatar(
                          maxRadius: 75,
                          child: ClipOval(
                            child: Image.file(
                              File(_imagePath!),
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ):

                        //img form server
                        CircleAvatar(
                          maxRadius: 75,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              height: 150,
                              width: 150,
                              imageUrl: widget.user.image,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.amberAccent),
                              ),
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
                            onPressed: (){
                              _showBottomSheet();
                            },
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
                        onSaved: (value) =>APIs.me.name = value ?? '' ,
                        validator: (value)=> value!=null && value.trim().isNotEmpty? null :'Please enter your name',
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
                        onSaved: (value) =>APIs.me.about = value ?? '' ,
                        validator: (value)=> value!=null && value.trim().isNotEmpty? null :'Please enter your about',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) => _validateAndSubmit(),
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
                          _validateAndSubmit();


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

  void _validateAndSubmit() {

    if(_formKey.currentState!.validate()){
      Dialogs.showProgressBar(context, Colors.lightBlueAccent, 'Updating...');
      Future.delayed(const Duration(milliseconds: 500),(){

        _formKey.currentState!.save();
        APIs.updateUserInfo().then((value) {
          Dialogs.showSnackbar(context, "Data Updated", Colors.grey.shade50, SnackBarBehavior.floating, Colors.black);
        }) ;
        Navigator.pop(context);
      });

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
                            'Pick a Profile Picture',
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
                                final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                                if(image!= null){
                                  setState(() {
                                    _imagePath = image.path;
                                  });
                                  APIs.updateProfilePicture(File(_imagePath!));
                                  if(mounted) {
                                    Navigator.pop(context);
                                  }
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
                                    Image.asset('assets/images/camera.png',width: 60,height: 60,),
                                    const SizedBox(height:5),
                                    Text('Camera',style: GoogleFonts.acme(fontSize: 22,),),
                                  ],
                                ),
                              ),
                            ),
                          ),


                          //for gallery
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
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                                if(image!= null){
                                  setState(() {
                                    _imagePath = image.path;
                                  });
                                  APIs.updateProfilePicture(File(_imagePath!));
                                  if(mounted) {
                                    Navigator.pop(context);
                                  }
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
                                    Image.asset('assets/images/gallery.png',width: 60,height: 60,),
                                    const SizedBox(height:5),
                                    Text('Gallery',style: GoogleFonts.acme(fontSize: 22,),),
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
              )
          );
        }
        );

  }
}





