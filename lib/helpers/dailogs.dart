import 'package:flutter/material.dart';

class Dailogas {
  showSnackBar(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)));
  }

  showProgresIndicator(context) {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
