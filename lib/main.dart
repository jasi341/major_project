import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/screens/auth/login_signup_screen.dart';
import 'screens/home_screen.dart';


late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x1A000080), // Set your desired color here
    ));
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatHub",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              centerTitle: true,
              elevation: 1.5,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: GoogleFonts.robotoSerif(fontStyle: FontStyle.normal,color: Colors.white,fontSize: 20),
              backgroundColor: const Color(0xB3000080),
          )
      ),
      home: const LoginScreen(),
    );
  }
}



