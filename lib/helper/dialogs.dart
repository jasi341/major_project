import 'package:flutter/material.dart';


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
      Color progressColor
      )
  {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return  Center(
              child: Card(
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: progressColor,),
                ),
              )
          );
        }
    );
  }
}