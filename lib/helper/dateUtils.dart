import 'package:flutter/material.dart';

class MyDateUtils {
  static String getFormattedDate({required BuildContext context,required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
