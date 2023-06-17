
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:major_project/color_pallete/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../api/openai_service.dart';
import '../../widgets/feature_box.dart';

class ChatWithBot extends StatefulWidget {
  const ChatWithBot({Key? key}) : super(key: key);

  @override
  State<ChatWithBot> createState() => _ChatWithBotState();
}

class _ChatWithBotState extends State<ChatWithBot> {

  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();

  String lastWords = '';
  final OpenAIService openAiService = OpenAIService();

  String ? generatedContent;
  String ? generatedImgUrl;
  int start = 200;
  int delay = 200;


  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    initTextToSpeech();
    flutterTts.stop();
  }

  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }
  Future<void> systemSpeaks(String content) async{
    await flutterTts.speak(content);
  }

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {

    });

  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result)  {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.whiteColor,
        appBar: AppBar(
          backgroundColor: Pallete.whiteColor ,
          title: BounceInDown(
            child: const Text(
              'Ally',
              style: TextStyle(color: Colors.black),
            ),
          ),
          leading: const Icon(Icons.menu,color:Colors.black,),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //virtual assistant pic
              ZoomIn(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 125,
                        width: 125,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                            color: Pallete.assistantCircleColor,
                            shape: BoxShape.circle
                        ),
                      ),
                    ),
                    Container(
                      height: 127,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image:DecorationImage(image: AssetImage('assets/images/assistant_main.png'))
                      ),
                    )
                  ],
                ),
              ),
              //chat bubble
              FadeInRight(
                child: Visibility(
                  visible:generatedImgUrl != null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 30),
                    padding: const EdgeInsets.symmetric(horizontal:15 ,vertical:5 ),

                    decoration: BoxDecoration(
                        border: Border.all(color: Pallete.borderColor),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft:Radius.circular(15),
                            bottomRight: Radius.circular(15)
                        )
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        generatedContent ==null?
                        'Good Morning, what can I do for you?':generatedContent!,
                        style:  TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: generatedContent == null ?22:18,
                            fontFamily: 'Cera Pro'
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if(generatedImgUrl!= null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                    child: Image.network(generatedImgUrl ?? '')),
              ),
              SlideInRight(
                child: Visibility(
                  visible: generatedContent == null && generatedImgUrl == null,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.only(top: 10,left: 22),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                        'Here are a few features',
                        style: TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: 18,
                            fontWeight:FontWeight.bold,
                            fontFamily: 'Cera Pro'
                        )
                    ),
                  ),
                ),
              ),

              //features List
              Visibility(
                visible: generatedContent == null && generatedImgUrl == null,
                child:   Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children:[
                      SlideInLeft(
                        delay: Duration(milliseconds: start),
                        child: FeatureBox(
                          color: Pallete.firstSuggestionBoxColor,
                          header: 'ChatGPT',
                          description: 'A smarter way to stay organized and informed with ChatGPT' ,
                        ),
                      ),
                      SlideInLeft(
                        delay: Duration(milliseconds: start + delay),
                        child: FeatureBox(
                          color: Pallete.secondSuggestionBoxColor,
                          header: 'Dall-E',
                          description: 'Get inspired and stay creative with your personal AI designer Dall-E',
                        ),
                      ),
                      SlideInLeft(
                        delay: Duration(milliseconds: start + delay * 2),
                        child: FeatureBox(
                          color: Pallete.thirdSuggestionBoxColor,
                          header: 'Smart Voice Assistant',
                          description: 'Unleash the best: Voice assistant fueled by Dall-E and ChatGPT.',
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        floatingActionButton: ZoomIn(
          delay:  Duration(milliseconds:start + delay * 3),
          child: FloatingActionButton(
            onPressed: () async {
              if(await speechToText.hasPermission && speechToText.isNotListening){
                await startListening();
                log("stated listening");

              }else if(speechToText.isListening){
                
                final speech = await openAiService.isArtPromptAPI(lastWords);
                if(speech.contains('https')){
                  generatedImgUrl = speech;
                  generatedContent = null;
                  setState(() {});

                }else{
                  generatedContent = speech;
                  generatedImgUrl = null;
                  setState(() {});
                  await systemSpeaks(speech);
                }

                stopListening();

                Fluttertoast.showToast(msg: 'Stopped Listening');
              }else{
                initSpeechToText();
              }
            },
            backgroundColor: const Color(0xff2196F3),
            child:  Icon(speechToText.isListening? Icons.stop:
              CupertinoIcons.mic,size:30 ,color: Colors.white,),
          ),
        )
    );
  }
}
