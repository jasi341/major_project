import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Dialogs{

  static void showSnackbar(
      BuildContext context,
      String msg,
      Color backgroundColor,
      SnackBarBehavior snackBarBehavior,
      Color textColor
      ){
    ScaffoldMessenger
        .of(context)
        .showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(msg,style:  TextStyle(color: textColor ),),
          backgroundColor: backgroundColor,
          behavior: snackBarBehavior,
        )
    );

  }

  static void showProgressBar(
      BuildContext context,
      Color progressColor,
      String text
      )
  {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return  Center(
              child: Card(
                shadowColor: Colors.black,
                color: Colors.white,
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      CircularProgressIndicator(color: progressColor,),
                      SizedBox(height: 10,),
                      Text(text,style:GoogleFonts.robotoSerif(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}