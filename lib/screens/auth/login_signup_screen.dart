import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/screens/auth/signup.dart';
import '../../main.dart';
import 'login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.blue[900],
      appBar:
      AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to ChatHub'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * 0.15,
              width: mq.width * 0.5,
              left:_isAnimate? mq.width*0.25: mq.width*0.5,
              duration: const Duration(seconds: 2),
              child: Image.asset('assets/images/ic.png')
          ),
          Positioned(
              bottom : mq.height * 0.05,
              width: mq.width * 0.8,
              left: mq.width*0.1,
              child: Column(
                children: [

                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Login()));
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
                  const SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const SignUp()));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: Colors.green
                    ),
                    child:  Text(
                      'Register',
                      style: GoogleFonts.robotoSerif(
                          fontStyle: FontStyle.normal,
                          fontSize: 20
                      ),
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
