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

  showBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (builder) {
          return ListView(
            children: const [
              Text(
                'Pick a Profile Picture',
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        });
  }
}
