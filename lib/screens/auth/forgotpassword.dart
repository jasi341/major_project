import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/helper/dialogs.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);


  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _emailController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 7,
            child: Text('Reset Password',
              style: GoogleFonts.robotoSerif(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 7,
            right: 7,
            child: Text(
              'Enter the email address associated with your account and we\'ll send you a link to reset your password.',
              style: GoogleFonts.robotoSerif(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: TextField(
              controller: _emailController,
              onSubmitted: (value){
                validateAndSave();
              },
              style: GoogleFonts.robotoSerif(color: Colors.black54),
              cursorColor: Colors.blue,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email,color: Colors.grey,),
                labelStyle: GoogleFonts.robotoSerif(color: Colors.grey),
                border:  const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: (){
                validateAndSave();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  backgroundColor:const Color(0xff7B3AED)
              ),
              child:  Text(
                'Send Reset Link',
                style: GoogleFonts.robotoSerif(
                    fontStyle: FontStyle.normal,
                    fontSize: 20
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateAndSave() {
    if(_emailController.text.trim().isEmpty){
      Fluttertoast.showToast(
        msg: "Email cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else if(!emailRegex.hasMatch(_emailController.text)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Email is not valid"),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      );
    }
    else{
      APIs.auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Dialogs.showProgressBar(context, Colors.blue);


      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Reset link sent to your email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      });


      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });

    }
  }
}
