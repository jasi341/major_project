import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:major_project/screens/splash_screen.dart';
import 'package:major_project/widgets/vid.dart';


late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x1A000080),
      systemNavigationBarColor: Colors.teal// Set your desired color here
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);


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
      home: const SplashScreen(),
    );
  }
}



