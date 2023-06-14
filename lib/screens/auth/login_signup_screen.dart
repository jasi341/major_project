import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/nav_anim/login_nav_anim.dart';
import 'package:major_project/nav_anim/register_nav_anim.dart';
import 'package:major_project/screens/auth/signup.dart';
import '../../main.dart';
import 'login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {



  @override
  void initState() {
    super.initState();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:  EdgeInsets.only(top:mq.height*0.2),
            child: Center(child: AnimatedImage()),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:mq.width*0.1,vertical: 45),
            child: Column(
              children: [

                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      LoginNavAnim(builder: (context) =>  const Login()));
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) =>  const SignUp()));
                    Navigator.push(
                        context,
                        RegisterNavAnim(builder: (context)=>const SignUp())
                    );
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
            ),
          )
        ],
      ),
    );
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
      duration: const Duration(seconds: 1)
  )..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
      begin: Offset.zero,
      end: const Offset(0,0.08)
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));



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
              padding:  EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('assets/images/ic.png',height: mq.height*0.7,width: mq.width*0.7,),
            ),
          ),
        ],
      ),
    );
  }
}
