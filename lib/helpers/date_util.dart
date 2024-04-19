import 'package:flutter/material.dart';

class DateUtil {
  //formated time
  String getFormatedDate(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
