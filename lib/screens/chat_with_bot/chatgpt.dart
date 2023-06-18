import 'dart:convert';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
      backgroundColor: const Color(0xff343541),
      body: Column(
        children: [
          Expanded(child: _buildList()),
          Visibility(
              visible: isLoading,
              child: const SpinKitThreeBounce(
                color: Colors.black,
                size: 25,)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildInput(),
                _buildSubmit()
              ],
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
          style: GoogleFonts.roboto(color: Colors.white),
          controller:_textController ,
          decoration: InputDecoration(
            fillColor:  const Color(0xff444654).withOpacity(0.9),
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
        color: const Color(0xff444654).withOpacity(0.9),
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white70  ,
          ),
          onPressed: () {
            setState(() {
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
}

class ChatMessageWidget extends StatelessWidget {

  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      color: chatMessageType == ChatMessageType.bot ?
      const Color(0xff444654).withOpacity(0.9)
          : const Color(0xff343541).withOpacity(0.9),

      child: Row(
          children: [
            chatMessageType == ChatMessageType.bot? Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: const Color(0xff19a07f),
                child: Image.asset(
                  'assets/images/openAi.png',
                  height: 30, width: 30,
                  color: Colors.white,
                  scale: 1.5,
                ),
              ),

            ):
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                child: Icon(CupertinoIcons.profile_circled),
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
                      color:Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )

              ],
            ))
          ]
      ),
    );
  }
}

