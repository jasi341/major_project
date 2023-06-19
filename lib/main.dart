import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:major_project/screens/splash_screen.dart';



late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing notifications from chats.',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',

  );
  log(result.toString());
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  log("Background Message Handler Set");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0x1A000080),
      systemNavigationBarColor: Colors.transparent// Set your desired color here
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);


    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatHub",
      theme: ThemeData(
        useMaterial3: true,
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
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  // Custom logic or actions based on the received message can be implemented here.
}
Future<void> backgroundHandler(RemoteMessage message) async {
  await _firebaseMessagingBackgroundHandler(message);
}




