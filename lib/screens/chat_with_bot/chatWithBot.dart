
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:major_project/color_pallete/pallete.dart';
import 'package:major_project/screens/chat_with_bot/chatgpt.dart';
import 'package:major_project/screens/chat_with_bot/dalle.dart';

class ChatWithBot extends StatefulWidget {
  const ChatWithBot({Key? key}) : super(key: key);

  @override
  State<ChatWithBot> createState() => _ChatWithBotState();
}

class _ChatWithBotState extends State<ChatWithBot> {

  bool _isLoading = false;
  int delayAmount = 200;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Bot'),
      ),
      body: Column(
        children: [
          JelloIn(
              child: Text(
                'How can I help you today? ',
                style: GoogleFonts.robotoSerif(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )
          ),
          const SizedBox(height: 20,),
          ZoomIn(
            delay:  Duration(milliseconds: delayAmount),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallete.assistantCircleColor,
                ),
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Lottie.asset(
                    'assets/animation/bot1.json',
                    repeat: true,
                    reverse: true,
                    animate: true,
                    filterQuality: FilterQuality.high,
                    frameRate: FrameRate.max,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideInLeft(
                  delay:  Duration(milliseconds: delayAmount* 2),
                  child: Card(
                    elevation: 25,
                    color: const Color(0xff19a07f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>const ChatGptScreen()
                        )
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/openAi.png', height: 70, width: 70,),
                                const SizedBox(height: 4,),
                                Text(
                                  'ChatGPT',
                                  style: GoogleFonts.robotoSerif(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                  ),
                                ),
                                const SizedBox(height: 8,),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SlideInRight(
                  delay:  Duration(milliseconds: delayAmount* 3),
                  child: Card(
                    color:  Colors.black,
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_)=>const DalleScreen()
                              )
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/openAi.png', height: 70, width: 70,),
                                const SizedBox(height: 4,),
                                Text(
                                  'Dalle-E',
                                  style: GoogleFonts.robotoSerif(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                  ),
                                ),
                                const SizedBox(height: 8,),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
