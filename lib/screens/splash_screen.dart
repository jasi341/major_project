import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/screens/home_screen.dart';

import 'auth/login_signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isTextAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        _isTextAnimated = true;
      });
    });

    Future.delayed(const Duration(seconds: 2),(){

      if(APIs.auth.currentUser != null){
        log('\n sPLASH :${APIs.auth.currentUser}');
        Navigator.pushReplacement
          (context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }

      else{
        Navigator.pushReplacement
          (context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }


    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xff0D2329),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/splash.json', // Path to your Lottie animation file
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.width*0.9,
              fit: BoxFit.fill,
              animate: true,
              repeat: true,
            ),
            AnimatedDefaultTextStyle(
              style: _isTextAnimated
                  ? GoogleFonts.robotoSerif(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
                  : GoogleFonts.robotoSerif(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.orangeAccent,
              ),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInCubic,
              child: const Text('ChatHub'),
            ),
          ],
        ),
      ),
    );
  }
}
