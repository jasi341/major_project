import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/helper/dialogs.dart';
import 'package:major_project/nav_anim/login_nav_anim.dart';
import 'package:major_project/nav_anim/register_nav_anim.dart';
import 'package:major_project/screens/home_screen.dart';
import '../../main.dart';
import 'forgotpassword.dart';
import 'signup.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _obscureText = true;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

  _handleGoogleBtnClick(){
    Dialogs.showProgressBar(
        context,
        Colors.blueAccent
    );
    _signInWithGoogle().then((user){
      Navigator.pop(context);
      if(user!= null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen())
        );
      }

    });
  }

  Future<UserCredential?> _signInWithGoogle() async{

    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }catch(e){
      log("\n_signInWithGoogle:$e");
      Dialogs.showSnackbar(
          context,
          'Something went wrong!',
          Colors.red,
          SnackBarBehavior.floating,
          Colors.white
      );
    }
    return null;
  }



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
        title: const Text('Login'),
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
                    'Welcome Back!',
                    style: GoogleFonts.robotoSerif(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    )
                )
            ),
            Center(
                child: Text(
                    "Please,Log In.",
                    style: GoogleFonts.robotoSerif(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2
                    )
                )
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _emailController,
                maxLines: 1,
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
                textInputAction: TextInputAction.done,
                style: GoogleFonts.robotoSerif(color: Colors.white),
                cursorColor: Colors.white,
                obscureText: _obscureText,
                maxLines: 1,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        LoginNavAnim(builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 10.0) ,
              child: ElevatedButton(
                onPressed: (){
                  validate();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor:Colors.blue
                ),
                child:  Text(
                  'Login',
                  style: GoogleFonts.robotoSerif(
                      fontStyle: FontStyle.normal,
                      fontSize: 20
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,left: 20.0,top: 5.0) ,
              child: OutlinedButton(
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png',height: 30,width: 30,),
                    const SizedBox(width: 10,),
                    Text(
                      'Login with Google',
                      style: GoogleFonts.robotoSerif(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New to ChatHub?",
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
                      RegisterNavAnim(builder: (context) => const SignUp()),
                    );
                  },
                  child: Text(
                    'Sign Up',
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

    if(_emailController.text.trim().isEmpty){
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
        await APIs.auth.signInWithEmailAndPassword(email: email, password: password);

        if(mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              LoginNavAnim(builder: (context) => const HomeScreen()));
        }

      }on FirebaseAuthException catch(e){
        if(e.code == 'user-not-found'){
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        else if(e.code == 'wrong-password'){
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