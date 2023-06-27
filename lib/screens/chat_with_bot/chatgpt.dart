import 'dart:convert';
import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:major_project/color_pallete/pallete.dart';
import 'package:major_project/secrets.dart';

import 'model.dart';

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({super.key});

  @override
  State<ChatGptScreen> createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {

  bool isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool isBtnClicked = true;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  Future<String> generateResponse(String prompt) async {
    const apiKey = openAiApiKey;
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 0,
          'max_tokens': 2000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0
        })
    );
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    log("response:${newresponse['choices'][0]['text']}");

    return newresponse['choices'][0]['text'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInRight(child: const Text('ChatGPT')),
      ),
      backgroundColor:  const Color(0xffececec),
      body: Column(
        children: [
          Visibility(
            visible: isBtnClicked,
            child: Column(
              children: [
                Column(
                  children: [
                    const Icon(Icons.sunny),
                    const SizedBox(height: 5,),
                     Text(
                         'Examples',
                          style: GoogleFonts.robotoSerif(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                     ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      decoration: BoxDecoration(
                        color: Pallete.firstSuggestionBoxColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            _textController.text = "Explain quantum computing in simple terms";
                          },
                          child: const Column(
                            children: [
                              Text("Explain quantum computing in simple terms"),
                              Icon(Icons.arrow_forward_sharp)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      decoration: BoxDecoration(
                        color: Pallete.firstSuggestionBoxColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: (){
                          _textController.text = "Got any creative ideas for a 10 year old’s birthday?";
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("Got any creative ideas for a 10 year old’s birthday?"),
                              Icon(Icons.arrow_forward_sharp)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        _textController.text = "How do I make an HTTP request in Javascript?";
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        decoration: BoxDecoration(
                          color: Pallete.firstSuggestionBoxColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("How do I make an HTTP request in Javascript?"),
                              Icon(Icons.arrow_forward_sharp)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(child: _buildList()),
          Visibility(
              visible: isLoading,
              child: const SpinKitThreeBounce(
                color: Colors.black87,
                size: 25,)
          ),
          ElasticInRight(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff343541).withGreen(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildInput(),
                    _buildSubmit()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInput(){
    return Expanded(
        child:TextField(
          textCapitalization: TextCapitalization.sentences,
          style: GoogleFonts.roboto(color: Colors.black),
          controller:_textController ,
          // ime
          onSubmitted: (value) {
            validate();
          },
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            fillColor:   Colors.white70,
            filled: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder:InputBorder.none,
          ),
        )
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: Colors.white70,
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white70  ,
          ),
          onPressed: () {
           validate();
          },
        ),
      ),
    );
  }

  void _scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut
    );

  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context,index) {
        var message = _messages[index];
        return   ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void validate() {
    if(_textController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some text'),duration: Duration(milliseconds: 800),)
      );
      return;
    }
    setState(() {
      isBtnClicked = false;
      _messages.add(
          ChatMessage(text: _textController.text, chatMessageType: ChatMessageType.user)
      );
      isLoading = true;
    });
    var input = _textController.text;
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());

    generateResponse(input).then((value) {
      setState(() {
        isLoading = false;
        _messages.add(
            ChatMessage(text: value.trim(), chatMessageType: ChatMessageType.bot)
        );
      });
      _textController.clear();
      Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());


    } );
  }
}

class ChatMessageWidget extends StatelessWidget {

  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: chatMessageType == ChatMessageType.bot ?
         Colors.blueGrey.shade100 : Colors.blueGrey.shade200

      ),
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),


      child: BounceInDown(
        child: Row(
            children: [
              chatMessageType == ChatMessageType.bot? Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: const Color(0xff19a07f),
                  child: Image.asset(
                    'assets/images/openAi.png',
                    height: 40, width: 40,
                    color: Colors.white,
                    scale: 1.5,
                  ),
                ),

              ):
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: const CircleAvatar(
                  child: Icon(CupertinoIcons.profile_circled,size: 40,),
                ),
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      text,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color:Colors.black87,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )

                ],
              ))
            ]
        ),
      ),
    );
  }
}

