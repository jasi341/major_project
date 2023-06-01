import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/nav_anim/login_nav_anim.dart';
import 'package:major_project/nav_anim/register_nav_anim.dart';
import 'package:major_project/screens/auth/login.dart';
import 'package:major_project/screens/tnc/terms_and_conditions.dart';
import 'package:major_project/screens/user_profile.dart';
import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _obscureText = true;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    //make the status bar transparent

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      backgroundColor: Colors.blue[900],
      resizeToAvoidBottomInset: true,
      body:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5,),
            const AnimatedImage(),
            Center(
                child: Text(
                    'Hi There!',
                    style: GoogleFonts.robotoSerif(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    )
                )
            ),
            Center(
                child: Text(
                    "Let's get you started",
                    style: GoogleFonts.robotoSerif(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2
                    )
                )
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nameController,
                style: GoogleFonts.robotoSerif(color: Colors.white),
                cursorColor: Colors.white,
                keyboardType: TextInputType.name,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person,color: Colors.white,),
                  labelStyle: GoogleFonts.robotoSerif(color: Colors.white),
                  border:  const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                maxLines: 1,
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
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _passwordController,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.robotoSerif(color: Colors.white),
                cursorColor: Colors.white,
                obscureText: _obscureText,
                onSubmitted: (value) {
                  validate();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock,color: Colors.white,),
                  suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.white,size: 30,
                      )
                  ),
                  labelStyle: GoogleFonts.robotoSerif(color: Colors.white),
                  border:  const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),

                ),
              ),
            ),
            const SizedBox(height: 10,),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By signing up you agree to our',
                  style: GoogleFonts.robotoSerif(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(width: 5,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const TermsOfUseScreen()));
                  },
                  child: Text('Terms of Use',
                      style: GoogleFonts.robotoSerif(
                          color: Colors.white,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 5.0) ,
              child: ElevatedButton(
                onPressed: (){
                  validate();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor:Colors.blue
                ),
                child:  Text(
                  'Continue',
                  style: GoogleFonts.robotoSerif(
                      fontStyle: FontStyle.normal,
                      fontSize: 20
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Joined us before?",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      LoginNavAnim(builder: (context) => const Login()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
          ],


        ),
      ),
    );
  }

  Future<void> validate() async {
    if(_nameController.text.trim().isEmpty){
      Fluttertoast.showToast(
        msg: "Name cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else if(_emailController.text.trim().isEmpty){
      Fluttertoast.showToast(
        msg: "Email cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else if(_passwordController.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Password cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else if(_passwordController.text.length<6){
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters long",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else if(!emailRegex.hasMatch(_emailController.text)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Email is not valid"),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      );

    }
    else{
      Dialogs.showProgressBar(context, Colors.lightGreen);
      try{

        final email =_emailController.text.trim();
        final password = _passwordController.text;
        await APIs.auth.createUserWithEmailAndPassword(email: email, password: password);
        await APIs.auth.currentUser!.updateDisplayName(_nameController.text);

        if(mounted) {
          log('user name ${_nameController.text}');
          log('${APIs.auth.currentUser}');



          Fluttertoast.showToast(
            msg: "User info ${APIs.auth.currentUser}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              RegisterNavAnim(builder: (context) => const UserProfile()));
        }

      }on FirebaseAuthException catch(e){
        if(e.code == 'email-already-in-use'){
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Email already in use",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        else if(e.code == 'email-already-in-use'){
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        else {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    }
  }
}

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({Key? key}) : super(key: key);

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
      vsync:this,
      duration: const Duration(seconds: 2)
  )..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
      begin: Offset.zero,
      end: const Offset(0,0.08)
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInQuint));



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height *0.2,
      child: Stack(
        children: [
          SlideTransition(
            position: _animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('assets/images/icon_1.png'),
            ),
          ),
        ],
      ),
    );
  }
}